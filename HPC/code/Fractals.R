rm(list=ls())
graphics.off()

chaos_game <- function(){
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  P = list(A,B,C)
  move_point = A
  plot(0:4, 0:4, type = "n")
  points(x = move_point[1],y= move_point[2], cex = 0.2)
  for (i in (1:100000)) {
    direc = unlist(sample(P,1))
    move_point = c(((move_point[1] + direc[1])/2), ((move_point[2] + direc[2])/2))
    points(x = move_point[1], y = move_point[2], cex = 0.2)
  }
}

# Challenge E
chaos_game_initial <- function(){
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  P = list(A,B,C)
  move_point = c(1,3)
  plot(0:4, 0:4, type = "n")
  points(x = move_point[1],y= move_point[2], cex = 0.5, col = "red")
  for (i in (1:20)) {
    direc = unlist(sample(P,1))
    move_point = c(((move_point[1] + direc[1])/2), ((move_point[2] + direc[2])/2))
    points(x = move_point[1], y = move_point[2], cex = 0.5, col = "red")
  }
  for (i in (1:1000)) {
    direc = unlist(sample(P,1))
    move_point = c(((move_point[1] + direc[1])/2), ((move_point[2] + direc[2])/2))
    points(x = move_point[1], y = move_point[2], cex = 0.5, col = "blue")
  }
}

chaos_game_classic <- function(){
  A = c(0,0)
  B = c(2,2*sqrt(3))
  C = c(4,0)
  P = list(A,B,C)
  move_point = A
  plot(0:4, 0:4, type = "n")
  points(x = move_point[1],y= move_point[2], cex = 0.2)
  for (i in (1:100000)) {
    direc = unlist(sample(P,1))
    move_point = c(((move_point[1] + direc[1])/2), ((move_point[2] + direc[2])/2))
    points(x = move_point[1], y = move_point[2], cex = 0.2)
  }
}

chaos_game_fun <- function(){
  A = c(2,0)
  B = c(2,4)
  C = c(2+sqrt(3),3)
  D = c(2+sqrt(3),1)
  E = c(2-sqrt(3),3)
  F = c(2-sqrt(3),1)
  
  P = list(A,B,C,D,E,F)
  move_point = A
  plot(0:2, 0:2, type = "n")
  points(x = move_point[1],y= move_point[2], cex = 0.2)
  for (i in (1:100000)) {
    direc = unlist(sample(P,1))
    move_point = c(((move_point[1] + direc[1])/3), ((move_point[2] + direc[2])/3))
    points(x = move_point[1], y = move_point[2], cex = 0.2)
  }
}


turtle <- function(start,direc,len){
  radians=direc * (pi/180)
  points(x = start[1], y= start[2], cex = 0.1)
  end = c(((len * (cos(radians)))+start[1]), ((len * sin(radians))+start[2]))
  x = c(start[1], end[1])
  y = c(start[2], end[2])
  lines(x, y)
  return(end)
}

elbow <- function(start,direc,len){
  first=turtle(start,direc,len)
  second=turtle(first,direc-45,0.95*len)
}

spiral <- function(start,direc,len){
  step=turtle(start,direc,len)
  spiral(step,direc-45,0.95*len)
}

spiral_2 <- function(start,direc,len){
  if (len > 0.2){
    step=turtle(start, direc, len)
    spiral_2(step, direc-45, 0.95*(len))
  }
}

tree <- function(start,direc,len){
  if (len > 0.7){
    step=turtle(start, direc, len)
    tree(step, direc-45, 0.65*(len))
    tree(step, direc+45, 0.65*(len))
  }
}

fern <- function(start,direc,len){
  step=turtle(start, direc, len)
  if (len > 0.7){
    fern(step, direc, 0.87*(len))
    fern(step, direc+45, 0.38*(len))
  }
}


fern_2 <- function(start, direc, len, dir){
  start = turtle(start, direc, len)
  if (len > 0.2){
    fern_2(start, direc + dir*45, len*0.38, dir)
    fern_2(start, direc, len*0.87, -dir)
  }
}

plot(0,0,xlim=c(0,400),ylim=c(0,570),type="n" ,ann = F, bty = "n", xaxt = "n", yaxt ="n")
fern_2(c(200,10),90,70,1)

