# AA16 — Kruskal-Wallis Test
# Goal: Compare rank distributions among independent groups.
# Packages: stats
# Check: Kruskal–Wallis H and p-value.
# Caveat: Does not automatically test equality of medians for differing distribution shapes.

set.seed(2026)
d <- expand.grid(group = factor(c("Control","Treatment")),
                 dose = factor(c("Low","High")), rep = seq_len(40))
d$y <- 10 + 2*(d$group == "Treatment") + 1*(d$dose == "High") +
  2*(d$group == "Treatment")*(d$dose == "High") + rnorm(nrow(d), sd = 2)

print(kruskal.test(y ~ group,data=d))
