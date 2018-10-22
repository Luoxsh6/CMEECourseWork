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


trees <- read.csv(file = "../data/trees.csv")
degrees <- trees[,3]
distance <- trees[,2]
Tree.Height.m <- TreeHeight(degrees,distance)
trees$Tree.Height.m <- Tree.Height.m    #create a new column 
write.csv(trees, file="../results/TreeHts.csv", row.names=FALSE)

