rm(list=ls())
graphics.off()

# copy the function

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


cluster_run <-function(speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,output_file_name,iter){
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
  #   iter: receive from PBS
  # 
  # Returns:  
  #   .RData file recorded total run time, speciation_rate, size, wall_time, 
  #   interval_rich, interval_oct, burn_in_generations, community, richness, oct.
  
  tic=proc.time() # record run time
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


## run local
#cluster_run(speciation_rate = 0.1, size = 100, wall_time = 0.005, interval_rich = 1, interval_oct = 100, 
#            burn_in_generations = 10, output_file_name = "../results/my_test_file",1)


## allocate size to each iter
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


## Do simulate and save results with speciation_rate 0.00201
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