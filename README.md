# finity

# Building and installing

```
R CMD build finity
R CMD install finity
```

# Build the pdf manual

```
Rscript -e 'setwd("finity");roxygen2::roxygenize()'
R CMD Rd2pdf finity
```

Alternatively, ```roxygen2::roxygenise()``` can be executed from the R interpreter before building the pdf with ```R CMD Rd2pdf finity```.

