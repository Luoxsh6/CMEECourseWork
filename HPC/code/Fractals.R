rm(list=ls())
graphics.off()

chaos_game <-  function(){
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
  if (len > 0.7){
    step=turtle(start, direc, len)
    fern(step, direc, 0.87*(len))
    fern(step, direc+45, 0.38*(len))
  }
}

fern_2 <- function(start,direc,len,dir){
  if (len > 0.7){
    if (dir==-1){
      step = turtle(start, direc, len)
      fern_2(step, direc-45, 0.38*(len),dir)
      fern_2(step, direc, 0.87*(len), -dir)
    }
    else if(dir==1){
      step = turtle(start, direc, len)
      fern_2(step, direc+45, 0.38*(len),dir)
      fern_2(step, direc, 0.87*(len), -dir)
    }
  }
}

plot(0,0,xlim=c(0,570),ylim=c(0,570),type="n")
fern_2(c(200,10),90,70,1)
