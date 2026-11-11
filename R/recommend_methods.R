
#' Recommend Statistical Analysis Methods
#'
#' Combines eligibility filtering and ranking into
#' a structured research recommendation.
#'
#' @param answers Named list of questionnaire answers.
#' @param n_alternatives Maximum number of alternatives.
#' @return List containing recommendations and explanations.
#' @export

recommend_methods <- function(answers = list(),
                              n_alternatives = 3L) {

  validate_answers(answers)

  if (!is.numeric(n_alternatives) ||
      length(n_alternatives) != 1L ||
      is.na(n_alternatives) ||
      !is.finite(n_alternatives) ||
      n_alternatives < 1 ||
      n_alternatives %% 1 != 0) {
    stop("n_alternatives must be a positive whole number.")
  }

  # Identify relevant unanswered questions
  visible <- visible_questions(answers)
  missing <- setdiff(visible, names(answers))

  missing_questions <- questionnaire[
    questionnaire$question_id %in% missing,
    c("question_id", "question"),
    drop = FALSE
  ]

  # Interpret answers and rank compatible methods
  characteristics <- interpret_answers(answers)
  candidates <- rank_methods(answers)

  # Add explanations from the catalogue
  idx <- match(candidates$method_id,
               analysis_catalogue$method_id)

  candidates <- cbind(
    candidates,
    analysis_catalogue[idx, c(
      "description", "when_to_use",
      "assumptions", "example"
    ), drop = FALSE]
  )

  rownames(candidates) <- NULL

  # Default: no primary recommendation
  primary <- candidates[FALSE, , drop = FALSE]
  alternatives <- candidates[FALSE, , drop = FALSE]

  if (nrow(candidates) == 0L) {

    status <- "no_match"
    message <- paste(
      "No methods satisfy the known requirements.",
      "Review the study characteristics."
    )

  } else {

    top_score <- max(candidates$ranking_score)
    tied <- sum(candidates$ranking_score == top_score)

    has_objective <- !is.null(answers$Q01) &&
      answers$Q01 != "unknown"

    sufficient <- has_objective && top_score > 0

    if (!sufficient) {

      status <- "insufficient_information"
      message <- paste(
        "There is insufficient evidence to",
        "identify a preferred method."
      )

      alternatives <- head(candidates, n_alternatives)

    } else if (tied > 1L) {

      status <- "multiple_candidates"
      message <- paste(
        "Several methods have equal suitability scores.",
        "No unique primary recommendation can be made."
      )

      alternatives <- head(candidates, n_alternatives)

    } else {

      status <- "provisional_recommendation"
      message <- paste(
        "A preferred candidate was identified.",
        "Verify its assumptions and outstanding",
        "requirements before using it."
      )

      primary <- candidates[1, , drop = FALSE]

      alternatives <- head(
        candidates[-1, , drop = FALSE],
        n_alternatives
      )
    }
  }

  list(
    status = status,
    message = message,
    characteristics = characteristics,
    primary = primary,
    alternatives = alternatives,
    missing_questions = missing_questions,
    candidates = candidates
  )
}
