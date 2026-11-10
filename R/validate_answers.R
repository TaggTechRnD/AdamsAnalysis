#' Validate Research Questionnaire Answers
#'
#' @param answers Named list of questionnaire responses.
#' @return TRUE if valid; otherwise raises an error.
#' @export

validate_answers <- function(answers = list()) {

  if (!is.list(answers)) {
    stop("Answers must be a named list.")
  }

  if (length(answers) == 0) return(TRUE)

  if (is.null(names(answers)) ||
      any(!nzchar(names(answers))) ||
      anyDuplicated(names(answers))) {
    stop("Answers require unique question IDs.")
  }

  for (id in names(answers)) {

    if (!id %in% questionnaire$question_id) {
      stop(paste("Unknown question:", id))
    }

    value <- answers[[id]]

    if (id == "Q10") {
      if (!is.numeric(value) || length(value) != 1 ||
          is.na(value) || !is.finite(value) ||
          value < 1 || value %% 1 != 0) {
        stop("Sample size must be a positive whole number.")
      }
    } else {

      allowed <- questionnaire_options$option_value[
        questionnaire_options$question_id == id
      ]

      if (!is.character(value) || length(value) != 1 ||
          is.na(value) || !value %in% allowed) {
        stop(paste("Invalid response for:", id))
      }
    }
  }

  hidden <- setdiff(names(answers), visible_questions(answers))

  if (length(hidden) > 0) {
    stop(paste("Responses to hidden questions:",
               paste(hidden, collapse = ", ")))
  }

  TRUE
}
