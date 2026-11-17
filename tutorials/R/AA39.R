# AA39 — McNemar's Test
# Goal: Test change in a paired binary characteristic.
# Packages: stats
# Check: McNemar p-value based on discordant pairs.
# Caveat: Within-person paired 2×2 table is required; independent chi-square is inappropriate.

set.seed(2026)
n <- 90
before <- rnorm(n, mean = 125, sd = 13)
after <- before - 5 + rnorm(n, sd = 7)
d <- data.frame(id = seq_len(n), before, after)

set.seed(2026)
d$pre<-rbinom(nrow(d),1,.35)
d$post<-ifelse(d$pre==1,rbinom(nrow(d),1,.70),rbinom(nrow(d),1,.23))
print(mcnemar.test(table(d$pre,d$post)))
