rm(list=ls())
graphics.off()

## 1 
species_richness <- function(community){
  # Calculate the community's species richness
  #  
  # Args:  
  #   community: A vector represent different individuals  
  # 
  # Returns:  
  #   The size of community's species richness.
  
  return(length(unique(community))) 
}


## 2 
initialise_max <- function(size){
  # Initial the community with maximum richness equals to size
  #  
  # Args:  
  #   size: integer
  # 
  # Returns:  
  #   A vector sequence of numbers from 1 to size
  
  return(seq(size))
}


## 3
initialise_min <- function(size){
  # Initial the community with minimum richness equals to 1
  #  
  # Args:  
  #   size: integer
  # 
  # Returns:  
  #   A vector contains number 1*size times.
  
  return(rep(1,size))
}


## 4 
choose_two <- function(x){
  # Randomly chooses two individuals in the community
  #  
  # Args:  
  #   size: integer
  # 
  # Returns:  
  #   A vector contains number 1*size times.
  
  return(sample(x,2))
}


## 5
neutral_step <- function(community){
  # A single step of a simple neutral model simulation without speciation
  # kills off one individual and allows another to replace it.
  #
  # Args:  
  #   community: a vector represent different individuals 
  # 
  # Returns:  
  #   A new vector representing a new community after the step.
  
  die_repro=choose_two(length(community))
  community[die_repro[1]]=community[die_repro[2]]
  return(community)
}


## 6
neutral_generation <- function(community){
  # Simulate several neutral_steps on a community so that a generation has passed
  #
  # Args:  
  #   community: a vector represent different individuals 
  # 
  # Returns:  
  #   A new vector representing a new community after the a generation.
  
  times=round(length(community)/2)
  for (i in 1:times){
    community=neutral_step(community)
  }
  return(community)
}


## 7
neutral_time_series <- function(initial=initialise_max(7),duration=20){
  # Do a neutral theory simulation and record a time series of species richness
  #
  # Args:  
  #   initial: a vector represents the starting commmunity
  #   duration: integer represents the number generations
  # 
  # Returns:  
  #   A vector containing a time series species richness
  
  richness_series = rep(species_richness(initial),duration+1) # pre-allocated
  community = initial
  for (i in 1:duration){
    community = neutral_generation(community)
    richness_series[i+1] = species_richness(community)
  }
  return(richness_series)
}


## 8. plot and save a time series graph of neutral model species richness
question_8 <- function(){
  y = neutral_time_series(initialise_max(100),duration=200)
  
  pdf(file="../results/Question8.pdf")
  plot(1:length(y), y, xlab="Generations", ylab = "Species Richness", cex=0.8, pch=20,
            main="Netural Model Species Richness Over Time Series", col="blue")
  dev.off()
}


## 9
neutral_step_speciation <- function(community,v){
  # A step of a neutral model simulation with speciation
  # Speciation will replace a dead individual with a new specie (probability v)
  #
  # Args:  
  #   community: a vector represents the starting commmunity
  #   v: integer represents speciation rate
  # 
  # Returns:  
  #   A new vector representing a new community after a step.
  
  prob=runif(1)
  die_repro=choose_two(length(community))
  die=die_repro[1]
  if (prob > v){
    repro=die_repro[2]
    community[die]=community[repro]
  }
  else{
    newspe=max(community)+1
    community[die] = newspe
  }
  return(community)
}


## 10 
neutral_generation_speciation <- function(community,v){
  # Use a neutral simulation with speciation
  # but otherwise performs in the same way as "neutral_generation"
  #
  # Args:  
  #   community: a vector represents the starting commmunity
  #   v: integer represents speciation rate
  # 
  # Returns:  
  #   A new vector representing a new community after a generation.
  
  times=round(length(community)/2)
  for (i in 1:times){
    community=neutral_step_speciation(community,v)
  }
  return(community)
}


## 11
neutral_time_series_speciation <- function(community,v,duration){
  # Do a neutral theory simulation with speciation
  # record a time series of species richness
  #
  # Args:  
  #   initial: a vector represents the starting commmunity
  #   duration: integer represents the number generations
  #   v: integer represents speciation rate
  # 
  # Returns:  
  #   A vector containing a time series species richness
  
  richness_series = rep(species_richness(community),duration+1)   #pre-allocated
  for (i in 1:duration){
    community = neutral_generation_speciation(community,v)
    richness_series[i+1] = species_richness(community)
  }
  return(richness_series)
}


