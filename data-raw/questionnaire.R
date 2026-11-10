# AdamsAnalysis - Research Questionnaire

questionnaire <- data.frame(
  question_id = sprintf("Q%02d", 1:12),

  question = c(
    "What is your primary research objective?",
    "What type of outcome are you investigating?",
    "How many outcome variables are there?",
    "What types of predictors are involved?",
    "How many predictors are being investigated?",
    "How many groups or conditions are compared?",
    "How many timepoints are measured?",
    "How are observations related?",
    "What is the study design?",
    "What is the approximate sample size?",
    "Are observations balanced across groups/timepoints?",
    "What is known about the data distribution?"
  ),

  input_type = c(
    rep("select", 9),
    "numeric",
    "select",
    "select"
  ),

  stringsAsFactors = FALSE
)

# Permitted responses for each question
# Names are stable codes; values are displayed to users.

choices <- list(

  c(describe = "Describe data",
    compare = "Compare groups",
    associate = "Investigate relationships",
    causal = "Estimate causal effects",
    predict = "Predict outcomes",
    forecast = "Forecast over time",
    latent = "Identify latent structures",
    cluster = "Identify clusters",
    classify = "Classify observations",
    unknown = "Not sure"),

  c(continuous = "Continuous",
    binary = "Binary",
    ordinal = "Ordinal",
    nominal = "Nominal",
    count = "Count",
    proportion = "Proportion",
    survival = "Time-to-event",
    none = "Not applicable",
    unknown = "Not sure"),

  c(zero = "0", one = "1",
    multiple = "2+", unknown = "Not sure"),

  c(continuous = "Continuous",
    categorical = "Categorical",
    both = "Both",
    none = "None",
    unknown = "Not sure"),

  c(zero = "0", one = "1",
    multiple = "2+", unknown = "Not sure"),

  c(zero = "0", one = "1", two = "2",
    three_plus = "3+", unknown = "Not sure"),

  c(one = "1", two = "2",
    three_plus = "3+",
    sequential = "Many sequential observations",
    unknown = "Not sure"),

  c(independent = "Independent",
    paired = "Paired",
    repeated = "Repeated",
    clustered = "Clustered",
    unknown = "Not sure"),

  c(cross_sectional = "Cross-sectional",
    longitudinal = "Longitudinal",
    randomized = "Randomized experiment",
    quasi = "Quasi-experimental",
    time_series = "Time series",
    unknown = "Not sure"),

  NULL,  # Sample size uses numeric input

  c(yes = "Yes", no = "No",
    unknown = "Not sure"),

  c(normal = "Approximately normal",
    non_normal = "Skewed/non-normal",
    unknown = "Not sure")
)

# Create a separate response-options table

questionnaire_options <- do.call(
  rbind,
  lapply(seq_along(choices), function(i) {

    x <- choices[[i]]
    if (is.null(x)) return(NULL)

    data.frame(
      question_id = questionnaire$question_id[i],
      option_value = names(x),
      option_label = unname(x),
      display_order = seq_along(x),
      stringsAsFactors = FALSE
    )
  })
)

rownames(questionnaire_options) <- NULL

# Validation

stopifnot(
  nrow(questionnaire) == 12,
  !anyDuplicated(questionnaire$question_id),
  !anyNA(questionnaire),
  !anyNA(questionnaire_options),
  all(questionnaire_options$question_id %in%
        questionnaire$question_id)
)

# Save both datasets in the package

usethis::use_data(
  questionnaire,
  questionnaire_options,
  overwrite = TRUE
)

# Inspect

View(questionnaire)
View(questionnaire_options)

# Step 3.2 - Specialized follow-up questions

extra_questions <- data.frame(
  question_id = sprintf("Q%02d", 13:20),
  question = c(
    "Is there an intervention and comparison group?",
    "Are both groups observed before and after intervention?",
    "Are parallel pre-intervention trends plausible?",
    "Are delayed exposure effects of interest?",
    "Are nonlinear exposure-response relationships expected?",
    "Does follow-up include censored observations?",
    "Is the latent factor structure specified in advance?",
    "Is interpretability or predictive accuracy the priority?"
  ),
  input_type = rep("select", 8)
)

questionnaire <- rbind(questionnaire, extra_questions)

extra_choices <- list(
  Q13 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q14 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q15 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q16 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q17 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q18 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q19 = c(yes = "Yes", no = "No", unknown = "Not sure"),
  Q20 = c(
    interpret = "Interpretability",
    accuracy = "Predictive accuracy",
    balanced = "Both equally important",
    unknown = "Not sure"
  )
)

extra_options <- do.call(rbind, lapply(
  names(extra_choices), function(id) {
    x <- extra_choices[[id]]
    data.frame(
      question_id = id,
      option_value = names(x),
      option_label = unname(x),
      display_order = seq_along(x)
    )
  }
))

questionnaire_options <- rbind(
  questionnaire_options,
  extra_options
)

# Conditional visibility rules
# Multiple rules for a question operate as OR conditions.

questionnaire_conditions <- data.frame(
  question_id = c(
    "Q02", "Q03", "Q04", "Q05", "Q06",
    "Q07", "Q11", "Q11", "Q12",
    "Q13", "Q14", "Q15", "Q16",
    "Q17", "Q18", "Q19", "Q20"
  ),

  parent_id = c(
    "Q01", "Q02", "Q01", "Q04", "Q01",
    "Q01", "Q06", "Q07", "Q02",
    "Q01", "Q13", "Q14", "Q07",
    "Q16", "Q02", "Q01", "Q01"
  ),

  allowed_values = c(
    "describe|compare|associate|causal|predict|forecast|classify",
    "continuous|binary|ordinal|nominal|count|proportion|survival|unknown",
    "compare|associate|causal|predict|forecast|classify",
    "continuous|categorical|both|unknown",
    "compare|causal",
    "describe|compare|associate|causal|predict|forecast",
    "two|three_plus|unknown",
    "two|three_plus|sequential|unknown",
    "continuous|unknown",
    "causal",
    "yes|unknown",
    "yes|unknown",
    "sequential",
    "yes|unknown",
    "survival",
    "latent",
    "predict|classify"
  )
)

# Validate and save

stopifnot(
  nrow(questionnaire) == 20,
  !anyDuplicated(questionnaire$question_id),
  !anyNA(questionnaire_options),
  all(questionnaire_conditions$question_id %in%
        questionnaire$question_id),
  all(questionnaire_conditions$parent_id %in%
        questionnaire$question_id)
)

usethis::use_data(
  questionnaire,
  questionnaire_options,
  questionnaire_conditions,
  overwrite = TRUE
)

View(questionnaire_conditions)
