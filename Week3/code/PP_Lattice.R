rm(list=ls())
require(lattice)
require(plyr)

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

pdf("../results/Pred_Lattice.pdf", 11.7, 8.3) # ready to save 1st graph
histogram(~log(Predator.mass), data =MyDF)
dev.off()

pdf("../results/Prey_Lattice.pdf", 11.7, 8.3) # graph 2
histogram(~log(Prey.mass), data = MyDF)
dev.off()

pdf("../results/SizeRatio_Lattice.pdf", 11.7, 8.3) # graph 3
histogram(~log((Predator.mass) /(Prey.mass)), data =MyDF)
dev.off()

a <-log(MyDF$Predator.mass)
b <-log(MyDF$Prey.mass)
c <-log((MyDF$Predator.mass) /(MyDF$Prey.mass))
d <- MyDF$Type.of.feeding.interaction
f <-data.frame(feeding.type=d, log.Predator.mass=a,log.Prey.mass=b,ratio=c)

#dmean <- tapply(a, d, mean)

# log.Predator.mass <- ddply(f, .(feeding.type), summarize, log.Predator.mass.mean = round(mean(log.Predator.mass), 2), log.Predator.mass.median = round(median(log.Predator.mass), 2))

# log.Prey.mass <- ddply(f, .(feeding.type), summarize, log.Prey.mass.mean = round(mean(log.Prey.mass), 2), log.Prey.mass.median = round(median(log.Prey.mass), 2))

# ratio <- ddply(f, .(feeding.type), summarize, ratio.mean = round(mean(ratio), 2), ratio.median = round(median(ratio), 2))

# # merge three data.frame
# mix <- merge(log.Predator.mass, log.Prey.mass)
# result <- merge(mix, ratio)


PP_Results <- ddply(MyDF, ~ Type.of.feeding.interaction, summarize, 
                    mean_mass_pred = mean(Predator.mass), median_mass_pred = median(Predator.mass), 
                    mean_mass_prey = mean(Prey.mass), median_mass_prey = median(Prey.mass),
                    mean_ppsize_ratio = mean(log(Predator.mass/Prey.mass)), 
                    median_ppsize_ratio = median(log(Predator.mass/Prey.mass)))


write.csv(PP_Results,"../results/PP_Results.csv", row.names=FALSE)