## 12. plot a time series graph of neutral model species richness with speciation in different initialization
question_12 <- function(){
  y1 = neutral_time_series_speciation(initialise_max(100),0.1,duration=200)
  y2 = neutral_time_series_speciation(initialise_min(100),0.1,duration=200)
  x = c(1:length(y1))
  pdf(file="../results/Question12.pdf")
  plot(x, y1,xlab="Generations", ylab = "Species Richness",
       main="Netural Model Species Richness Over Time Series",col="red",pch=20,ylim =c(1,100))
  points(x, y2,col="blue",pch=20)
  legend('topright',c('initialise_max','initialise_min'),
         col=c('red','blue'), pch=c(20,20), bty="n")
  dev.off()
}


## 13
species_abundance <- function(community){
  # Claculate the species abundance
  #
  # Args:  
  #   community: a vector represents the starting commmunity
  # 
  # Returns:  
  #   A vector containing sorted species abundance
  
  return(sort(as.numeric(table(community)),decreasing=T))
}


## 14
octaves <- function(spec_abund){
  # Bin the abundances of species into "octave classes"
  #
  # Args:  
  #   spec_abund: a vector containing sorted species abundance
  # 
  # Returns:  
  #   A vector of the numbers of species in each octave
  
  return(tabulate(floor(log(spec_abund,2)+1)))
}


## 15
sum_vect <- function(x,y){
  # Sum vectors of different lengths
  #
  # Args:  
  #   x, y: two vectors
  # 
  # Returns:  
  #   A summed vector
  
  xlen=length(x)
  ylen=length(y)
  if (ylen>xlen){
    z=x
    x=y
    y=z
  }
  x[1:length(y)]=x[1:length(y)]+y
  return(x)
}


## 16 Support function
neutral_time_series_community_oct <- function(community,v,duration){
  # Sum over generation with speciation
  #
  # Args:  
  #   community: a vector represents the starting commmunity
  #   duration: integer represents the number generations
  #   v: integer represents speciation rate
  # 
  # Returns:  
  #   A list represent status of community and octaves distribution 
  #   after a specific duration.
  
  for (i in 1:duration){
    community = neutral_generation_speciation(community,v)
  }
  result=list(community,octaves(species_abundance(community)))
  return(result)
}


## 16 plotting average species abundance distribution
question_16 <- function(){
  #initialise parameters
  community=initialise_max(100)   
  v=0.1
  burnin=200
  duration=2000
  per=20
  initial = neutral_time_series_community_oct(community,v,burnin)
  community = unlist(initial[1])
  total_oct = unlist(initial[2])
  
  for (i in 1:duration){
    if(i%%per==0){
      interval = neutral_time_series_community_oct(community,v,per)
      community = unlist(interval[1])
      oct = unlist(interval[2])
      total_oct = sum_vect(total_oct,oct) 
    }
  }
  average_oct=total_oct/(floor(duration/per)+1)
  
  # plot
  pdf(file="../results/Question16.pdf")
  barplot(average_oct, main = "Average Species Abundance Distribution", names.arg = c(2^((1:length(average_oct))-1)),
          xlab = "Number of Individuals per Species", ylab = "Number of Species") 
  dev.off()
}


