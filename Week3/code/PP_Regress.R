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

#Creating the correct graph
p <- ggplot(MyDF, aes(x = Prey.mass, y = Predator.mass, col = Predator.lifestage)) + 
  geom_point(shape = 3) + geom_smooth(method = 'lm', fullrange = TRUE) + facet_grid(Type.of.feeding.interaction ~ .) + 
  scale_y_continuous(trans = "log10") + scale_x_continuous(trans = "log10") + xlab("Prey Mass in grams") + ylab("Predator Mass in grams") + 
  theme_bw() + theme(legend.position="bottom")+ coord_fixed(ratio = 0.3)+ guides(color = guide_legend(nrow=1))

# show the plot
p

# save plot
pdf("../results/PP_Regress.pdf", 11.7, 8.3) 
print(p)
dev.off()

# work out stats
# define a function return the summary of lm as vector
Myfun <- function(y,z) {
  x <- lm(log(y)~log(z))
  intercept = summary(x)$coefficients[1]
  slope = summary(x)$coefficients[2]
  r_sq = summary(x)$r.squared
  p.value = summary(x)$coefficients[8]
  f.statistic = summary(x)$fstatistic[1]
  df <- c(intercept, slope, r_sq, p.value, f.statistic)
  return(df)
}

# use dplyr group_by to output the results
results <- MyDF %>% group_by(Type.of.feeding.interaction,Predator.lifestage ) %>%
  summarise(Slop = Myfun(Predator.mass, Prey.mass)[1],
            Intercept = Myfun(Predator.mass, Prey.mass)[2],
            Rsquared = Myfun(Predator.mass, Prey.mass)[3],
            Fvalue = Myfun(Predator.mass, Prey.mass)[4], 
            Pvalue = Myfun(Predator.mass, Prey.mass)[5])

write.csv(results, "../results/PP_Regress.csv", row.names = FALSE)