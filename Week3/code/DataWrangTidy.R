################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv",header = F)) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv",header = T, sep=";", stringsAsFactors = F)

############# Inspect the dataset ###############
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) #you can also do this
fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############
require(dplyr)
require(tidyr)

MyWrangledData <- TempData %>% gather(., Species, Count, -Cultivation, -Block, -Plot, -Quadrat) %>% 
    mutate( Cultivation = as.factor(Cultivation),
            Block = as.factor(Block),
            Plot = as.factor(Plot),
            Quadrat = as.factor(Quadrat),
            Species = as.factor(Species),
            Count = as.numeric(Count))                                                                                                                                                                                                                                                                                                                                                                                                         
str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############
hist(MyWrangledData$Count)
hist(log(MyWrangledData$Count))
boxplot(MyWrangledData$Count ~ MyWrangledData$Cultivation)
plot(MyWrangledData$Count ~ MyWrangledData$Cultivation)