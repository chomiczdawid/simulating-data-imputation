# Libraries and options
library(dplyr)
library(VIM)
library(kableExtra)

options(digits=2) # decimal places
options(scipen=999) # standard number format

# Loading data
read.csv("phone.csv",sep=';',dec='.') %>%
  as.matrix() -> d0

# Descriptive statistics function
stats <- function(x) {
  n <- sum(!is.na(x))
  x_sr <- mean(x,na.rm=T)
  Me <- median(x,na.rm=T)
  s <- sd(x,na.rm=T)
  Vs <- s/x_sr
  s_x_sr <- s/n^0.5
  x <- x[!is.na(x)]
  g1 <- sum((x-x_sr)^3)/(n-1)/(n-2)*n/s^3
  return(c(x_sr=x_sr,Me=Me,s=s,Vs=Vs,s_x_sr=s_x_sr,g1=g1))
}

# Simulation, may take several minutes
nsym <- 1000
w1 <- w2 <- w3 <- w4 <- w5 <- array(NA,c(6,10,nsym))
for (i in 1:nsym) {
  # MCAR type missing data generation, 20% of dataset
  miss <- d0
  miss[,3:10][runif(length(d0[,3:10]))<0.2] <- NA
  ## Imputation
  # mean
  d1 <- miss
  for(j in 1:ncol(d1)) {
    d1[,j][is.na(d1[,j])] <- mean(d1[,j],na.rm=T)
  }
  # median
  d2 <- miss
  for(k in 1:ncol(d2)) {
    d2[,k][is.na(d2[,k])] <- median(d2[,k],na.rm=T)
  }
  # regression
  d3 <- regressionImp(fc+memory+weight+ram+pc+sc_h+sc_w+talk_t~battery+speed,data=miss)
  d3 <- as.matrix(d3[,1:10])
  # kNN
  d4 <- kNN(miss)
  d4 <- as.matrix(d4[,1:10])
  # randomforest
  d5 <- as.data.frame(miss)
  d5 <- rangerImpute(fc+memory+weight+ram+pc+sc_h+sc_w+talk_t~battery+speed,data=d5)
  d5 <- as.matrix(d5[,1:10])
  # Desc stats
  w1[,,i] <- apply(d1,2,stats)
  w2[,,i] <- apply(d2,2,stats)
  w3[,,i] <- apply(d3,2,stats)
  w4[,,i] <- apply(d4,2,stats)
  w5[,,i] <- apply(d5,2,stats)
}

# Stats comparison
apply_stats <- function(y,d) {
  x0 <- apply(d,2,stats)
  x0 <- x0[,3:10]
  x1 <- apply(y,c(1,2),mean)
  x1 <- x1[,3:10]
  rownames(x1) <- rownames(x0)
  x1 <- x0 - x1
  return(cbind(x1, abs_sum = rowSums(abs(x1))))
}

f0 <- apply(d0,2,stats)
f1 <- apply_stats(w1,d0)
f2 <- apply_stats(w2,d0)
f3 <- apply_stats(w3,d0)
f4 <- apply_stats(w4,d0)
f5 <- apply_stats(w5,d0)

p <- cbind(f1[,9],f2[,9],f3[,9],f4[,9],f5[,9])
colnames(p) <- c("mean","median","regression","kNN","random forest")
rownames(p) <- rownames(f0)