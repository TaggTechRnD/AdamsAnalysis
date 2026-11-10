#' Interpret Research Questionnaire Responses
#'
#' Converts questionnaire responses into structured
#' research characteristics for the recommendation engine.
#'
#' @param answers Named list of questionnaire responses.
#' @return Named list of research characteristics.
#' @export

interpret_answers <- function(answers = list()) {

  # Validate responses using our existing function
  validate_answers(answers)

  # Map questionnaire IDs to research characteristics
  fields <- c(
    objective = "Q01",
    outcome_type = "Q02",
    outcome_count = "Q03",
    predictor_type = "Q04",
    predictor_count = "Q05",
    group_count = "Q06",
    timepoints = "Q07",
    observation_structure = "Q08",
    study_design = "Q09",
    sample_size = "Q10",
    balanced = "Q11",
    distribution = "Q12",
    intervention_comparison = "Q13",
    pre_post = "Q14",
    parallel_trends = "Q15",
    delayed_effects = "Q16",
    nonlinear_effects = "Q17",
    censoring = "Q18",
    predefined_factor_structure = "Q19",
    prediction_priority = "Q20"
  )

  # Extract answers, preserving missing responses
  result <- lapply(fields, function(id) {

    value <- answers[[id]]

    if (is.null(value)) {
      if (id == "Q10") return(NA_real_)
      return(NA_character_)
    }

    value
  })

  # Derive useful characteristics
  # Unknown responses must not be treated as FALSE
  flag <- function(value, positive) {
    if (is.na(value) || value == "unknown") {
      return(NA)
    }
    value %in% positive
  }

  result$multiple_groups <- flag(
    result$group_count,
    c("two", "three_plus")
  )

  result$multiple_timepoints <- flag(
    result$timepoints,
    c("two", "three_plus", "sequential")
  )

  return(result)
}
