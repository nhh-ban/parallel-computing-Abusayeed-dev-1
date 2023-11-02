
for (i in 1:nrow(df)) {
  df$share_reject[i] <-
    MTweedieTests(N = df$N[i],
                  M = df$M[i],
                  sig = configs$significance_level)
}


