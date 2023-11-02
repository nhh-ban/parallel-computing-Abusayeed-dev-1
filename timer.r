library(tweedie)
library(magrittr)
library(tidyr)
library(stringr)
library(dplyr)
library(purrr)
library(tictoc)
library(ggplot2)
library(doParallel)
library(yaml)

configs <- 
  read_yaml("sim_configs.yml")

source("functions/simfunctions.r")

# result from previous df:
df <-
  expand.grid(
    N = configs$sample_sizes,
    M = configs$iterations_for_each_case,
    share_reject = NA
  )


# for first core: 
tic("one CPU on all calculations")
source("scripts/1_one_core.R")
toc(log = TRUE)

tic("Parallel loop alt 1")
source("scripts/2_parallel_alt_1.R")
toc(log = TRUE)

tic("Parallel loop alt 2")
source("scripts/3_parallel_alt_2.R")
toc(log = TRUE)



# Comparison of Parallelization Methods:
# It's evident that parallelizing the `MTweedieTests` function significantly
# accelerates the execution compared to parallelizing the final loop.
#
# The primary reason is that simulating `replicate(M, simTweedieTest(N))` can be
# computationally intensive, particularly when `M` is substantial. Thus, parallelizing
# this portion of the script yields notable speed improvements.
#
# In contrast, parallelizing the final loop does not yield substantial benefits.
# Since there are only five distinct calls to `MTweedieTests`, utilizing more than
# five CPU cores provides minimal advantages. Furthermore, some calls, like
# `MTweedieTests` when `M=10`, are very quick to complete. As a result, the core
# assigned to `M=10` finishes early, while the others wait for the slower `M=5000` run.
#
# It's worth noting that the outcome might be different if the goal was to execute
# `MTweedieTests` numerous times with a low `M`. In such a scenario, parallelizing
# the final loop might become more advantageous.


tic.log() %>%
  unlist %>%
  tibble(logvals = .) %>%
  separate(logvals,
           sep = ":",
           into = c("Function type", "log")) %>%
  mutate(log = str_trim(log)) %>%
  separate(log,
           sep = " ",
           into = c("Seconds"),
           extra = "drop")

