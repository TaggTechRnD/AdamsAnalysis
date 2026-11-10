testthat::test_that("Research scenarios display correct questions", {

  cases <- list(

    repeated_ANOVA = list(
      answers = list(
        Q01 = "compare",
        Q02 = "continuous",
        Q06 = "two",
        Q07 = "three_plus",
        Q08 = "repeated"
      ),
      show = c("Q06", "Q07", "Q11", "Q12"),
      hide = c("Q13", "Q15", "Q18")
    ),

    difference_in_differences = list(
      answers = list(
        Q01 = "causal",
        Q02 = "continuous",
        Q06 = "two",
        Q07 = "two",
        Q13 = "yes",
        Q14 = "yes"
      ),
      show = c("Q13", "Q14", "Q15"),
      hide = c("Q16", "Q18", "Q19")
    ),

    distributed_lag = list(
      answers = list(
        Q01 = "associate",
        Q07 = "sequential",
        Q16 = "yes"
      ),
      show = c("Q07", "Q16", "Q17"),
      hide = c("Q13", "Q15", "Q18")
    ),

    survival = list(
      answers = list(
        Q01 = "associate",
        Q02 = "survival"
      ),
      show = c("Q02", "Q18"),
      hide = c("Q12", "Q15", "Q19")
    ),

    machine_learning = list(
      answers = list(
        Q01 = "predict",
        Q02 = "binary",
        Q20 = "accuracy"
      ),
      show = c("Q02", "Q04", "Q20"),
      hide = c("Q13", "Q18", "Q19")
    ),

    factor_analysis = list(
      answers = list(Q01 = "latent", Q19 = "yes"),
      show = c("Q01", "Q19"),
      hide = c("Q13", "Q18", "Q20")
    )
  )

  for (scenario in names(cases)) {

    x <- cases[[scenario]]
    visible <- AdamsAnalysis::visible_questions(x$answers)

    testthat::expect_true(
      all(x$show %in% visible),
      info = scenario
    )

    testthat::expect_false(
      any(x$hide %in% visible),
      info = scenario
    )

    testthat::expect_true(
      AdamsAnalysis::validate_answers(x$answers),
      info = scenario
    )
  }
})

testthat::test_that("Invalid responses are rejected", {

  testthat::expect_error(
    AdamsAnalysis::validate_answers(list(Q99 = "yes"))
  )

  testthat::expect_error(
    AdamsAnalysis::validate_answers(list(Q01 = "invalid"))
  )

  testthat::expect_error(
    AdamsAnalysis::validate_answers(list(Q10 = -5))
  )

  testthat::expect_error(
    AdamsAnalysis::validate_answers(
      list(Q01 = "compare", Q15 = "yes")
    )
  )
})

testthat::test_that("Conditional rules use valid response codes", {

  rules <- AdamsAnalysis::questionnaire_conditions
  options <- AdamsAnalysis::questionnaire_options

  for (i in seq_len(nrow(rules))) {

    allowed <- strsplit(
      rules$allowed_values[i], "|", fixed = TRUE
    )[[1]]

    valid <- options$option_value[
      options$question_id == rules$parent_id[i]
    ]

    testthat::expect_true(
      all(allowed %in% valid),
      info = rules$question_id[i]
    )
  }
})
