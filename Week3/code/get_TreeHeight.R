# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  # print(paste("Tree height is:", height))
  return (height)
}


args <- commandArgs(T)
basename <- basename(args)
file_dir <- paste("../data/", basename, sep="")
filename <- unlist(strsplit(x=basename, split="\\."))[1]

trees <- read.csv(file_dir)
degrees <- trees[,3]
distance <- trees[,2]
height <- TreeHeight(degrees,distance)
new_data <- data.frame(trees,Tree.Height.m=height)

newfilename_dir <- paste("../data/", filename, "_treeheights.csv", sep="")

write.csv(new_data, file=newfilename_dir, row.names=FALSE)



