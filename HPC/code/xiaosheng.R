rm(list=ls())
graphics.off()

#1 calculate the community's species richness
species_richness <- function(community){
  return(length(unique(community))) 
}


#2 initial the community with maximum richness equals to size
initialise_max <- function(size){
  return(seq(size))
}


#3 initial the community with minimum richness equals to 1
initialise_min <- function(size){
  return(rep(1,size))
}


#4 choose two individuals in the community
choose_two <- function(x){
  return(sample(x,2))
}


#5 a single step of a simple neutral model simulation without speciation
neutral_step <- function(community){
  die_repro=choose_two(length(community))
  community[die_repro[1]]=community[die_repro[2]]
  return(community)
}


#6 simulate several neutral_steps on a community so that a generation has passed
neutral_generation <- function(community){
  times=round(length(community)/2)
  for (i in 1:times){
    community=neutral_step(community)
  }
  return(community)
}


#7 do a neutral theory simulation and return a time series of species richness
neutral_time_series <- function(initial=initialise_max(7),duration=20){
  richness_series = rep(species_richness(initial),duration+1)    #pre-allocated
  community = initial
  for (i in 1:duration){
    community = neutral_generation(community)
    richness_series[i+1] = species_richness(community)
  }
  return(richness_series)
}


#8 plot a time series graph of neutral model species richness
question_8 <- function(){
  y = neutral_time_series(initialise_max(100),duration=200)
  
  pdf(file="../results/Question8.pdf")
  plot(1:length(y), y, xlab="Generations", ylab = "Species Richness", cex=0.8, pch=20,
            main="Netural Model Species Richness Over Time Series", col="blue")
  dev.off()
}


#9 a step of a neutral model simulation with speciation (probability v)
neutral_step_speciation <- function(community,v){
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


#10 uses a neutral simulation with speciation, but otherwise performs in the same way as "neutral_generation"
neutral_generation_speciation <- function(community,v){
  times=round(length(community)/2)
  for (i in 1:times){
    community=neutral_step_speciation(community,v)
  }
  return(community)
}


#11 uses a neutral simulation with speciation, but otherwise performs in the same way as "neutral_time_series"
neutral_time_series_speciation <- function(community,v,duration){
  richness_series = rep(species_richness(community),duration+1)   #pre-allocated
  for (i in 1:duration){
    community = neutral_generation_speciation(community,v)
    richness_series[i+1] = species_richness(community)
  }
  return(richness_series)
}


#12 plot a time series graph of neutral model species richness with speciation in different initialization
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


#13 claculate all species abundance
species_abundance <- function(community){
  return(sort(as.numeric(table(community)),decreasing=T))
}


#14 bin the abundances of species into "octave classes"
octaves <- function(spec_abunt){
  return(tabulate(floor(log(spec_abunt,2)+1)))
}


#15 sum vectors of different lengths
sum_vect <- function(x,y){
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


#16 claculate and return the community and octaves distribution in one list over generation with speciation
neutral_time_series_community_oct <- function(community,v,duration){
  for (i in 1:duration){
    community = neutral_generation_speciation(community,v)
  }
  result=list(community,octaves(species_abundance(community)))
  return(result)
}


#16 plotting average species abundance distribution
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
  pdf(file="../results/Question16.pdf")
  barplot(average_oct, main = "Average Species Abundance Distribution", names.arg = c(2^((1:length(average_oct))-1)),
          xlab = "Number of Individuals per Species", ylab = "Number of Species") 
  dev.off()
}


##Challege Question A
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


#Challege Question B
initialise_community <- function(size, richness){
  community1=seq(richness)
  community2=sample(seq(richness), (size-richness), replace=TRUE)
  community=c(community1,community2)
  return(sample(community))
}

initial_multi_community <- function(size,interval){
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


###################################### Simulations using HPC ###########################################

#17 
cluster_run <-function(speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,output_file_name,iter){
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
  save(totaltime,speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,community, richness, oct, file = paste(output_file_name, "_", iter,".RData",sep = ""))
}


#20
oct_multi_graph <- function(iter=100){
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


#Challenge Question C
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


#Challenge Question D
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


cluster_run_time <- function(){
  total_time = 0
  for (i in 1:100){
    file = paste("../results/my_test_file","_",i,".RData",sep = "")
    load(file)
    total_time = total_time + totaltime
  }
  
  print (paste("Time spent by the cluster method: ", total_time, "s"))
}
