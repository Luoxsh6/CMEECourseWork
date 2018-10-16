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


data <- read.csv(file = "../data/trees.csv")
degrees <- trees[,3]
distance <- trees[,2]
height <- TreeHeight(degrees,distance)
new_data <- data.frame(trees,Tree.Height.m=height)
write.csv(new_data, file="../data/TreeHts.csv")

