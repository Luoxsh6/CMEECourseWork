rm(list=ls())

# load in the data
load("../data/KeyWestAnnualMeanTemperature.RData")
b <- dim(ats)[1]

temp1 <- ats[1:b-1,2]
temp2 <- ats[2:b,2]
tempCor <- cor(temp1,temp2)

result = rep(NA,10000)
for (i in 1:10000){
  samp <- sample(ats[,2],b)
  temp1 <- samp[1:b-1]
  temp2 <- samp[2:b]
  result[i] <- cor(temp1,temp2)
}

p_value = length(result[result>tempCor]) / length(result)

