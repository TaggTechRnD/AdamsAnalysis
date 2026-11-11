#' Rank Statistical Analysis Methods
#'
#' Applies only preferences supported by the questionnaire; never treats
#' unasked assumptions (e.g. equal variances) as observed facts.
#'
#' @param answers Named list of coded questionnaire responses.
#' @param include_excluded Include excluded methods for QA/QC.
#' @return Ranked data frame of candidate methods.
#' @export
rank_methods <- function(answers = list(), include_excluded = FALSE) {

  x <- interpret_answers(answers)
  result <- filter_methods(answers, include_excluded = include_excluded)
  if (nrow(result) == 0L) return(result)

  metadata <- analysis_catalogue[
    match(result$method_id, analysis_catalogue$method_id), , drop = FALSE
  ]

  is_answer <- function(field, values) {
    v <- x[[field]]
    length(v) == 1L && !is.na(v) && v %in% values
  }
  split_tags <- function(z) {
    if (is.na(z) || !nzchar(z)) return(character())
    trimws(strsplit(z, "|", fixed = TRUE)[[1L]])
  }

  # Each tag is emitted only when the corresponding evidence is supplied.
  tags <- character()
  add <- function(tag, condition) {
    if (isTRUE(condition)) tags <<- unique(c(tags, tag))
  }

  comparing <- is_answer("objective", c("compare", "causal"))
  associating <- is_answer("objective", c("associate", "predict", "classify"))
  two_groups <- is_answer("group_count", c("two", "three_plus"))
  one_group <- is_answer("group_count", "one")
  two_times <- is_answer("timepoints", "two")
  repeated_times <- is_answer("timepoints", c("two", "three_plus", "sequential"))
  long_repeated <- is_answer("timepoints", c("three_plus", "sequential"))
  related <- is_answer("observation_structure", c("paired", "repeated"))
  correlated <- is_answer("observation_structure", c("paired", "repeated", "clustered"))
  skewed <- is_answer("distribution", "non_normal")
  ordinal <- is_answer("outcome_type", "ordinal")
  multiple_predictors <- is_answer("predictor_count", "multiple")

  # Description and associations
  add("simple_description", is_answer("objective", "describe") &&
      is_answer("outcome_type", "continuous"))
  add("categorical_description", is_answer("objective", "describe") &&
      is_answer("outcome_type", c("binary", "nominal", "ordinal")))
  add(c("skewed_data", "robust_summary"),
      is_answer("objective", "describe") && skewed)
  add("ordinal_or_skewed_association",
      is_answer("objective", "associate") && (ordinal || skewed))
  add("categorical_association",
      is_answer("objective", "associate") &&
      is_answer("outcome_type", c("binary", "nominal", "ordinal")) &&
      is_answer("predictor_type", c("categorical", "both")))
  add("binary_continuous_association",
      is_answer("objective", "associate") &&
      is_answer("outcome_type", "continuous") && two_groups &&
      is_answer("predictor_type", c("categorical", "both")))

  # Group comparisons and repeated measures
  add("ordinal_or_skewed_outcome", comparing && (ordinal || skewed))
  add("two_related_measurements", comparing && one_group && two_times && related)
  add("paired_skewed_data", comparing && one_group && two_times && related && skewed)
  add("paired_binary_change", comparing && one_group && two_times && related &&
      is_answer("outcome_type", "binary"))
  add("within_subject_change", comparing && one_group && long_repeated && related)
  add("nonparametric_repeated_measures", comparing && one_group &&
      long_repeated && related && skewed)
  add("group_by_time_interaction", comparing && two_groups &&
      repeated_times && related)
  add("one_grouping_factor", comparing &&
      is_answer("group_count", "three_plus") &&
      is_answer("timepoints", "one") &&
      is_answer("predictor_count", "one"))
  add("joint_outcome_test", comparing && is_answer("outcome_type", "continuous") &&
      is_answer("outcome_count", "multiple"))

  # Conventional regression and correlated observations
  add("one_predictor", associating && is_answer("predictor_count", "one"))
  add("multiple_predictors", associating && multiple_predictors)
  add("binary_outcome", associating && is_answer("outcome_type", "binary"))
  add("count_outcome", associating && is_answer("outcome_type", "count"))
  add("ordered_outcome", associating && ordinal)
  add("multiclass_nominal_outcome", associating && is_answer("outcome_type", "nominal"))
  add("continuous_proportion", associating && is_answer("outcome_type", "proportion"))
  add("correlated_observations", correlated && is_answer("outcome_type", "continuous"))
  add("non_gaussian_correlated_outcome", correlated &&
      is_answer("outcome_type", c("binary", "ordinal", "count", "proportion")))
  add("unadjusted_survival_curve", is_answer("objective", "describe") &&
      is_answer("outcome_type", "survival"))
  add("unadjusted_survival_comparison", comparing && two_groups &&
      is_answer("outcome_type", "survival"))
  add("adjusted_survival_association", is_answer("objective", "associate") &&
      is_answer("outcome_type", "survival") && multiple_predictors)

  # Causal methods: distinguish quasi-experimental from randomized designs
  add("quasi_experimental_causal_effect",
      is_answer("objective", "causal") && is_answer("study_design", "quasi") &&
      is_answer("intervention_comparison", "yes") &&
      is_answer("pre_post", "yes") &&
      !is_answer("parallel_trends", "no"))
  add("observational_treatment_effect",
      is_answer("objective", "causal") &&
      is_answer("study_design", c("quasi", "cross_sectional")) &&
      is_answer("intervention_comparison", "yes") && multiple_predictors)
  add("lagged_nonlinear_exposure_effects",
      is_answer("objective", "associate") &&
      is_answer("timepoints", "sequential") &&
      is_answer("delayed_effects", "yes") &&
      is_answer("nonlinear_effects", "yes"))

  # Latent variables, forecasting and predictive modeling
  add("latent_factor_discovery", is_answer("objective", "latent") &&
      is_answer("predefined_factor_structure", "no"))
  add("confirmatory_latent_factors", is_answer("objective", "latent") &&
      is_answer("predefined_factor_structure", "yes"))
  add(c("autocorrelated_forecasting", "simple_time_series_forecast"),
      is_answer("objective", "forecast") && is_answer("timepoints", "sequential"))
  add(c("prediction_accuracy", "predictive_accuracy"),
      is_answer("objective", c("predict", "classify")) &&
      is_answer("prediction_priority", "accuracy"))
  add("interpretable_prediction",
      is_answer("objective", c("predict", "classify")) &&
      is_answer("prediction_priority", "interpret"))

  # Specific design evidence should outrank generic methodological matches.
  weights <- c(
    group_by_time_interaction = 4,
    quasi_experimental_causal_effect = 6,
    lagged_nonlinear_exposure_effects = 6,
    binary_outcome = 3,
    count_outcome = 3,
    ordered_outcome = 3,
    multiclass_nominal_outcome = 3,
    continuous_proportion = 3
  )

  matches <- lapply(metadata$ranking_preferences, function(z) {
    intersect(split_tags(z), tags)
  })
  result$ranking_score <- vapply(matches, function(m) {
    if (!length(m)) return(0)
    w <- rep(2, length(m))
    special <- m %in% names(weights)
    w[special] <- unname(weights[m[special]])
    sum(w)
  }, numeric(1))
  result$ranking_reasons <- vapply(matches, function(m) {
    paste(gsub("_", " ", m), collapse = "; ")
  }, character(1))

  # Preserve assumptions without pretending to have tested them.
  result$assumptions_to_check <- metadata$assumption_checks
  result$assumption_flags <- vapply(metadata$assumption_checks, function(z) {
    checks <- split_tags(z)
    flags <- character()
    if ("parallel_trends" %in% checks && is_answer("parallel_trends", "no"))
      flags <- c(flags, "Parallel trends reported implausible")
    if ("parallel_trends" %in% checks && is_answer("parallel_trends", "yes"))
      flags <- c(flags, "Parallel trends still require verification")
    if (skewed && any(c("normal_residuals", "normal_pair_differences",
                        "normal_observations", "multivariate_normality") %in% checks))
      flags <- c(flags, "Investigate model-specific normality")
    paste(flags, collapse = "; ")
  }, character(1))

  # Keep DiD visible for diagnostics, but do not reward causal inference
  # when the respondent states that parallel trends are implausible.
  if (is_answer("parallel_trends", "no")) {
    result$ranking_score[result$method_id == "AA30"] <-
      result$ranking_score[result$method_id == "AA30"] - 10
  }
  result$ranking_score[result$status == "excluded"] <- NA_real_
  result <- result[order(
    result$status == "excluded", -result$ranking_score,
    result$status == "needs_review", result$method_id, na.last = TRUE
  ), , drop = FALSE]
  result$rank <- NA_integer_
  candidates <- which(result$status != "excluded")
  if (length(candidates)) {
    result$rank[candidates] <- rank(
      -result$ranking_score[candidates], ties.method = "min"
    )
  }
  rownames(result) <- NULL
  result
}
