
#' Rank Statistical Analysis Methods
#'
#' Ranks eligible methods using questionnaire answers.
#' Statistical assumptions are flagged, not assumed satisfied.
#'
#' @param answers Named list of questionnaire answers.
#' @param include_excluded Include excluded methods for QA/QC.
#' @return Ranked data frame of candidate methods.
#' @export
rank_methods <- function(answers = list(),
                         include_excluded = FALSE) {

  x <- interpret_answers(answers)
  result <- filter_methods(answers, include_excluded)

  if (nrow(result) == 0) return(result)

  metadata <- analysis_catalogue[
    match(result$method_id, analysis_catalogue$method_id),
  ]

  is_answer <- function(field, values) {
    v <- x[[field]]
    length(v) == 1 && !is.na(v) && v %in% values
  }

  split_tags <- function(z) {
    if (is.na(z) || !nzchar(z)) return(character())
    strsplit(z, "|", fixed = TRUE)[[1]]
  }

  # Preferences supported by questionnaire responses
  preferences <- character()

  if (is_answer("distribution", "non_normal"))
    preferences <- c(preferences, "skewed_data",
                     "robust_summary", "ordinal_or_skewed_outcome")

  if (is_answer("objective", "compare") &&
      is_answer("observation_structure", c("paired", "repeated")))
    preferences <- c(preferences, "within_subject_change",
                     "two_related_measurements")

  if (is_answer("objective", "compare") &&
      is_answer("group_count", c("two", "three_plus")) &&
      is_answer("observation_structure", "repeated"))
    preferences <- c(preferences, "group_by_time_interaction")

  if (is_answer("objective", "causal") &&
      is_answer("intervention_comparison", "yes") &&
      is_answer("pre_post", "yes"))
    preferences <- c(preferences,
                     "quasi_experimental_causal_effect")

  if (is_answer("delayed_effects", "yes") &&
      is_answer("nonlinear_effects", "yes"))
    preferences <- c(preferences,
                     "lagged_nonlinear_exposure_effects")

  if (is_answer("prediction_priority", "accuracy"))
    preferences <- c(preferences, "prediction_accuracy",
                     "predictive_accuracy")

  if (is_answer("prediction_priority", "interpret"))
    preferences <- c(preferences, "interpretable_prediction")

  if (is_answer("objective", "latent") &&
      is_answer("predefined_factor_structure", "yes"))
    preferences <- c(preferences, "confirmatory_latent_factors")

  if (is_answer("objective", "latent") &&
      is_answer("predefined_factor_structure", "no"))
    preferences <- c(preferences, "latent_factor_discovery")

  if (is_answer("objective", "forecast"))
    preferences <- c(preferences, "autocorrelated_forecasting",
                     "simple_time_series_forecast")

  # Score only explicitly supported preferences
  matches <- lapply(metadata$ranking_preferences, function(z) {
    intersect(split_tags(z), preferences)
  })

  result$ranking_score <- vapply(matches, length, integer(1)) * 2

  result$ranking_reasons <- vapply(matches, function(z) {
    paste(gsub("_", " ", z), collapse = "; ")
  }, character(1))

  # Retain all statistical assumptions for review
  result$assumptions_to_check <- metadata$assumption_checks

  # Flag concerns without claiming assumptions were tested
  result$assumption_flags <- vapply(
    metadata$assumption_checks,
    function(z) {

      checks <- split_tags(z)
      flags <- character()

      if ("parallel_trends" %in% checks &&
          is_answer("parallel_trends", "no"))
        flags <- c(flags, "Parallel trends appear implausible")

      normality_checks <- c(
        "normal_residuals", "normal_pair_differences",
        "normal_observations", "multivariate_normality"
      )

      if (any(normality_checks %in% checks) &&
          is_answer("distribution", "non_normal"))
        flags <- c(flags, "Investigate model-specific normality")

      paste(flags, collapse = "; ")
    },
    character(1)
  )

  # Serious concern: deprioritize DiD if trends implausible
  concern <- result$method_id == "AA30" &
    is_answer("parallel_trends", "no")

  result$ranking_score[concern] <-
    result$ranking_score[concern] - 10

  # Excluded methods cannot receive a recommendation rank
  result$ranking_score[result$status == "excluded"] <- NA_real_

  result <- result[
    order(
      result$status == "excluded",
      -result$ranking_score,
      result$status == "needs_review",
      result$method_id,
      na.last = TRUE
    ),
  ]

  result$rank <- NA_integer_
  eligible <- which(result$status != "excluded")
  result$rank[eligible] <- rank(
    -result$ranking_score[eligible],
    ties.method = "min"
  )

  rownames(result) <- NULL
  result
}
