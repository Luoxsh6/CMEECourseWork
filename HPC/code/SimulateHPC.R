rm(list=ls())
graphics.off()

species_richness <- function(community){
  return(length(unique(community)))  
}

initialise_min <- function(size){
  return(rep(1,size))
}

choose_two <- function(x){
  return(sample(x,2))
}

neutral_step_speciation <- function(community,v){
  prob=runif(1)
  die_repro=choose_two(length(community))
  die=die_repro[1]
  if (prob > v){
    repro=die_repro[2]
    community[die]=community[repro]
  }
  else{
    newspe=max(unique(community))+1
    community[die] = newspe
  }
  return(community)
}

neutral_generation_speciation <- function(community,v){
  times=round(length(community)/2)
  for (i in 1:times){
    community=neutral_step_speciation(community,v)
  }
  return(community)
}

species_abundance <- function(community){
  return(sort(as.numeric(table(community)),decreasing=T))
}

octaves <- function(specabunt){
  return(tabulate(floor(log(specabunt,2)+1)))
}

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


#cluster_run(speciation_rate = 0.1, size = 100, wall_time = 0.005, interval_rich = 1, interval_oct = 100, 
            #burn_in_generations = 10, output_file_name = "../results/my_test_file",1)

getsize <- function(iter){
  if (iter%%4==1){
    size=500
  }
  if (iter%%4==2){
    size=1000
  }
  if (iter%%4==3){
    size=2500
  }
  if (iter%%4==0){
    size=5000
  }
  return(size)
}

do_simulation <- function(iter){
  set.seed(iter)
  speciation_rate = 0.00201
  size = getsize(iter)
  time_to_run = 11.5*60
  output_filename = "my_test_file"
  cluster_run(speciation_rate, size, time_to_run, interval_rich=1, interval_oct=(size/10), burn_in_generations=(8*size), output_filename, iter)
}

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
do_simulation(iter)


#do_simulation(1)
#do_simulation(2)
#do_simulation(3)
#do_simulation(4)