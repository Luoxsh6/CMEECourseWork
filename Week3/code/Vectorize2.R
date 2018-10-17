# Runs the stochastic (with gaussian fluctuations) Ricker Eqn .

rm(list=ls())

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (pop in 1:length(p0)) #loop through the populations
  {
    for (yr in 2:numyears) #for each pop, loop through the years
    {
      N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma))
    }
  }
 return(N)

}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

# print("Vectorized Stochastic Ricker takes:")
# print(system.time(res2<-stochrickvect()))

Ricker <- function(N0=1, r=1, K=10, generations=50)
{
  # Runs a simulation of the Ricker model
  # Returns a vector of length generations

  N <- rep(NA, generations)    # Creates a vector of NA

  N[1] <- N0
  for (t in 2:generations)
  {
    N[t] <- N[t-1] * exp(r*(1.0-(N[t-1]/K)))
  }
  return (N)
}

plot(Ricker(generations=10), type="l")
