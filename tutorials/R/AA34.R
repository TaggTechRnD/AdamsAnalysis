# AA34 — Point-Biserial Correlation
# Goal: Quantify association of a binary group indicator and a numerical outcome (here binary for illustration).
# Packages: stats
# Check: Point-biserial correlation magnitude and p-value.
# Caveat: Continuous outcome and binary group indicator; interpretation is associative, not causal.

set.seed(2026)
n <- 160
x <- rnorm(n)
group <- factor(rep(c("Control", "Treatment"), each = n/2))
y <- 10 + 1.3 * (group == "Treatment") + 0.9 * x + rnorm(n, sd = 2)
d <- data.frame(y, x, group)

indicator<-as.integer(d$group=="Treatment")
print(cor.test(indicator,d$y,method="pearson"))