#########################
## Challege Question A ##
#########################
# A function which plots and save the species richness through time, averaged across
# 100 simulations , with 97.2% confidence intervals added at each time point.
challenge_A <- function(duration=200,v=0.1,size=100,alpha=1-0.972,sampling=100){
  
  #times of richness records(generation+initial)
  n=duration+1
  
  #replicate 100 times neutral simulation return 100 samples of time series speices richness
  multi_min=replicate(sampling, neutral_time_series_speciation(initialise_min(size),v,duration))
  multi_max=replicate(sampling, neutral_time_series_speciation(initialise_max(size),v,duration))
  
  #calcualte mean
  mean_multi_min=apply(multi_min,1,mean)
  mean_multi_max=apply(multi_max,1,mean)
  
  #calculate sd
  sd_multi_min=apply(multi_min,1,sd)
  sd_multi_max=apply(multi_max,1,sd)
  
  #calculate confidence interval bias
  #Interval estimates of population mean, population should obey normal distribution
  #population variance is unknown, so we use t-distribution statistic, df=sampling_times-1
  bias_max=sd_multi_max/sqrt(n)*qt(1-alpha/2,df=sampling-1)
  bias_min=sd_multi_min/sqrt(n)*qt(1-alpha/2,df=sampling-1)
  
  confident_interval=data.frame(min_mean=mean_multi_min,
                                min_up=mean_multi_min+bias_min,
                                min_down=mean_multi_min-bias_min,
                                max_mean=mean_multi_max,
                                max_up=mean_multi_max+bias_max,
                                max_down=mean_multi_max-bias_max,stringsAsFactors = TRUE)
  
  #plot
  pdf(file="../results/ChallengeA.pdf")
  plot(confident_interval$min_mean, xlab = "Generation time", ylab = "Mean Species richness", main = "Netural Model Species Richness Over Time Series",
       col = "red", type = "l", ylim = range(0,100))
  segments(c(1:n),confident_interval$min_down,c(1:n),confident_interval$min_up,col="red",lwd = 0.75)   #add confidence interval
  lines(confident_interval$max_mean,  col = "green")
  segments(c(1:n),confident_interval$max_down,c(1:n),confident_interval$max_up,col="green",lwd = 0.75)
  legend('topright',c('initialise_max','initialise_min'),
         col=c('green','red'), pt.cex=0.7, pch=c(20,20), bty="n")
  mtext("Confidence interval = 97.2%",side=4)
  dev.off()
}


#########################
## Challege Question B ##
#########################
initialise_community <- function(size, richness){
  # Create a community with size and richness, each individual
  # should be equally likely to take any species identity
  #
  # Args:  
  #   size: integer represents size of community
  #   richness: integer represents richness
  # 
  # Returns:  
  #   A community vector
  
  community1=seq(richness)
  community2=sample(seq(richness), (size-richness), replace=TRUE)
  community=c(community1,community2)
  return(sample(community))
}

initial_multi_community <- function(size,interval){
  # Create (size/interval)+1 communities with size
  # and richness evenly distributed 
  #
  # Args:  
  #   size: integer represents size of community
  #   interval: integer determine the richness interval
  # 
  # Returns:  
  #   A community matrix, each row represents one community
  
  num = (size/interval)+1
  multi_community=matrix(nrow=num,ncol=size)
  row=1
  for (i in (1:size)){
    if ((i%%interval==0)|(i==1)){
      community=initialise_community(size,i)
      multi_community[row,]=community
      row = row+1
    }
  }
  return(multi_community)
}

# Plots and save many averaged time series for 
# a whole range of different initial species richness.
challenge_B <- function(duration=200,v=0.1,size=100,alpha=1-0.972,sampling=100,interval=1){
  if(interval==1){
    num=size/interval
  } else{
    num=size/interval+1
  }
  
  n=duration+1
  multi_community=initial_multi_community(size,interval)
  
  #replicate 100 times neutral simulation return 100 samples of time series speices richness
  multicom_time_series=matrix(nrow=n,ncol=sampling*num)
  for (i in (1:num)){
    multicom_time_series[1:n,((i-1)*sampling+1):(i*sampling)]=replicate(sampling, neutral_time_series_speciation(multi_community[i,],v,duration))
  }
  
  pdf(file="../results/ChallengeB.pdf")
  #calcualte mean
  mean_multi_community=matrix(nrow=n, ncol=num)
  sd_multi_community=matrix(nrow=n, ncol=num)
  bias_multi_community=matrix(nrow=n, ncol=num)
  up_multi_community=matrix(nrow=n, ncol=num)
  down_multi_community=matrix(nrow=n, ncol=num)
  plot(c(0,n), c(0,size), type = "n",
       xlab = "Generation time", ylab = "Mean Species richness", 
       main = "Average Species Richness Over Time Series \n Using Neutral Model With Speciation")
  mtext("Confidence interval = 97.2%",side=4)
  
  for (i in (1:num)){
    mean_multi_community[,i]=apply(multicom_time_series[1:n,((i-1)*sampling+1):(i*sampling)],1,mean)
    sd_multi_community[,i]=apply(multicom_time_series[1:n,((i-1)*sampling+1):(i*sampling)],1,sd)
    bias_multi_community[,i]=sd_multi_community[,i]/sqrt(n)*qt(1-alpha/2,df=sampling-1)
    up_multi_community[,i]=mean_multi_community[,i]+ bias_multi_community[,i]
    down_multi_community[,i]=mean_multi_community[,i]- bias_multi_community[,i]
    lines(mean_multi_community[,i], col=c(i))
    segments(c(1:n),up_multi_community[,i],c(1:n),down_multi_community[,i],col=c(i))
  }
  dev.off()
}


