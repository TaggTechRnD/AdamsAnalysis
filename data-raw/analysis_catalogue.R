## code to prepare `analysis_catalogue` dataset goes here
# AdamsAnalysis - Statistical Methods Catalogue
# Initial catalogue of 30 methods

method_names <- c(
  "Mean and Standard Deviation",
  "Median and Interquartile Range",
  "Frequencies and Proportions",
  "Pearson Correlation",
  "Spearman Correlation",
  "Independent Samples t-Test",
  "Welch's t-Test",
  "Paired t-Test",
  "Mann-Whitney U Test",
  "Wilcoxon Signed-Rank Test",
  "One-Way ANOVA",
  "Two-Way ANOVA",
  "Repeated-Measures ANOVA",
  "Mixed-Design ANOVA",
  "ANCOVA",
  "Kruskal-Wallis Test",
  "Friedman Test",
  "Chi-Square Test of Independence",
  "Fisher's Exact Test",
  "Simple Linear Regression",
  "Multiple Linear Regression",
  "Binary Logistic Regression",
  "Poisson Regression",
  "Linear Mixed-Effects Model",
  "Generalized Linear Mixed Model (GLMM)",
  "Principal Component Analysis (PCA)",
  "Exploratory Factor Analysis (EFA)",
  "Decision Tree",
  "Random Forest",
  "Difference-in-Differences (DiD)"
)

categories <- c(
  rep("Descriptive Statistics", 3),
  rep("Correlation", 2),
  rep("Group Comparisons and Tests", 14),
  rep("Regression and Longitudinal", 6),
  rep("Multivariate and Factor Analysis", 2),
  rep("Machine Learning", 2),
  "Causal and Quasi-Experimental"
)

analysis_catalogue <- data.frame(
  method_id = sprintf("AA%02d", 1:30),
  method_name = method_names,
  category = categories,
  stringsAsFactors = FALSE
)

# Basic integrity checks
# Additional statistical methods

additional_methods <- list(

  "Descriptive Statistics" = c(
    "Cross-Tabulation",
    "Confidence Intervals"
  ),

  "Correlation" = c(
    "Kendall's Tau",
    "Point-Biserial Correlation",
    "Partial Correlation"
  ),

  "Group Comparisons and Tests" = c(
    "One-Sample t-Test",
    "Welch's ANOVA",
    "MANOVA",
    "McNemar's Test"
  ),

  "Regression and Longitudinal" = c(
    "Polynomial Regression",
    "Generalized Additive Model (GAM)",
    "Multinomial Logistic Regression",
    "Ordinal Logistic Regression",
    "Negative Binomial Regression",
    "Zero-Inflated Regression",
    "Beta Regression",
    "Quantile Regression",
    "Generalized Estimating Equations (GEE)"
  ),

  "Survival Analysis" = c(
    "Cox Proportional Hazards Regression",
    "Kaplan-Meier Analysis",
    "Log-Rank Test"
  ),

  "Multivariate and Factor Analysis" = c(
    "Confirmatory Factor Analysis (CFA)",
    "Path Analysis",
    "Structural Equation Modeling (SEM)",
    "Mediation Analysis",
    "Latent Growth Curve Modeling"
  ),

  "Time Series and Forecasting" = c(
    "ARIMA",
    "Exponential Smoothing (ETS)",
    "Interrupted Time Series"
  ),

  "Causal and Quasi-Experimental" = c(
    "Propensity Score Methods"
  ),

  "Machine Learning" = c(
    "Gradient Boosting",
    "Ridge Regression",
    "LASSO Regression",
    "Elastic Net Regression",
    "Support Vector Machine (SVM)",
    "k-Nearest Neighbors (kNN)",
    "Naive Bayes",
    "Artificial Neural Network",
    "K-Means Clustering",
    "Hierarchical Clustering",
    "DBSCAN",
    "Isolation Forest"
  )
)

# Append to existing catalogue

new_methods <- data.frame(
  method_id = sprintf("AA%02d", 31:72),
  method_name = unlist(additional_methods, use.names = FALSE),
  category = rep(
    names(additional_methods),
    lengths(additional_methods)
  ),
  stringsAsFactors = FALSE
)

analysis_catalogue <- rbind(
  analysis_catalogue,
  new_methods
)

analysis_catalogue <- rbind(
  analysis_catalogue,
  data.frame(
    method_id = "AA73",
    method_name = "Distributed Lag Non-Linear Model (DLNM)",
    category = "Time Series and Forecasting"
  )
)

# Validate catalogue

stopifnot(
  nrow(analysis_catalogue) == 73,
  !anyDuplicated(analysis_catalogue$method_id),
  !anyDuplicated(analysis_catalogue$method_name),
  !anyNA(analysis_catalogue)
)

# Save package dataset

usethis::use_data(
  analysis_catalogue,
  overwrite = TRUE
)

# Inspect results

View(analysis_catalogue)
table(analysis_catalogue$category)

# Step 2.2 - Add descriptive metadata

details <- read.csv(
  "data-raw/analysis_details.csv",
  stringsAsFactors = FALSE
)

# Verify methods and IDs match
stopifnot(
  identical(analysis_catalogue$method_id, details$method_id),
  identical(analysis_catalogue$method_name, details$method_name),
  !anyNA(details)
)

# Add metadata columns
analysis_catalogue <- cbind(
  analysis_catalogue,
  details[, c("description", "when_to_use",
              "assumptions", "example")]
)

# Save updated package dataset
usethis::use_data(analysis_catalogue, overwrite = TRUE)

View(analysis_catalogue)

# Step 2.3 - Add eligibility metadata

eligibility <- read.csv(
  "data-raw/analysis_eligibility.csv",
  stringsAsFactors = FALSE
)

# Validate matching methods
stopifnot(
  nrow(eligibility) == 73,
  !anyDuplicated(eligibility$method_id),
  setequal(analysis_catalogue$method_id,
           eligibility$method_id),
  !anyNA(eligibility)
)

# Align metadata using method IDs
idx <- match(analysis_catalogue$method_id,
             eligibility$method_id)

stopifnot(identical(
  analysis_catalogue$method_name,
  eligibility$method_name[idx]
))

# Append new columns
analysis_catalogue <- cbind(
  analysis_catalogue,
  eligibility[idx, 3:ncol(eligibility)]
)

# Save updated package data
usethis::use_data(analysis_catalogue, overwrite = TRUE)

View(analysis_catalogue)

# Step 2.4 - Statistical decision rules

rules <- read.csv(
  "data-raw/analysis_rules.csv",
  stringsAsFactors = FALSE
)

# Match and validate method IDs
idx <- match(
  analysis_catalogue$method_id,
  rules$method_id
)

stopifnot(
  nrow(rules) == 73,
  !anyDuplicated(rules$method_id),
  !anyNA(idx),
  identical(
    analysis_catalogue$method_name,
    rules$method_name[idx]
  )
)

# Add decision metadata
analysis_catalogue <- cbind(
  analysis_catalogue,
  rules[idx, c(
    "additional_hard_requirements",
    "assumption_checks",
    "ranking_preferences"
  )]
)

# Save updated catalogue
usethis::use_data(
  analysis_catalogue,
  overwrite = TRUE
)

View(analysis_catalogue)
