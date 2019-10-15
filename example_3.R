# Example and performance test for finite moment test package

# Load packages
library(pacman)
pacman::p_load(Rcpp,stabledist)

# Load code from Rcpp
sourceCpp("src/finite_moment_test.cpp")


# Performance test 3: Trapani's (2016) stock returns examples
# Note that for this to work, the data must be here. It can be obtained e.g. from finance.yahoo.com
message("\nPerformance test 3: Empirical samples\n\n")

# load data
load("returns.Rda", verbose=T)

# Obtain Hill estimators for comparison
pacman::p_load(extremefit)
message("Hill estimators for comparison")
for (i in 2:length(returns)) {
  hh <- hill(returns[,i])$hill
  hh <- hh[is.finite(hh)]
  message(paste("Hill estimator for ", colnames(returns)[i], ": ", hh[length(hh)], sep=""))
}
message("")

# Perform test
for (i in 2:length(returns)) {
  message(paste("Testing ", colnames(returns)[i]))
  data <- returns[,i]
  result <- finite_moment_test(data, 2)
  message(paste("Order (2) Test statistic:", result[1], "p-value:", result[2]))
  result <- finite_moment_test(data, 3)
  message(paste("Order (3) Test statistic:", result[1], "p-value:", result[2]))
  result <- finite_moment_test(data, 4)
  message(paste("Order (4) Test statistic:", result[1], "p-value:", result[2]))
}
message("")

