# Step 8.5 QA summary

- **73/73** method IDs and names match the Step 8.4 reference catalogue.
- All 73 tutorial records contain the 11 expected nonempty fields.
- **73/73 Python examples pass AST syntax parsing.**
- **63 Python examples executed successfully** in the available Python environment.
- **10 Python examples skipped** because optional dependencies are not installed here (AA14, AA27, AA41, AA49–AA54, AA56).
- **0 Python execution failures** among those run.
- R is not available in this environment: none of the R examples have been executed here. The build script performs `parse(text=...)` on all 73 R code samples before saving the .rda object; existing package tests additionally check parseability.
- Python executions check that scripts run on simulated data; they do **not** establish statistical correctness, numerical equivalence to R, or real-world suitability. Thorough statistical review and references remain necessary.
