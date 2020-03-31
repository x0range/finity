\name{finity-package}
\alias{finity-package}
\alias{finity}
\docType{package}
\title{
\packageTitle{finity}
}
\description{
\packageDescription{finity}
}
\details{
For heavy-tailed distributions with tail exponent \eqn{a}, only 
moments of order \eqn{<a} are finite. The tail index and heavy-
tailedness are is notoriously difficult to ascertain. But 
the finiteness of moments (including fractional moments) can
be tested directly. This package does that following the 
test suggested by Trapani (2016).

The main function is finite_moment_test().}
\author{
\packageAuthor{finity}

Maintainer: \packageMaintainer{finity}
}
\references{
Trapani, Lorenzo (2016), 'Testing for (in)finite moments', \emph{Journal of Econometrics} \bold{191}(1), 57 – 68.
}
%~~ Optionally other standard keywords, one per line, from file KEYWORDS in ~~
%~~ the R documentation directory ~~
\keyword{ package }
\seealso{
https://github.com/x0range/finity
%~~ Optional links to other man pages, e.g. ~~
%~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
library(stabledist)
# Generate sample
rvs <- rstable(10000000, 1.9, 0.5, 1, 0, pm = 0)
# Perform test
result <- finite_moment_test(rvs, 2)
# Print results
message(paste("Test statistic:", result[1], "p-value:", result[2], "\n\n"))

# More examples are included in https://github.com/x0range/finity/examples
}
