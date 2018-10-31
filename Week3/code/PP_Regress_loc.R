# Author: Xiaosheng Luo <Xiaosheng.luo18@imperial.ac.uk>
# Date: October 2018
# Desc: ggplot practicle for data visualisation

# clear environment
rm(list=ls())

# Load required packages #
require(ggplot2)
require(dplyr)

# load the data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv", header = TRUE)

# work out stats
# define a function return the summary of lm as vector
Myfun <- function(y,z) {
  x <- lm(log(y)~log(z))
  intercept = summary(x)$coefficients[1]
  slope = summary(x)$coefficients[2]
  r_sq = summary(x)$r.squared
  p.value = summary(x)$coefficients[8]
  f.statistic = summary(x)$fstatistic[1]
  df <- c(slope, intercept, r_sq, f.statistic, p.value)
  return(df)
}

# use dplyr group_by to output the results
results <- MyDF %>% group_by(Type.of.feeding.interaction,Predator.lifestage, Location) %>%
  summarise(Slop = Myfun(Predator.mass, Prey.mass)[1],
            Intercept = Myfun(Predator.mass, Prey.mass)[2],
            Rsquared = Myfun(Predator.mass, Prey.mass)[3],
            Fvalue = Myfun(Predator.mass, Prey.mass)[4], 
            Pvalue = Myfun(Predator.mass, Prey.mass)[5])

#write into a csv file in the results direction
write.csv(results, "../results/PP_Regress_loc.csv", row.names = FALSE)