#######################################################################################################################
############################################### Simulations using HPC #################################################

## 17 
cluster_run <-function(speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,output_file_name){
  # The cluster_run function runs a single iteration of the neutral simulation.
  # During the simulation species abundance and species richness data is recorded
  # and at the end the important information is saved to a .RData file.
  #
  # Args:  
  #   speciation_rate: integer represents speciation rate.
  #   size: integer represents size of community.
  #   wall_time: integer indicating the number of minutes that the simulation should run for.
  #   interval_rich: specifies the number of generations occuring between making recordings 
  #                  of species richness. For our simulations we used 1, ie. species 
  #                  richness was recorded after every generation.
  #   interval_oct: specifies the number of generations between making recordings
  #                 of the species abundance octaves.
  #   burn_in_generations: is the number of generations we used to allow time for the neutral
  #                        simulation to reach a dynamic equilibrium.
  #   output_file_name: output file name, ie. '../results/output.RData'  
  # 
  # Returns:  
  #   .RData file recorded total run time, speciation_rate, size, wall_time, 
  #   interval_rich, interval_oct, burn_in_generations, community, richness, oct.
  
  tic=proc.time()
  community=initialise_min(size)
  richness=c(species_richness(community))
  oct=c(list(octaves(species_abundance(community))))
  generation=0
  while(as.numeric(proc.time()-tic)[3] < (wall_time *60)){
    community=neutral_generation_speciation(community, speciation_rate)
    generation = generation+1
    if ((generation <= burn_in_generations) & (generation%%interval_rich==0)){
      richness = c(richness, species_richness(community))
    }
    if (generation%%interval_oct==0){
      oct=c(oct,list(octaves(species_abundance(community))))
    }
  }
  totaltime=as.numeric(proc.time()-tic)[3]
  save(totaltime,speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,community, richness, oct, file = output_file_name)
}


## 17 culster_run example
#cluster_run(speciation_rate=0.1, size=100, wall_time=10, interval_rich=1, interval_oct=10,
#            burn_in_generations=200, output_file_name='../results/my_test_file_1.RData')


## 18. HPC simulation 
## 19. Shell script in another separate document


## 20. Processing Cluster reults
# Extract and plot the average species abundances distributuions 
# post-burn-in for the different community sizes.
oct_multi_graph <- function(iter=100){
  # Calculate average octaves for each iteration
  #
  # Args:  
  #   iter: integer
  # 
  # Returns:  
  #   All avrage octaves vector
  
  all_iter_averoct=c()
  for (i in (1:iter)){
    file = paste("../results/my_test_file","_",i,".RData",sep = "")
    load(file)
    sum_oct=c(0)
    for (j in (1:length(oct))){
      sum_oct=sum_vect(sum_oct,oct[[j]])
    }
    averoct=sum_oct/length(oct)
    all_iter_averoct=c(all_iter_averoct,list(averoct))
  }
  return(all_iter_averoct)
}

