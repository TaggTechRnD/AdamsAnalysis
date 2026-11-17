# AA37 — Welch's ANOVA
# Goal: Compare three group means under unequal variances.
# Packages: stats
# Check: Welch ANOVA F and approximate degrees of freedom.
# Caveat: Follow-up comparisons must also handle unequal variances.

set.seed(2026)
d <- expand.grid(group = factor(c("Control","Treatment")),
                 dose = factor(c("Low","High")), rep = seq_len(40))
d$y <- 10 + 2*(d$group == "Treatment") + 1*(d$dose == "High") +
  2*(d$group == "Treatment")*(d$dose == "High") + rnorm(nrow(d), sd = 2)

# Deliberately create unequal variances across groups
z<-data.frame(y=c(rnorm(40,0,1),rnorm(40,1,3),rnorm(40,2,5)),
              grp=factor(rep(c("A","B","C"),each=40)))
print(oneway.test(y~grp,data=z,var.equal=FALSE))
