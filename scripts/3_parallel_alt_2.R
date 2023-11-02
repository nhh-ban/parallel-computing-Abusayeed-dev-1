# A parallel version of MTweedieTests:

for (i in 1:nrow(df)) {
  df$share_reject[i] <-
    MParTweedieTests(
      N = df$N[i],
      M = df$M[i],
      sig = configs$significance_level,
      maxcores = configs$n_cores
    )
}
