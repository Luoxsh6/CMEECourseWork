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
# basename <- basename(args)
# file_dir <- paste("../data/", basename, sep="")
# filename <- unlist(strsplit(x=basename, split="\\."))[1]

trees <- read.csv(args[1], sep=",")

degrees <- trees[,3]
distance <- trees[,2]
Tree.Height.m <- TreeHeight(degrees,distance)
trees$Tree.Height.m <- Tree.Height.m    #create a new column 

filename= tools::file_path_sans_ext(basename(args[1])) # getting the filename
newfilename_dir <- paste("../results/", filename, "_treeheights.csv", sep="")

write.csv(trees, file=newfilename_dir, row.names=FALSE)



