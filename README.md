## Seasonal ARIMA model
This repository contains a study of the effectiveness of selected data imputation techniques on the mobile phone parameters dataset. To preview the project, click on the file `report.pdf`. PDF was generated using R Markdown. For clean R code click on the file `code.R`.

### Analytical process carried out:
- generating MCAR type missing values in the dataset
- data imputation using five techniques: mean, median, regression, K nearest neighbors, random forest
- comparison of the averaged descriptive statistics for each imputation technique

## Used technology
- [R version 4.1.3](https://cran.r-project.org/src/base/R-4/)
- [RStudio](https://www.rstudio.com/)

## Used libraries
```r
library(dplyr)
library(VIM)
library(kableExtra)s
```