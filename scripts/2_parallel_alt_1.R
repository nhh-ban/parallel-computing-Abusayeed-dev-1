# Next we use doParallel for the loop over the result df: 
maxcores <- configs$n_cores
Cores <- min(parallel::detectCores(), maxcores)
cl <- makeCluster(Cores)
registerDoParallel(cl)


res <-
  foreach(
    i = 1:nrow(df),
    .combine = 'rbind',
    .packages = c('magrittr', 'dplyr', 'tweedie')
  ) %dopar%
  tibble(
    N = df$N[i],
    M = df$M[i],
    share_reject =
      MTweedieTests(N = df$N[i],
                    M = df$M[i],
                    sig = configs$significance_level)
  )

# Now that we're done, we close off the clusters
stopCluster(cl)


