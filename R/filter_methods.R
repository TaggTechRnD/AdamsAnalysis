#' Filter Analyses by Hard Eligibility Requirements
#'
#' Retains methods that are not contradicted by questionnaire responses.
#' Unverified requirements are explicitly flagged, never assumed satisfied.
#'
#' @param answers Named list of coded questionnaire answers.
#' @param include_excluded Include rejected methods for QA/QC (default FALSE).
#' @return Data frame with method identity, eligibility status, and reasons.
#' @export
filter_methods <- function(answers = list(), include_excluded = FALSE) {

  x <- interpret_answers(answers) # also validates the questionnaire
  catalogue <- analysis_catalogue
  fields <- c("objective", "outcome_type", "predictor_type",
              "predictor_count", "group_count", "timepoints",
              "observation_structure", "study_design")

  known <- function(z) {
    length(z) == 1L && !is.na(z) && z != "unknown"
  }
  value <- function(field) x[[field]]
  is_value <- function(field, choices) {
    v <- value(field)
    if (!known(v)) return(NA)
    v %in% choices
  }
  yes_no <- function(field) {
    v <- value(field)
    if (!known(v)) return(NA)
    if (v == "yes") TRUE else if (v == "no") FALSE else NA
  }

  # Interpret questionnaire codes as the catalogue's coded values.
  codes <- function(field) {
    v <- value(field)
    if (!known(v)) return(character())

    switch(field,
      objective = switch(v,
        describe = c("describe", "estimate_uncertainty"),
        compare = if (isTRUE(is_value("outcome_type", c("binary", "ordinal", "nominal"))))
          c("compare", "associate") else "compare",
        associate = "associate", causal = "causal_effect",
        predict = "predict", forecast = "forecast",
        latent = c("reduce_dimensions", "validate_measurement", "model_paths"),
        cluster = c("cluster", "detect_anomalies"),
        classify = "predict", character()),
      outcome_type = {
        out <- if (v == "survival") "time_to_event" else v
        if (v == "continuous" && isTRUE(is_value("outcome_count", "multiple"))) {
          out <- c(out, "multivariate_continuous")
        }
        out
      },
      predictor_type = switch(v,
        continuous = "continuous",
        categorical = c("categorical", "binary", "ordinal"),
        both = c("mixed", "continuous", "categorical", "binary", "ordinal"),
        none = "none", character()),
      predictor_count = switch(v,
        zero = "zero", one = c("one", "one_plus"),
        multiple = c("two_plus", "one_plus"), character()),
      group_count = switch(v,
        zero = "one", one = "one", two = c("two", "two_plus"),
        three_plus = "two_plus", character()),
      timepoints = switch(v,
        one = "one", two = "two",
        three_plus = "three_plus", sequential = "three_plus", character()),
      observation_structure = {
        out <- switch(v,
          independent = "independent", paired = "paired",
          repeated = "repeated", clustered = "clustered", character())
        if (v == "repeated" && isTRUE(is_value("timepoints", "two"))) {
          out <- c(out, "paired")
        }
        if (v == "paired" && isTRUE(is_value("timepoints", "two"))) {
          out <- c(out, "repeated")
        }
        if (isTRUE(is_value("study_design", "time_series")) &&
            isTRUE(is_value("timepoints", "sequential"))) {
          out <- c(out, "time_series")
        }
        unique(out)
      },
      study_design = switch(v,
        cross_sectional = "observational",
        longitudinal = c("longitudinal", "observational"),
        randomized = "randomized",
        quasi = "quasi_experimental",
        time_series = "time_series", character()),
      character()
    )
  }

  input_codes <- setNames(lapply(fields, codes), fields)
  if (length(input_codes$observation_structure) == 0 &&
      isTRUE(is_value("study_design", "time_series")) &&
      isTRUE(is_value("timepoints", "sequential"))) {
    input_codes$observation_structure <- "time_series"
  }
  test_field <- function(meta, supplied) {
    allowed <- strsplit(meta, "|", fixed = TRUE)[[1]]
    if ("any" %in% allowed) return(TRUE)
    if (length(supplied) == 0L) return(NA)
    length(intersect(allowed, supplied)) > 0L
  }

  # Evaluate only requirements directly supported by existing questions.
  # Other requirements must be reviewed, not guessed.
  test_requirement <- function(req) {
    if (req == "none") return(TRUE)
    multiple_groups <- is_value("group_count", c("two", "three_plus"))
    multiple_times <- is_value("timepoints", c("two", "three_plus", "sequential"))
    related <- is_value("observation_structure", c("paired", "repeated"))
    if (req == "matched_pairs") return(related)
    if (req == "matched_binary_pairs")
      return(related & is_value("outcome_type", "binary"))
    if (req == "within_subject_factor") return(related & multiple_times)
    if (req == "between_and_within_subject_factors")
      return(related & multiple_times & multiple_groups)
    if (req %in% c("treated_and_comparison_groups", "defined_treatment_and_control"))
      return(yes_no("intervention_comparison") & multiple_groups)
    if (req == "pre_and_post_periods") return(yes_no("pre_post"))
    if (req == "comparison_groups") return(multiple_groups)
    if (req == "continuous_predictor")
      return(is_value("predictor_type", c("continuous", "both")))
    if (req == "ordered_categories") return(is_value("outcome_type", "ordinal"))
    if (req == "nonnegative_integer_outcome") return(is_value("outcome_type", "count"))
    if (req == "multiple_continuous_outcomes")
      return(is_value("outcome_type", "continuous") &
             is_value("outcome_count", "multiple"))
    if (req == "prespecified_measurement_model")
      return(yes_no("predefined_factor_structure"))
    if (req == "binary_group_and_continuous_measure")
      return(is_value("outcome_type", "continuous") &
             is_value("group_count", "two") &
             is_value("predictor_type", c("categorical", "both")))
    if (req == "two_categorical_variables")
      return(is_value("outcome_type", c("binary", "nominal", "ordinal")) &
             is_value("predictor_type", c("categorical", "both")))
    if (req == "two_categorical_factors") {
      if (isTRUE(is_value("predictor_type", "categorical")))
        return(is_value("predictor_count", "multiple"))
      if (isTRUE(is_value("predictor_type", "none")) ||
          isTRUE(is_value("predictor_count", c("zero", "one")))) return(FALSE)
      return(NA)
    }
    if (req == "labeled_training_outcome") {
      has_outcome <- is_value("outcome_type", c(
        "continuous", "binary", "ordinal", "nominal", "count", "proportion", "survival"))
      return(has_outcome)
    }
    if (req == "defined_lag_window" &&
        identical(yes_no("delayed_effects"), FALSE)) return(FALSE)
    if (req == "time_ordered_exposure_and_outcome" &&
        identical(is_value("timepoints", "one"), TRUE)) return(FALSE)
    if (req %in% c("ordered_regular_time_series", "multiple_pre_and_post_observations") &&
        identical(is_value("timepoints", c("one", "two")), TRUE)) return(FALSE)
    if (req == "grouping_identifier" &&
        identical(is_value("observation_structure", "independent"), TRUE)) return(FALSE)
    if (req == "event_time_and_status" &&
        identical(is_value("outcome_type", "survival"), FALSE)) return(FALSE)
    NA  # Not answerable with the present questionnaire
  }

  result <- catalogue
  result$status <- character(nrow(result))
  result$exclusion_reasons <- character(nrow(result))
  result$unverified_requirements <- character(nrow(result))

  for (i in seq_len(nrow(result))) {
    rejected <- character()
    unverified <- character()

    for (field in fields) {
      check <- test_field(result[[field]][i], input_codes[[field]])
      if (identical(check, FALSE)) rejected <- c(rejected, field)
      if (is.na(check)) unverified <- c(unverified, field)
    }

    reqs <- strsplit(result$additional_hard_requirements[i], "|", fixed = TRUE)[[1]]
    for (req in reqs) {
      check <- test_requirement(req)
      if (identical(check, FALSE)) rejected <- c(rejected, paste0("hard:", req))
      if (is.na(check)) unverified <- c(unverified, paste0("hard:", req))
    }

    result$exclusion_reasons[i] <- paste(rejected, collapse = " | ")
    result$unverified_requirements[i] <- paste(unverified, collapse = " | ")
    result$status[i] <- if (length(rejected)) "excluded" else
      if (length(unverified)) "needs_review" else "eligible"
  }

  if (!include_excluded) result <- result[result$status != "excluded", , drop = FALSE]
  rownames(result) <- NULL
  result[, c("method_id", "method_name", "category", "status",
             "exclusion_reasons", "unverified_requirements"), drop = FALSE]
}
