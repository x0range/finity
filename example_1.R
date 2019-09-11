# Example and performance test for finite moment test package

# Load packages
library(pacman)
pacman::p_load(Rcpp,stabledist)

# Load code from Rcpp
sourceCpp("src/finite_moment_test.cpp")

# Performance test 1: Some heavy-tailed distribution
message("\nPerformance test 1: Large sample\n\n")

rvs <- rstable(50000000, 1.9, 0.5, 1, 0, pm = 0)
system.time(
  {
    result <- finite_moment_test(rvs, 2)
  }
)
message(paste("Test statistic:", result[1], "p-value:", result[2], "\n\n"))