## 20. Plot four bar graphs in a multi-panel graph (one for each simulation size) each 
# showing a mean species abundance octave result from all your simulation runs of that size
question_20 <- function(iter=100){
  all_iter_averoct=oct_multi_graph(iter)
  size500_sum_oct=c(0)
  size1000_sum_oct=c(0)
  size2500_sum_oct=c(0)
  size5000_sum_oct=c(0)
  for (i in (1:length(all_iter_averoct))){
    if(i%%4==1){
      size500_sum_oct = sum_vect(size500_sum_oct,all_iter_averoct[[i]])
    }
    else if(i%%4==2){
      size1000_sum_oct = sum_vect(size1000_sum_oct,all_iter_averoct[[i]])
    }
    else if(i%%4==3){
      size2500_sum_oct = sum_vect(size2500_sum_oct,all_iter_averoct[[i]])
    }
    else if(i%%4==0){
      size5000_sum_oct = sum_vect(size5000_sum_oct,all_iter_averoct[[i]])
    }
  }
  size500_aver_oct=size500_sum_oct/(length(all_iter_averoct)/4)
  size1000_aver_oct=size1000_sum_oct/(length(all_iter_averoct)/4)
  size2500_aver_oct=size2500_sum_oct/(length(all_iter_averoct)/4)
  size5000_aver_oct=size5000_sum_oct/(length(all_iter_averoct)/4)
  
  pdf(file="../results/Question20.pdf")
  par(mfrow = c(2,2),oma=c(0,0,2,0))
  barplot(size500_aver_oct, names.arg = c(2^((1:length(size500_aver_oct))-1)),
          main = "Community size = 500",
          xlab = "Number of Individuals per Species", ylab = "Number of Species", col = "darkblue")
  barplot(size1000_aver_oct, names.arg = c(2^((1:length(size1000_aver_oct))-1)),
          main = "Community size = 1000",
          xlab = "Number of Individuals per Species", ylab = "Number of Species", col = "red")
  barplot(size2500_aver_oct, names.arg = c(2^((1:length(size2500_aver_oct))-1)),
          main = "Community size = 2500",
          xlab = "Number of Individuals per Species", ylab = "Number of Species", col = "green")
  barplot(size5000_aver_oct, names.arg = c(2^((1:length(size5000_aver_oct))-1)),
          main = "Community size = 5000",
          xlab = "Number of Individuals per Species", ylab = "Number of Species")
  title("Average Species Abundance Distribution", outer=TRUE)
  dev.off()
}


#########################
## Challege Question C ##
#########################
# Extracts the time_series data from the .rda files, groups and sums them according to the community
#  size of that simulation, calculates the average time_series for all community sizes and plots them.
challenge_C <- function(iter=100){
  time_series_richness_500 = c(0)
  time_series_richness_1000 = c(0)
  time_series_richness_2500 = c(0)
  time_series_richness_5000 = c(0)
  
  for (i in (1:iter)){
    file = paste("../results/my_test_file","_",i,".RData",sep = "")
    load(file)
    if(i%%4==1){
      time_series_richness_500 = sum_vect(time_series_richness_500, richness)
    }
    else if(i%%4==2){
      time_series_richness_1000 = sum_vect(time_series_richness_1000, richness)
    }
    else if(i%%4==3){
      time_series_richness_2500 = sum_vect(time_series_richness_2500, richness)
    }
    else if(i%%4==0){
      time_series_richness_5000 = sum_vect(time_series_richness_5000, richness)
    }
  }
  
  av_time_series_richness_500 = time_series_richness_500/(iter/4)
  av_time_series_richness_1000 = time_series_richness_1000/(iter/4)
  av_time_series_richness_2500 = time_series_richness_2500/(iter/4)
  av_time_series_richness_5000 = time_series_richness_5000/(iter/4)
  
  plot(c(0,(8*5000)), c(0,100), type = "n",
       xlab = "Generation", ylab = "Species Richness",
       main = "Average Species Richness Over Time")
  lines(seq(0,(8*500)), av_time_series_richness_500[1:(8*500+1)], col = "yellow")
  lines(seq(0,(8*1000)), av_time_series_richness_1000[1:(8*1000+1)], col = "red")
  lines(seq(0,(8*2500)), av_time_series_richness_2500[1:(8*2500+1)], col = "green")
  lines(seq(0,(8*5000)), av_time_series_richness_5000[1:(8*5000+1)], col = "blue")
  legend("topright", title = "Community Size", c("500", "1000", "2500", "5000"),
         lty=1, col = c("yellow", "red", "green", "blue"), cex=0.9, bty="n")
}


#########################
## Challege Question D ##
#########################
# Runs a coalescence simulation and returns a vector of simulated species abundances.
challenge_D <- function(community_size, speciation_rate){
  lineages = initialise_min(community_size)
  abundances = c()
  N = community_size
  theta = speciation_rate*(community_size-1)/(1-speciation_rate)
  
  while (N > 1){
    j = choose_two(length(lineages))
    randnum = runif(1, 0, 1)
    
    if (randnum < theta/(theta+N-1)){
      abundances = c(abundances, lineages[j[1]])
    }
    else lineages[j[2]] = (lineages[j[2]] + lineages[j[1]])
    
    lineages = lineages[-j[1]]
    N = N-1
  }
  abundances = c(abundances, lineages)
  return (abundances)
}

