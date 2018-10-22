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
print(p_value)

plot.new()
pdf("../results/TAutoCorr.pdf", 11.7, 8.3) # Open blank pdf page using a relative path
hist(result, xlab = "correlation coefficient values", 
     ylab = "Frequency", col = rgb(0, 0, 1, 0.5), 
     main = "Temperature Coefficients", breaks = 27) 

legend('topleft', c("1000 random correlation coefficients", "successive year correlation"),
       fill=c(rgb(0, 0, 1, 0.5), rgb(1, 0, 0, 0.5)), cex = 0.8)

abline(v = tempCor, col = rgb(1, 0, 0, 0.5), lwd = 4) # successive year corr
dev.off()
