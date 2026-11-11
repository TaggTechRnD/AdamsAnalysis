
# AdamsAnalysis - Research Scenarios for QA/QC
# Expected methods are specified independently
# of the recommendation engine.

scenario <- function(question, answers, expected,
                     excluded = character()) {
  list(
    question = question,
    answers = answers,
    expected = expected,
    excluded = excluded
  )
}

research_scenarios <- list(

  independent_groups = scenario(
    "Compare blood pressure between two independent groups.",
    list(Q01="compare", Q02="continuous", Q06="two",
         Q07="one", Q08="independent", Q12="normal"),
    c("AA06", "AA07"),
    "AA08"
  ),

  paired_measurements = scenario(
    "Compare blood pressure before and after treatment.",
    list(Q01="compare", Q02="continuous", Q06="one",
         Q07="two", Q08="paired", Q12="normal"),
    "AA08",
    c("AA06", "AA07")
  ),

  repeated_measurements = scenario(
    "Compare outcomes across four measurements per person.",
    list(Q01="compare", Q02="continuous", Q06="one",
         Q07="three_plus", Q08="repeated",
         Q09="longitudinal"),
    c("AA13", "AA24")
  ),

  mixed_design = scenario(
    "Compare treatment and control groups over four visits.",
    list(Q01="compare", Q02="continuous", Q06="two",
         Q07="three_plus", Q08="repeated",
         Q09="randomized"),
    c("AA14", "AA24")
  ),

  difference_in_differences = scenario(
    "Estimate a policy effect using treatment and comparison groups.",
    list(Q01="causal", Q02="continuous", Q06="two",
         Q07="two", Q08="repeated", Q09="quasi",
         Q13="yes", Q14="yes", Q15="unknown"),
    "AA30"
  ),

  distributed_lag = scenario(
    "Investigate nonlinear and delayed temperature effects.",
    list(Q01="associate", Q02="continuous",
         Q07="sequential", Q08="repeated",
         Q09="time_series", Q16="yes", Q17="yes"),
    "AA73"
  ),

  binary_regression = scenario(
    "Predict disease status using several risk factors.",
    list(Q01="associate", Q02="binary",
         Q04="both", Q05="multiple",
         Q08="independent", Q09="cross_sectional"),
    "AA22"
  ),

  count_regression = scenario(
    "Model the number of hospital admissions.",
    list(Q01="associate", Q02="count",
         Q04="both", Q05="multiple",
         Q08="independent", Q09="cross_sectional"),
    c("AA23", "AA44")
  ),

  survival_analysis = scenario(
    "Investigate predictors of time until cardiovascular disease.",
    list(Q01="associate", Q02="survival",
         Q08="independent", Q09="longitudinal",
         Q18="yes"),
    "AA49"
  ),

  exploratory_factors = scenario(
    "Identify unknown latent factors in a questionnaire.",
    list(Q01="latent", Q19="no"),
    "AA27"
  ),

  confirmatory_factors = scenario(
    "Test a predefined questionnaire factor structure.",
    list(Q01="latent", Q19="yes"),
    "AA52"
  ),

  machine_learning = scenario(
    "Classify disease risk using clinical characteristics.",
    list(Q01="classify", Q02="binary",
         Q04="both", Q05="multiple",
         Q20="accuracy"),
    c("AA28", "AA29", "AA61")
  ),

  clustering = scenario(
    "Identify distinct population subgroups.",
    list(Q01="cluster"),
    c("AA69", "AA70", "AA71")
  )
)