# Run the coalescence model in Challenge_D
run_challenge_D <- function(){
  tick = proc.time()[3]
  sum_oct_500 = c(0)
  sum_oct_1000 = c(0)
  sum_oct_2500 = c(0)
  sum_oct_5000 = c(0)
  
  for (i in 1:100){
    if (i%%4==1){
      sum_oct_500 = sum_vect(sum_oct_500, octaves(challenge_D(500, 0.00201)))
    }
    if ((i%%4==2)){
      sum_oct_1000 = sum_vect(sum_oct_1000, octaves(challenge_D(1000, 0.00201)))
    }
    if (i%%4==3){
      sum_oct_2500 = sum_vect(sum_oct_2500, octaves(challenge_D(2500, 0.00201)))
    }
    if (i%%4==0){
      sum_oct_5000 = sum_vect(sum_oct_5000, octaves(challenge_D(5000, 0.00201)))
    }
  }
  av_oct_500 = sum_oct_500/25
  av_oct_1000 = sum_oct_1000/25
  av_oct_2500 = sum_oct_2500/25
  av_oct_5000 = sum_oct_5000/25
  
  pdf(file="../results/ChallengeD.pdf")
  par(mfrow = c(2,2),oma=c(0,0,2,0))
  barplot(av_oct_500, names.arg = c(2^((1:length(av_oct_500))-1)),
          main = "Community size = 500",
          xlab = "Number of Individuals per Species", ylab = "Number of Species", col = "darkblue")
  barplot(av_oct_1000, names.arg = c(2^((1:length(av_oct_1000))-1)),
          main = "Community size = 1000",
          xlab = "Number of Individuals per Species", ylab = "Number of Species", col = "red")
  barplot(av_oct_2500, names.arg = c(2^((1:length(av_oct_2500))-1)),
          main = "Community size = 2500",
          xlab = "Number of Individuals per Species", ylab = "Number of Species", col = "green")
  barplot(av_oct_5000, names.arg = c(2^((1:length(av_oct_5000))-1)),
          main = "Community size = 5000",
          xlab = "Number of Individuals per Species", ylab = "Number of Species")
  title("Average Species Abundance Distribution", outer=TRUE)
  dev.off()
  
  tock = proc.time()[3]
  run_time = as.numeric(tock - tick)
  print (paste("Time spent by the coalescence theory: ", run_time, "s"))
}

# Calculate the total run time of the cluster based simulations.
cluster_run_time <- function(){
  total_time = 0
  for (i in 1:100){
    file = paste("../results/my_test_file","_",i,".RData",sep = "")
    load(file)
    total_time = total_time + totaltime
  }
  
  print (paste("Time spent by the cluster method: ", total_time, "s"))
}


#######################################################################################################################
################################################ Fractals in nature ###################################################

## 21. Create a slanted Sierpinski Gasket
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


#########################
## Challege Question E ##
#########################
# Starting the chaos game from different initial position
# and try plotting the first 20 steps in a red color.
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


## Create a classic Sierpinski Gasket
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


## Enthusiastic chaos ganme
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


## 23 
turtle <- function(start=c(200,10), direc=90, len=70){
  # Plots a single line on a set of pre-drawn axes and return end coordinates
  #
  # Args:  
  #   start: vector, start coordinates 
  #   direc: direction (angle)
  #   len: length (numeric) of the line.
  #
  # Returns:  
  #   vector, end coordinates 
  
  radians=direc * (pi/180)
  points(x = start[1], y= start[2], cex = 0.1)
  end = c(((len * (cos(radians)))+start[1]), ((len * sin(radians))+start[2]))
  x = c(start[1], end[1])
  y = c(start[2], end[2])
  lines(x, y)
  return(end)
}


## 24
elbow <- function(start=c(200,10), direc=90, len=70){
  # Call turtle twice to draw a pair of lines that join together
  #
  # Args:  
  #   start: vector, start coordinates 
  #   direc: direction (angle)
  #   len: length (numeric) of the line.
  #
  # Returns:  
  #   None
  
  first=turtle(start,direc,len)
  second=turtle(first,direc-45,0.95*len)
}


## 25
spiral <- function(start=c(200,10), direc=90, len=70){
  # Iterative function that draws a spiral, call turtle once then
  # call itself to draw the second line
  #
  # Args:  
  #   start: vector, start coordinates 
  #   direc: direction (angle)
  #   len: length (numeric) of the line.
  #
  # Returns:  
  #   get an error message as expected
  
  step=turtle(start,direc,len)
  spiral(step,direc-45,0.95*len)
}


