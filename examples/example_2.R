# Example and performance test for finite moment test package

# Load packages
library(pacman)
pacman::p_load(Rcpp,stabledist,parallel,ggplot2,reshape2)

# Load code from Rcpp
sourceCpp("src/finite_moment_test.cpp")

# Performance test 2: Sample of heavy-tailed functions. Plot the density of test statistics and p values.
message("\nPerformance test 2: Density of estimates with identical samples, all with tail exponent 1.5. Testing for moments 1.5, 1.8, 2.0\n\n")

cores_to_use <- parallel::detectCores() - 1 # use all except one core
if(.Platform$OS.type == "windows") {
  cores_to_use <- 1                         # for Windows, mclapply multiprocessing is not implemented
}

for (moment_order in c(1.5, 1.8, 2.0)) {
  n_samples <- 100
  levysamplesizes <- 100000
  true_tail_exp <- 1.5
  
  
  test_results_Rcpp <- mclapply(1:n_samples,function(x){
    finite_moment_test(rstable(levysamplesizes, alpha = true_tail_exp, beta = 0.5, gamma=1.0, delta=0.0, pm=0), moment_order, psi=1, random_salting=x, force_random_variate_sample=T, ignore_errors=T)
  }, mc.cores = cores_to_use)
  test_results_Rcpp <- Reduce(rbind, lapply(lapply(test_results_Rcpp, t), as.data.frame))
  colnames(test_results_Rcpp) <- c("Chi2TS", "p_value")
  
  test_results_Rcpp2 <- mclapply(1:n_samples,function(x){
    finite_moment_test(rstable(levysamplesizes, alpha = true_tail_exp, beta = 0.5, gamma=1.0, delta=0.0, pm=0), moment_order, psi=1, random_salting=x, ignore_errors=T)
  }, mc.cores = cores_to_use)
  test_results_Rcpp2 <- Reduce(rbind, lapply(lapply(test_results_Rcpp2, t), as.data.frame))
  colnames(test_results_Rcpp2) <- c("Chi2TS", "p_value")
  
  test_p_values <- data.frame(test_results_Rcpp$p_value, test_results_Rcpp2$p_value)
  colnames(test_p_values) <- c("random variates", "quantile grid")
  test_p_values <- melt(test_p_values)
  test_Chi2TS <- data.frame(test_results_Rcpp$Chi2TS, test_results_Rcpp2$Chi2TS)
  colnames(test_Chi2TS) <- c("random variates", "quantile grid")
  test_Chi2TS <- melt(test_Chi2TS)
  
  Chi2TS_plot <- ggplot(test_Chi2TS, aes(x=value, fill=variable)) + geom_density(alpha=0.4) +
          scale_fill_manual(values=c("#9999FF", "#66FF66", "#FF9999")) + #xlim(80, 100) +
          theme(legend.position = c(0.8, 0.8), panel.background = element_blank(), axis.line = element_line(colour = "black"), 
                  text = element_text(size=20)) +
          xlab("Chi2 Test statistic values") + ylab("Density") + guides(fill=guide_legend(title=""))
  
  p_value_plot <- ggplot(test_p_values, aes(x=value, fill=variable)) + geom_density(alpha=0.4) +
          scale_fill_manual(values=c("#9999FF", "#66FF66", "#FF9999")) + #xlim(80, 100) +
          theme(legend.position = c(0.3, 0.8), panel.background = element_blank(), axis.line = element_line(colour = "black"), 
                  text = element_text(size=20)) +
          xlab("p-values") + ylab("Density") + guides(fill=guide_legend(title=""))
  ggsave(paste("finite_moment_test_Chi2_test_statistics_density_", as.character(moment_order), ".pdf", sep=""), Chi2TS_plot)
  ggsave(paste("finite_moment_test_p_values_density_", as.character(moment_order), ".pdf", sep=""), p_value_plot)
}
message("")

