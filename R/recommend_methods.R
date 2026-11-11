#' Recommend Statistical Analysis Methods
#'
#' Builds a provisional report from filtered and ranked methods.
#' A score of zero means no preference matched, NOT that no method fits.
#'
#' @param answers Named list of questionnaire answers.
#' @param n_alternatives Maximum number of alternatives.
#' @return List of recommendations and supporting information.
#' @export
recommend_methods <- function(answers = list(), n_alternatives = 3L) {
  validate_answers(answers)
  if (!is.numeric(n_alternatives) || length(n_alternatives) != 1L ||
      is.na(n_alternatives) || !is.finite(n_alternatives) ||
      n_alternatives < 1 || n_alternatives %% 1 != 0) {
    stop("n_alternatives must be a positive whole number.")
  }

  visible <- visible_questions(answers)
  missing <- setdiff(visible, names(answers))
  missing_questions <- questionnaire[
    questionnaire$question_id %in% missing,
    c("question_id", "question"), drop = FALSE
  ]
  characteristics <- interpret_answers(answers)
  candidates <- rank_methods(answers)
  idx <- match(candidates$method_id, analysis_catalogue$method_id)
  candidates <- cbind(candidates, analysis_catalogue[idx,
    c("description", "when_to_use", "assumptions", "example"), drop = FALSE])
  rownames(candidates) <- NULL

  primary <- candidates[FALSE, , drop = FALSE]
  alternatives <- candidates[FALSE, , drop = FALSE]

  objective_known <- !is.null(answers$Q01) && answers$Q01 != "unknown"
  requires_outcome <- !is.null(answers$Q01) &&
    !answers$Q01 %in% c("latent", "cluster")
  outcome_known <- !is.null(answers$Q02) &&
    !answers$Q02 %in% c("unknown", "none")

  if (!objective_known || (requires_outcome && !outcome_known)) {
    status <- "insufficient_information"
    message <- "Specify the research objective and relevant outcome type."
    alternatives <- head(candidates, n_alternatives)

  } else if (nrow(candidates) == 0L) {
    status <- "no_match"
    message <- "No methods satisfy the known requirements. Review the study design."

  } else if (candidates$ranking_score[1L] <= 0) {
    status <- "multiple_candidates"
    message <- paste(
      "Compatible methods exist, but current questionnaire responses",
      "do not distinguish a preferred method."
    )
    alternatives <- head(candidates, n_alternatives)

  } else {
    top <- candidates[candidates$ranking_score == candidates$ranking_score[1L],
                      , drop = FALSE]
    verified <- top[top$status == "eligible", , drop = FALSE]

    # A single eligible method wins a score tie with unverified candidates.
    chosen <- if (nrow(top) == 1L) top else if (nrow(verified) == 1L) verified else NULL

    if (is.null(chosen)) {
      status <- "multiple_candidates"
      message <- "Several methods are equally suitable; no unique choice is supported."
      alternatives <- head(candidates, n_alternatives)
    } else {
      status <- "provisional_recommendation"
      message <- paste(
        "A preferred candidate was identified, but statistical assumptions",
        "and outstanding requirements still need verification."
      )
      primary <- chosen
      alternatives <- head(
        candidates[candidates$method_id != chosen$method_id, , drop = FALSE],
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