## 26
spiral_2 <- function(start=c(200,10), direc=90, len=70){
  # Same function as function spiral but
  # add a limited to the smallest length
  
  if (len > 0.2){
    step=turtle(start, direc, len)
    spiral_2(step, direc-45, 0.95*(len))
  }
}


## 27
tree <- function(start=c(200,10), direc=90, len=70){
  # Quite similar function as function spiral_2 but call itself
  # twice with directions that 45 degrees to the right and left.
  
  step=turtle(start, direc, len)
  if (len > 0.7){
    tree(step, direc-45, 0.65*(len))
    tree(step, direc+45, 0.65*(len))
  }
}


## 28
fern <- function(start=c(200,10), direc=90, len=70){
  # Fundamentally similar to function tree but the 
  # new directions and line lengths are altered. 
  
  step=turtle(start, direc, len)
  if (len > 0.7){
    fern(step, direc, 0.87*(len))
    fern(step, direc+45, 0.38*(len))
  }
}


## 29. draw a fern
fern_2 <- function(start=c(200,10), direc=90, len=70, dir=1){
  start = turtle(start, direc, len)
  if (len > 0.2){
    fern_2(start, direc + dir*45, len*0.38, dir)
    fern_2(start, direc, len*0.87, -dir)
  }
}

## plot without axes
plot(0,0,xlim=c(0,400),ylim=c(0,570),type="n" ,ann = F, bty = "n", xaxt = "n", yaxt ="n")
fern_2()


#########################
## Challege Question F ##
#########################
# define a new turtule function added rainbow colors
turtle2 <- function(start,direc,len){
  radians=direc * (pi/180)
  points(x = start[1], y= start[2], cex = 0.1)
  end = c(((len * (cos(radians)))+start[1]), ((len * sin(radians))+start[2]))
  x = c(start[1], end[1])
  y = c(start[2], end[2])
  lines(x, y, col=sample(rainbow(10000),1))
  return(end)
}

# draw a colorful fern
challenge_F <- function(start=c(200,10), direc=90, len=70, dir=1){
  start = turtle2(start, direc, len)
  if (len > 0.2){
    challenge_F(start, direc + dir*45, len*0.38, dir)
    challenge_F(start, direc, len*0.87, -dir)
  }
}

# adjust the angle
challenge_F2 <- function(start=c(200,10), direc=90, len=70, dir=1){
  start = turtle2(start, direc, len)
  if (len > 0.2){
    challenge_F2(start, direc + dir*15, len*0.38, dir)
    challenge_F2(start, direc, len*0.87, -dir)
  }
}

# adjust length change using sqrt()
challenge_F3 <- function(start=c(200,10), direc=90, len=70, dir=1){
  start = turtle2(start, direc, len)
  if (len > 1){
    challenge_F3(start, direc + dir*90, sqrt(len), dir)
    challenge_F3(start, direc, len*0.87, -dir)
  }
}

#plot(0,0,xlim=c(0,400),ylim=c(0,570),type="n" ,ann = F, bty = "n", xaxt = "n", yaxt ="n")
#challenge_F()
#challenge_F2()
#challenge_F3()


#########################
## Challege Question G ##
#########################
# Draw an image equivalent to fern_2 but is much shorter in terms of character
# content and can be run independently, ie. without the need for any other functions.
Challenge_G <- function(s=c(2,0),d=pi/2,l=1,r=1){
  plot(c(0,4),c(0,8),"n")
  f <- function(s,d,l,r){
    e=c(s[1]+l*cos(d),s[2]+l*sin(d))
    lines(c(s[1],e[1]),c(s[2],e[2]))
    if(l>.007){
      f(e,d+r*pi/4,l*.38,r)
      f(e,d,l*.87,-r)}
  }
  f(s,d,l,r)
}

## definition do not count & one line of code
Challenge_G <- function(s=c(3,0),d=pi/2,l=1,r=1,v=segments,o=cos,i=sin,p=plot(c(0,6),c(0,8),"n"),j=f(s,d,l,r), a=0.38, b=0.87, k=0.007, z = pi/4){
  p;f=function(s,d,l,r){e=c(s[1]+l*o(d),s[2]+l*i(d));v(s[1],s[2],e[1],e[2]);if(l>k){f(e,d+r*z,l*a,r);f(e,d,l*b,-r)}};j
}