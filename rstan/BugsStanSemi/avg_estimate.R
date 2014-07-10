# input dat_hoge and run the stan code to estimate AVG with MCMC
library(rstan)
library(data.table)
library(dplyr)
library(magrittr)
library(ggplot2)
library(reshape2)

# dat_A20: batting result of first 20 games
dat = fread("kubo_data.csv")
sample_size = dat$FULLNAME %>% length() 
hit = dat$HIT
atbat = dat$ATBAT

dat
# make list for argument 
data_list = list(N = sample_size, 
                 hit = hit, 
                 atbat = atbat)
# stan code
model_code = '
data{
  int<lower=1> N; // sample size
  int<lower=0> hit[N];
  int<lower=1> atbat[N];
}
parameters{
  real a; // mean skill
  real b[N]; // difference from mean 
  real<lower=0.1> sigma; // variance of b
}
transformed parameters{
  real<lower=0, upper=1> q[N]; // i-th avg
  for (n in 1:N){
    q[n] <- inv_logit(a + b[n]); // a + b[n] : skill_i
  }
}
model{
  sigma ~ uniform(0.1, 10) ; // 無情報事前分布
  a ~ normal(0, 10000); // 無情報事前分布
  b ~ normal(0, sigma); // bの事前分布
  for(n in 1:N){
    hit[n] ~ binomial(atbat[n], q[n]); 
  }
}
'

## running the MCMC 
## stan_res : the result of MCMC
stan_res = stan(model_code=model_code, data = data_list, iter = 10000)

## show the behavior of MCMC sample
# library(coda) stan_res_coda <- mcmc.list(lapply(1:ncol(stan_res),
#                                  function(x) mcmc(as.array(stan_res)[,x,])))
## this process takes a lot of time
# plot(stan_res_coda)

## get the estimated parameter value
## stan_res_param : estimated value of q_i
## stan_res_sigma : estimated value of sigma 
stan_res_param = as.array(stan_res)[,1,(sample_size+3):(2*sample_size + 2)] 
stan_res_sigma = as.array(stan_res)[,1,sample_size+1] 

stan_res_param 
## Example: make plot of q1
q1 = stan_res_param[,1]
qplot(q1, geom="density")
qplot(stan_res_sigma, geom="density")
q1 = as.data.frame(q1) 

# histogram of posterior of q1

ggplot(q1) + 
  geom_histogram(aes(x=q1), fill="white", stat="bin", color="black", binwidth=0.01) +
  ggtitle("Histogram of q_1") + 
  theme(plot.title=element_text(face="bold", size=24)) + 
  theme(legend.position="NULL")

# density plot
ggplot(q1) + 
  geom_density(aes(x=q1), ) + 
  ggtitle("Posterior of q_1") + 
  theme(plot.title=element_text(face="bold", size=24)) + 
  theme(legend.position="NULL")

## check the representive value of estimated parameters
## median, low 5% region, high 5% region
stan_res_param_median = stan_res_param %>% apply(2, median)
stan_res_param_low5 = stan_res_param %>% apply(2, function(x) quantile(x, 0.05))
stan_res_param_high5 = stan_res_param %>% apply(2, function(x) quantile(x, 0.95))

## dataframe of representive value and true value 
stan_res_df = data.frame(median = stan_res_param_median, 
                         low5 = stan_res_param_low5, 
                         high5 = stan_res_param_low5, 
                         true = dat$AVG_SEASON)
stan_res_df

## make plot: median vs true value
ggplot(data = stan_res_df, aes(x=true)) + 
  geom_point(aes(y=median)) + 
  geom_ribbon(data= stan_res_df, aes(ymin = low5, ymax = high5))


## join the original dataframe with result of stan 

dat = fread("kubo_data.csv")
data_stan = cbind(dat, stan_res_param_median)
data_stan %>% setnames(c("FULLNAME", "ATBAT", "HIT", "MLE", "AVG_SEASON", "MCMC"))
write.csv(data_stan, "avg_stan.csv", row.names=FALSE, quote=FALSE)
data_stan
data

## make plot of the result of estimation by MLE
ggplot(data = data_stan , aes(x=AVG_SEASON, y=MLE)) + 
  geom_point(size = 4) + stat_function(fun = function(x) x, linetype="dashed") + 
  ggtitle("ESTIMATE SEASON_AVG with MLE") +
  ggsave("MLE.pdf")

## make plot of the result of estimation by MCMC
ggplot(data = data_stan , aes(x=AVG_SEASON, y=MCMC)) + 
  geom_point(size = 4) + stat_function(fun = function(x) x, linetype="dashed") + 
  ggtitle("ESTIMATE SEASON_AVG with MCMC") + 
  ggsave("BHM.pdf")

## compare MCMC vs MLE 
data_stan %>% 
  dplyr::select(FULLNAME, MLE, AVG_SEASON, MCMC) %>% 
  reshape2::melt(id.var=c("FULLNAME", "AVG_SEASON")) %>% 
  ggplot(aes(x=AVG_SEASON, y=value, colour=variable)) + geom_point(size=8, alpha=1.0) +
  stat_function(fun=function(x) x, linetype="dashed", size=3, color="black") +
  ylab("AVG") + 
  ggtitle("Estimate SEASON_AVG with BHM") +
  ggsave("BHMvsMLE.pdf")

 # check the result
data_stan
