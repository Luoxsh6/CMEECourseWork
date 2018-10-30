rm(list = ls())
graphics.off()
library("ggplot2")
library(repr)
options(repr.plot.width=6, repr.plot.height=5) # Change default plot size; not necessary if you are using Rstudio
require("minpack.lm") # for Levenberg-Marquardt nls fitting

powMod <- function(x, a, b) {
  return(a * x^b)
}



MyData <- read.csv("../data/GenomeSize.csv")

head(MyData)

Data2Fit <- subset(MyData,Suborder == "Anisoptera")

Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] # remove NA's

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)

ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) + geom_point()

PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit, start = list(a = .1, b = .1))
