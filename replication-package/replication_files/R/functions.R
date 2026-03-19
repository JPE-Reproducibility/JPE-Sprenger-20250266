#### McGranaghan et al. (2026)
#### functions.R
#### ------------------------
#### This source file produces functions used in McGranaghan et al.
#### Function list:
####      1. likelihood_rf: likelihood function for mean vector and elements of variance covariance matrix
####         for first stage behavior on a given dataset. Estimator accounts for bunching
####      2. estimate_rf: based on a given dataset produces estimator's starting values
####         based on sample means, variances and covariances. Then maximizes likelihood and produces estimates.
####      3. calculate_rf: based on a given dataset produces calculations 
####         based on sample means, variances and covariances. 
####      4. interpret_rf: a function that translates from estimated values to the distributions of CRP, CCP, MXP 
####      5. interpret_rf_calc: a function that translates from calculated values to the distributions of CRP, CCP, MXP 
####      6. simulate_rf: a function that translates estimated values into proportions of preference categories 
####         such as CRP_CCP_MXP, RCRP_CCP_MXP, etc.
####      7. simulate_rf_calc: a function that translates calculate values into proportions of preference categories 
####         such as CRP_CCP_MXP, RCRP_CCP_MXP, etc.

#### 1. likelihood_rf
likelihood_rf <- function(h_X, h_Y, h_Z, 
                      gamma_X, gamma_Y, gamma_Z,
                      kappa_X, kappa_Y, kappa_Z,
                      covXY, covXZ, covYZ) {
  ## Stage 1 Mean Vector 
  m1 <- c(h_X, h_Y, h_Z, h_X, h_Y, h_Z) 
  ## Stage 1 Variance-Covariance Matrix 
  s11 <-  as.matrix(rbind(
    c(gamma_X^2 + kappa_X^2, covXY, covXZ, gamma_X^2, covXY, covXZ  ),
    c(covXY , gamma_Y^2 + kappa_Y^2, covYZ,  covXY, gamma_Y^2, covYZ),
    c(covXZ , covYZ, gamma_Z^2 + kappa_Z^2,  covXZ, covYZ, gamma_Z^2),
    c(gamma_X^2, covXY, covXZ, gamma_X^2  + kappa_X^2, covXY, covXZ  ),
    c(covXY , gamma_Y^2, covYZ,  covXY, gamma_Y^2  + kappa_Y^2, covYZ),
    c(covXZ , covYZ, gamma_Z^2 ,  covXZ, covYZ, gamma_Z^2 + kappa_Z^2)
  ))
  
  ## General Probability of Observation Set  For Stage 1
  pfunc1 <- Vectorize(function(a_l,b_l, c_l, d_l, e_l, f_l, a_u, b_u, c_u, d_u, e_u, f_u) {
    # Establish Probability Given Mean Vector and Variance-Covariance Matrix
    pmvnorm(lower= c(a_l,b_l, c_l, d_l,e_l, f_l), upper = c(a_u, b_u, c_u, d_u, e_u, f_u), mean = m1, sigma = (s11 + t(s11))/2 )
  })
  
  
  ## Establish Stage 1 Likelihood (observation account for bunching)
  l1i <- pfunc1(ifelse(dataset$h_ac > dataset$p*30, dataset$h_ac-0.5, -Inf),
                ifelse(dataset$h_ab > dataset$p*30,  dataset$h_ab-0.5, -Inf),
               ifelse(dataset$h_de > dataset$p*30, dataset$h_de-0.5,  -Inf),
               ifelse(is.na(dataset$h_ac_repeat), -Inf, ifelse(dataset$h_ac_repeat > dataset$p*30,  dataset$h_ac_repeat-0.5, -Inf)),
               ifelse(is.na(dataset$h_ab_repeat), -Inf, ifelse(dataset$h_ab_repeat > dataset$p*30,  dataset$h_ab_repeat-0.5, -Inf)),
               ifelse(is.na(dataset$h_de_repeat), -Inf, ifelse(dataset$h_de_repeat > dataset$p*30,  dataset$h_de_repeat-0.5, -Inf)),
                ifelse(dataset$h_ac < ((dataset$p*30)+50), dataset$h_ac+0.5, Inf),
                ifelse(dataset$h_ab < ((dataset$p*30)+50),  dataset$h_ab+0.5,  Inf),
                ifelse(dataset$h_de < ((dataset$p*30)+50), dataset$h_de+0.5,  Inf),
                ifelse(is.na(dataset$h_ac_repeat), Inf, ifelse(dataset$h_ac_repeat < ((dataset$p*30)+50), dataset$h_ac_repeat+0.5, Inf)),
                ifelse(is.na(dataset$h_ab_repeat), Inf, ifelse(dataset$h_ab_repeat < ((dataset$p*30)+50), dataset$h_ab_repeat+0.5,  Inf)),
                ifelse(is.na(dataset$h_de_repeat), Inf, ifelse(dataset$h_de_repeat < ((dataset$p*30)+50), dataset$h_de_repeat+0.5, Inf))
  )
  
  #### Calculate Grand Likelihood
  ll <- -sum(log(l1i))
  
  return(ll)
}


#### 2. estimate_rf
estimate_rf <- function(dataset) {
  ### Step 1: Starting Values 
  h_Xstart <- 1*mean(c(dataset$h_ac,dataset$h_ac_repeat), na.rm=TRUE)
  h_Ystart <- 1*mean(c(dataset$h_ab,dataset$h_ab_repeat), na.rm=TRUE)
  h_Zstart <- 1*mean(c(dataset$h_de,dataset$h_de_repeat), na.rm=TRUE)
  gamma_Xstart <- 1*sqrt(cov(dataset$h_ac, dataset$h_ac_repeat, use="complete.obs"))
  gamma_Ystart <- 1*sqrt(cov(dataset$h_ab, dataset$h_ab_repeat, use="complete.obs"))
  gamma_Zstart <- 1*sqrt(cov(dataset$h_de, dataset$h_de_repeat, use="complete.obs"))
  kappa_Xstart <- 1*sqrt(var(dataset$h_ac) - cov(dataset$h_ac, dataset$h_ac_repeat, use="complete.obs"))
  kappa_Ystart <- 1*sqrt(var(dataset$h_ab) - cov(dataset$h_ab, dataset$h_ab_repeat, use="complete.obs"))
  kappa_Zstart <- 1*sqrt(var(dataset$h_de) - cov(dataset$h_de, dataset$h_de_repeat, use="complete.obs"))
  covXYstart <- 1*cov(dataset$h_ac, dataset$h_ab)
  covXZstart <- 1*cov(dataset$h_ac, dataset$h_de)
  covYZstart <- 1*cov(dataset$h_ab, dataset$h_de)
  
  start_vec = list(h_X = h_Xstart, h_Y = h_Ystart, h_Z= h_Zstart,
                 gamma_X = gamma_Xstart, gamma_Y = gamma_Ystart,   gamma_Z = gamma_Zstart,  
                 kappa_X = kappa_Xstart, kappa_Y = kappa_Ystart, kappa_Z = kappa_Zstart, 
                 covXY = covXYstart,  covXZ =covXZstart,  covYZ =covYZstart)
  
  ## Step 2: Estimate (2 attempts at estimation, followed by NA if failure)
  estimates <- tryCatch(mle(likelihood_rf, start=start_vec, method="L-BFGS-B",
                            lower = c(0, 0, 0,
                                      0, 0, 0,
                                      0, 0, 0, 
                                      -2*covXYstart, -2*covXZstart, -2*covYZstart),
                            upper = c( 100, 100, 100, 
                                       2*gamma_Xstart, 2*gamma_Ystart, 2*gamma_Zstart,
                                       2*kappa_Xstart, 2*kappa_Ystart, 2*kappa_Zstart,
                                       2*covXYstart, 2*covXZstart, 2*covYZstart),
                            control=list(trace=1, maxit=500)), 
                        error=function(e){
                          tryCatch(mle(likelihood_rf, start=start_vec, method="CG",
                                       control=list(trace=1, maxit=500)),
                                   error=function(e){NA})
                        })
  return(estimates)
}


#### 3. calculate_rf
calculate_rf <- function(dataset) {
  ### Step 1: Starting Values 
  h_Xstart <- 1*mean(c(dataset$h_ac,dataset$h_ac_repeat), na.rm=TRUE)
  h_Ystart <- 1*mean(c(dataset$h_ab,dataset$h_ab_repeat), na.rm=TRUE)
  h_Zstart <- 1*mean(c(dataset$h_de,dataset$h_de_repeat), na.rm=TRUE)
  gamma_Xstart <- 1*sqrt(cov(dataset$h_ac, dataset$h_ac_repeat, use="complete.obs"))
  gamma_Ystart <- 1*sqrt(cov(dataset$h_ab, dataset$h_ab_repeat, use="complete.obs"))
  gamma_Zstart <- 1*sqrt(cov(dataset$h_de, dataset$h_de_repeat, use="complete.obs"))
  kappa_Xstart <- 1*sqrt(var(c(dataset$h_ac, dataset$h_ac_repeat), use="complete.obs") - cov(dataset$h_ac, dataset$h_ac_repeat, use="complete.obs"))
  kappa_Ystart <- 1*sqrt(var(c(dataset$h_ab,  dataset$h_ab_repeat), use="complete.obs") - cov(dataset$h_ab, dataset$h_ab_repeat, use="complete.obs"))
  kappa_Zstart <- 1*sqrt(var(c(dataset$h_de,  dataset$h_de_repeat), use="complete.obs") - cov(dataset$h_de, dataset$h_de_repeat, use="complete.obs"))
  covXYstart <- 1*cov(c(dataset$h_ac, dataset$h_ac_repeat), c(dataset$h_ab,  dataset$h_ab_repeat), use="complete.obs")
  covXZstart <- 1*cov(c(dataset$h_ac, dataset$h_ac_repeat), c(dataset$h_de,  dataset$h_de_repeat), use="complete.obs")
  covYZstart <-  1*cov(c(dataset$h_ab, dataset$h_ab_repeat), c(dataset$h_de,  dataset$h_de_repeat), use="complete.obs")
  
  values <- c( h_Xstart, h_Ystart, h_Zstart,
                   gamma_Xstart, gamma_Ystart,  gamma_Zstart,  
                   kappa_Xstart, kappa_Ystart,  kappa_Zstart, 
                    covXYstart,  covXZstart,  covYZstart)

  return(values)
}



#### 3. interpret_rf 
interpret_rf <- function(estimates, i, j) {
  #### Fitted means of true CRP, CCP, MXP
  mean_CRP <- coef(estimates)[1]-coef(estimates)[3]
  mean_CCP <- coef(estimates)[2]-coef(estimates)[3]
  mean_MXP <- coef(estimates)[1]-coef(estimates)[2]
  #### Fitted standard deviations of true CRP, CCP, MXP
  var_CRP <- (coef(estimates)[4])^2 + (coef(estimates)[6])^2 - (2*coef(estimates)[11])
  var_CCP <- (coef(estimates)[5])^2 + (coef(estimates)[6])^2 - (2*coef(estimates)[12])
  var_MXP <- (coef(estimates)[4])^2 + (coef(estimates)[5])^2 - (2*coef(estimates)[10])
  sd_CRP <- ifelse(var_CRP>0,sqrt(var_CRP),0)
  sd_CCP <- ifelse(var_CCP>0,sqrt(var_CCP),0)
  sd_MXP <- ifelse(var_MXP>0,sqrt(var_MXP),0)
  #### Fitted standard deviations of reports
  var_CRE_hat <- (coef(estimates)[4])^2  + coef(estimates)[7]^2 + (coef(estimates)[6])^2 + (coef(estimates)[9])^2 - (2*coef(estimates)[11])
  var_CCE_hat <- (coef(estimates)[5])^2  + coef(estimates)[8]^2 + (coef(estimates)[6])^2 + (coef(estimates)[9])^2 - (2*coef(estimates)[12])
  var_MXE_hat <- (coef(estimates)[4])^2  + coef(estimates)[7]^2 + (coef(estimates)[5])^2 + (coef(estimates)[8])^2 - (2*coef(estimates)[10])
  sd_CRE_hat <- sqrt(var_CRE_hat)
  sd_CCE_hat <- sqrt(var_CCE_hat)
  sd_MXE_hat <- sqrt(var_MXE_hat)
  #### Actual Means and Standard Deviations;  (make sure (i,j)  correspond to estimates); note that we're using all the data)
  dataset <- subset(dataset_master, abs(p -(pvals[i]/100)) <= .01 & abs(r -(rvals[j]/100)) <= .01  )
  mean_CRE <- mean(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  mean_CCE <- mean(c(dataset$h_ab, dataset$h_ab_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  mean_MXE <- mean(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_ab, dataset$h_ab_repeat), na.rm=TRUE)
  sd_CRE <-  sd(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  sd_CCE <-  sd(c(dataset$h_ab, dataset$h_ab_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  sd_MXE <-  sd(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_ab, dataset$h_ab_repeat), na.rm=TRUE)
  pval <- pvals[i]
  rval <- rvals[j]
  
  #### Return Fitted and Actual Values
  #mat_entry <- round(cbind( pval, rval, mean_CRP, mean_CCP, mean_MXP, sd_CRP, sd_CCP, sd_MXP, sd_CRE_hat, sd_CCE_hat, sd_MXE_hat, 
     #                 mean_CRE, mean_CCE, mean_MXE, sd_CRE, sd_CCE, sd_MXE),2)
  
  mat_entry <- round(cbind( pval, rval, mean_CRP, mean_CCP, mean_MXP, var_CRP, var_CCP, var_MXP, var_CRE_hat, var_CCE_hat, var_MXE_hat, 
                            var_CRP/var_CRE_hat, var_CCP/var_CCE_hat, var_MXP/var_MXE_hat),2)
  
  
  return(mat_entry)
}


#### 4. interpret_rf_levels 
interpret_rf_levels <- function(estimates, i, j) {
  #### Fitted means of true preferences
  mean_h_ac_star <- coef(estimates)[1]
  mean_h_ab_star <- coef(estimates)[2]
  mean_h_de_star <- coef(estimates)[3]
  #### Fitted variances of true preferences
  theta2_ac <- coef(estimates)[4]^2
  theta2_ab <- coef(estimates)[5]^2
  theta2_de <- coef(estimates)[6]^2
  #### Fitted noise variances
  sigma2_ac <- coef(estimates)[7]^2
  sigma2_ab <-  coef(estimates)[8]^2
  sigma2_de <-  coef(estimates)[9]^2
  #### Fitted Covariances 
  theta_acab <- coef(estimates)[10]
  theta_acde <-  coef(estimates)[11]
  theta_abde <-  coef(estimates)[12]
  
  pval <- pvals[i]
  rval <- rvals[j]
  
  #### Return Values
  
  mat_entry <- round(cbind( pval, rval, 
                            mean_h_ac_star, mean_h_ab_star, mean_h_de_star,
                            theta2_ac, theta2_ab, theta2_de, 
                            sigma2_ac, sigma2_ab, sigma2_de,
                            theta_acab , theta_acde , theta_abde,
                            theta2_ac/(theta2_ac + sigma2_ac),
                            theta2_ab/(theta2_ab + sigma2_ab),
                            theta2_de/(theta2_de + sigma2_de)
                            ),2)
  
  return(mat_entry)
}



#### 5. interpret_rf_calc 
interpret_rf_calc <- function(estimates, i, j) {
  #### Fitted means of true CRP, CCP, MXP
  mean_CRP <- (estimates)[1]-(estimates)[3]
  mean_CCP <- (estimates)[2]-(estimates)[3]
  mean_MXP <- (estimates)[1]-(estimates)[2]
  #### Fitted standard deviations of true CRP, CCP, MXP
  var_CRP <- ((estimates)[4])^2 + ((estimates)[6])^2 - (2*(estimates)[11])
  var_CCP <- ((estimates)[5])^2 + ((estimates)[6])^2 - (2*(estimates)[12])
  var_MXP <- ((estimates)[4])^2 + ((estimates)[5])^2 - (2*(estimates)[10])
  var_MXP <- ifelse(var_MXP >0, var_MXP, NA)
  sd_CRP <- ifelse(var_CRP>0,sqrt(var_CRP),0)
  sd_CCP <- ifelse(var_CCP>0,sqrt(var_CCP),0)
  sd_MXP <- ifelse(var_MXP>0,sqrt(var_MXP),0)
  #### Fitted standard deviations of reports
  var_CRE_hat <- ((estimates)[4])^2  + (estimates)[7]^2 + ((estimates)[6])^2 + ((estimates)[9])^2 - (2*(estimates)[11])
  var_CCE_hat <- ((estimates)[5])^2  + (estimates)[8]^2 + ((estimates)[6])^2 + ((estimates)[9])^2 - (2*(estimates)[12])
  var_MXE_hat <- ((estimates)[4])^2  + (estimates)[7]^2 + ((estimates)[5])^2 + ((estimates)[8])^2 - (2*(estimates)[10])
  sd_CRE_hat <- sqrt(var_CRE_hat)
  sd_CCE_hat <- sqrt(var_CCE_hat)
  sd_MXE_hat <- sqrt(var_MXE_hat)
  #### Actual Means and Standard Deviations;  (make sure (i,j)  correspond to estimates); note that we're using all the data)
  dataset <- subset(dataset_master, abs(p -(pvals[i]/100)) <= .01 & abs(r -(rvals[j]/100)) <= .01  )
  mean_CRE <- mean(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  mean_CCE <- mean(c(dataset$h_ab, dataset$h_ab_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  mean_MXE <- mean(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_ab, dataset$h_ab_repeat), na.rm=TRUE)
  sd_CRE <-  sd(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  sd_CCE <-  sd(c(dataset$h_ab, dataset$h_ab_repeat) -c(dataset$h_de, dataset$h_de_repeat), na.rm=TRUE)
  sd_MXE <-  sd(c(dataset$h_ac, dataset$h_ac_repeat) -c(dataset$h_ab, dataset$h_ab_repeat), na.rm=TRUE)
  pval <- pvals[i]
  rval <- rvals[j]
  
  #### Return Fitted and Actual Values

  mat_entry <- round(cbind( pval, rval, mean_CRP, mean_CCP, mean_MXP, var_CRP, var_CCP, var_MXP, var_CRE_hat, var_CCE_hat, var_MXE_hat, 
                            var_CRP/var_CRE_hat, var_CCP/var_CCE_hat, var_MXP/var_MXE_hat),2)
  
  
  
  return(mat_entry)
}


#### 6. interpret_rf_calc_levels 
interpret_rf_calc_levels <- function(estimates, i, j) {
  #### Fitted means of true preferences
  mean_h_ac_star <- (estimates)[1]
  mean_h_ab_star <- (estimates)[2]
  mean_h_de_star <- (estimates)[3]
  #### Fitted variances of true preferences
  theta2_ac <- (estimates)[4]^2
  theta2_ab <- (estimates)[5]^2
  theta2_de <- (estimates)[6]^2
  #### Fitted noise variances
  sigma2_ac <- (estimates)[7]^2
  sigma2_ab <-  (estimates)[8]^2
  sigma2_de <-  (estimates)[9]^2
  #### Fitted Covariances 
  theta_acab <- (estimates)[10]
  theta_acde <-  (estimates)[11]
  theta_abde <-  (estimates)[12]
  
  pval <- pvals[i]
  rval <- rvals[j]
  
  #### Return Values
  
  mat_entry <- round(cbind( pval, rval, 
                            mean_h_ac_star, mean_h_ab_star, mean_h_de_star,
                            theta2_ac, theta2_ab, theta2_de, 
                            sigma2_ac, sigma2_ab, sigma2_de,
                            theta_acab , theta_acde , theta_abde,
                            theta2_ac/(theta2_ac + sigma2_ac),
                            theta2_ab/(theta2_ab + sigma2_ab),
                            theta2_de/(theta2_de + sigma2_de)
  ),2)
  
  return(mat_entry)
}




#### 7. simulate_rf
simulate_rf <- function(estimates) {
  #### Assign Values
  h_X <- coef(estimates)[1]
  h_Y <- coef(estimates)[2]
  h_Z <- coef(estimates)[3]
  gamma_X <- coef(estimates)[4]
  gamma_Y <- coef(estimates)[5]
  gamma_Z <- coef(estimates)[6]
  covXY <- coef(estimates)[10]
  covXZ <- coef(estimates)[11]
  covYZ <- coef(estimates)[12]
  
  #### Mean Preference Vector 
  m <- c(h_X, h_Y, h_Z) 
  #### Preference Component of Variance-Covariance Matrix 
  s <-  as.matrix(rbind(
    c(gamma_X^2, covXY, covXZ ),
    c(covXY , gamma_Y^2 , covYZ),
    c(covXZ , covYZ, gamma_Z^2)
  ))
  
  #### Construct Simulated Preference Dataset
  data_synth <- rmvnorm(100000, mean = m, sigma =s)
  h_AC_synth <- (ceiling(data_synth[,1]) + floor(data_synth[,1]) )/2
  h_AB_synth <- (ceiling(data_synth[,2]) + floor(data_synth[,2]) )/2
  h_DE_synth <- (ceiling(data_synth[,3]) + floor(data_synth[,3]) )/2
  
  #### CRP, CCP, MXP 
  CRP_synth <- ifelse(h_AC_synth>h_DE_synth, 1, ifelse(h_AC_synth==h_DE_synth, 0, -1))
  CCP_synth <- ifelse(h_AB_synth>h_DE_synth, 1, ifelse(h_AB_synth==h_DE_synth, 0, -1))
  MXP_synth <- ifelse(h_AC_synth>h_AB_synth, 1, ifelse(h_AC_synth==h_AB_synth, 0, -1))
  
  #### Cases 
  CRP_CCP_MXP <- mean(ifelse(CRP_synth==1 & CCP_synth==1& MXP_synth==1, 1, 0))
  CRP_CCP_RMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==1& MXP_synth==-1, 1, 0))
  CRP_CCP_NMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==1& MXP_synth==0, 1, 0))
  
  CRP_RCCP_MXP <- mean(ifelse(CRP_synth==1 & CCP_synth==-1& MXP_synth==1, 1, 0))
  CRP_RCCP_RMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==-1& MXP_synth==-1, 1, 0))
  CRP_RCCP_NMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==-1& MXP_synth==0, 1, 0))
  
  CRP_NCCP_MXP <- mean(ifelse(CRP_synth==1 & CCP_synth==0& MXP_synth==1, 1, 0))
  CRP_NCCP_RMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==0& MXP_synth==-1, 1, 0))
  CRP_NCCP_NMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==0& MXP_synth==0, 1, 0))
  
  NCRP_CCP_MXP <- mean(ifelse(CRP_synth==0 & CCP_synth==1& MXP_synth==1, 1, 0))
  NCRP_CCP_RMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==1& MXP_synth==-1, 1, 0))
  NCRP_CCP_NMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==1& MXP_synth==0, 1, 0))
  
  NCRP_RCCP_MXP <- mean(ifelse(CRP_synth==0 & CCP_synth==-1& MXP_synth==1, 1, 0))
  NCRP_RCCP_RMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==-1& MXP_synth==-1, 1, 0))
  NCRP_RCCP_NMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==-1& MXP_synth==0, 1, 0))
  
  NCRP_NCCP_MXP <- mean(ifelse(CRP_synth==0 & CCP_synth==0& MXP_synth==1, 1, 0))
  NCRP_NCCP_RMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==0& MXP_synth==-1, 1, 0))
  NCRP_NCCP_NMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==0& MXP_synth==0, 1, 0))
  
  RCRP_CCP_MXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==1& MXP_synth==1, 1, 0))
  RCRP_CCP_RMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==1& MXP_synth==-1, 1, 0))
  RCRP_CCP_NMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==1& MXP_synth==0, 1, 0))
  
  RCRP_RCCP_MXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==-1& MXP_synth==1, 1, 0))
  RCRP_RCCP_RMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==-1& MXP_synth==-1, 1, 0))
  RCRP_RCCP_NMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==-1& MXP_synth==0, 1, 0))
  
  RCRP_NCCP_MXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==0& MXP_synth==1, 1, 0))
  RCRP_NCCP_RMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==0& MXP_synth==-1, 1, 0))
  RCRP_NCCP_NMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==0& MXP_synth==0, 1, 0))
  
  
  mat_entry <- round(cbind(
                CRP_CCP_MXP, CRP_CCP_RMXP, CRP_CCP_NMXP,
                CRP_RCCP_MXP, CRP_RCCP_RMXP, CRP_RCCP_NMXP,
                CRP_NCCP_MXP, CRP_NCCP_RMXP, CRP_NCCP_NMXP,
                RCRP_CCP_MXP, RCRP_CCP_RMXP, RCRP_CCP_NMXP,
                RCRP_RCCP_MXP, RCRP_RCCP_RMXP, RCRP_RCCP_NMXP,
                RCRP_NCCP_MXP, RCRP_NCCP_RMXP, RCRP_NCCP_NMXP,
                NCRP_CCP_MXP, NCRP_CCP_RMXP, NCRP_CCP_NMXP,
                NCRP_RCCP_MXP, NCRP_RCCP_RMXP, NCRP_RCCP_NMXP,
                NCRP_NCCP_MXP, NCRP_NCCP_RMXP, NCRP_NCCP_NMXP),3)
  
  return(mat_entry)
  
}


#### 8. simulate_rf_calc
simulate_rf_calc <- function(estimates) {
  #### Assign Values
  h_X <- (estimates)[1]
  h_Y <- (estimates)[2]
  h_Z <- (estimates)[3]
  gamma_X <- (estimates)[4]
  gamma_Y <- (estimates)[5]
  gamma_Z <- (estimates)[6]
  covXY <- (estimates)[10]
  covXZ <- (estimates)[11]
  covYZ <- (estimates)[12]
  
  #### Mean Preference Vector 
  m <- c(h_X, h_Y, h_Z) 
  #### Preference Component of Variance-Covariance Matrix 
  s <-  as.matrix(rbind(
    c(gamma_X^2, covXY, covXZ ),
    c(covXY , gamma_Y^2 , covYZ),
    c(covXZ , covYZ, gamma_Z^2)
  ))
  
  #### Construct Simulated Preference Dataset
  data_synth <- rmvnorm(100000, mean = m, sigma = s)
  h_AC_synth <- (ceiling(data_synth[,1]) + floor(data_synth[,1]) )/2
  h_AB_synth <- (ceiling(data_synth[,2]) + floor(data_synth[,2]) )/2
  h_DE_synth <- (ceiling(data_synth[,3]) + floor(data_synth[,3]) )/2
  #### CRP, CCP, MXP 
  CRP_synth <- ifelse(h_AC_synth>h_DE_synth, 1, ifelse(h_AC_synth==h_DE_synth, 0, -1))
  CCP_synth <- ifelse(h_AB_synth>h_DE_synth, 1, ifelse(h_AB_synth==h_DE_synth, 0, -1))
  MXP_synth <- ifelse(h_AC_synth>h_AB_synth, 1, ifelse(h_AC_synth==h_AB_synth, 0, -1))
  
  #### Cases 
  CRP_CCP_MXP <- mean(ifelse(CRP_synth==1 & CCP_synth==1& MXP_synth==1, 1, 0))
  CRP_CCP_RMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==1& MXP_synth==-1, 1, 0))
  CRP_CCP_NMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==1& MXP_synth==0, 1, 0))
  
  CRP_RCCP_MXP <- mean(ifelse(CRP_synth==1 & CCP_synth==-1& MXP_synth==1, 1, 0))
  CRP_RCCP_RMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==-1& MXP_synth==-1, 1, 0))
  CRP_RCCP_NMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==-1& MXP_synth==0, 1, 0))
  
  CRP_NCCP_MXP <- mean(ifelse(CRP_synth==1 & CCP_synth==0& MXP_synth==1, 1, 0))
  CRP_NCCP_RMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==0& MXP_synth==-1, 1, 0))
  CRP_NCCP_NMXP <- mean(ifelse(CRP_synth==1 & CCP_synth==0& MXP_synth==0, 1, 0))
  
  NCRP_CCP_MXP <- mean(ifelse(CRP_synth==0 & CCP_synth==1& MXP_synth==1, 1, 0))
  NCRP_CCP_RMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==1& MXP_synth==-1, 1, 0))
  NCRP_CCP_NMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==1& MXP_synth==0, 1, 0))
  
  NCRP_RCCP_MXP <- mean(ifelse(CRP_synth==0 & CCP_synth==-1& MXP_synth==1, 1, 0))
  NCRP_RCCP_RMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==-1& MXP_synth==-1, 1, 0))
  NCRP_RCCP_NMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==-1& MXP_synth==0, 1, 0))
  
  NCRP_NCCP_MXP <- mean(ifelse(CRP_synth==0 & CCP_synth==0& MXP_synth==1, 1, 0))
  NCRP_NCCP_RMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==0& MXP_synth==-1, 1, 0))
  NCRP_NCCP_NMXP <- mean(ifelse(CRP_synth==0 & CCP_synth==0& MXP_synth==0, 1, 0))
  
  RCRP_CCP_MXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==1& MXP_synth==1, 1, 0))
  RCRP_CCP_RMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==1& MXP_synth==-1, 1, 0))
  RCRP_CCP_NMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==1& MXP_synth==0, 1, 0))
  
  RCRP_RCCP_MXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==-1& MXP_synth==1, 1, 0))
  RCRP_RCCP_RMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==-1& MXP_synth==-1, 1, 0))
  RCRP_RCCP_NMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==-1& MXP_synth==0, 1, 0))
  
  RCRP_NCCP_MXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==0& MXP_synth==1, 1, 0))
  RCRP_NCCP_RMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==0& MXP_synth==-1, 1, 0))
  RCRP_NCCP_NMXP <- mean(ifelse(CRP_synth==-1 & CCP_synth==0& MXP_synth==0, 1, 0))
  
  
  mat_entry <- round(cbind(
    CRP_CCP_MXP, CRP_NCCP_MXP, CRP_RCCP_MXP,
    NCRP_CCP_MXP, NCRP_NCCP_MXP, NCRP_RCCP_MXP,
    RCRP_CCP_MXP, RCRP_NCCP_MXP, RCRP_RCCP_MXP,
    
    CRP_CCP_NMXP, CRP_NCCP_NMXP, CRP_RCCP_NMXP,
    NCRP_CCP_NMXP, NCRP_NCCP_NMXP, NCRP_RCCP_NMXP,
    RCRP_CCP_NMXP, RCRP_NCCP_NMXP, RCRP_RCCP_NMXP,
    
    CRP_CCP_RMXP, CRP_NCCP_RMXP, CRP_RCCP_RMXP,
    NCRP_CCP_RMXP, NCRP_NCCP_RMXP, NCRP_RCCP_RMXP,
    RCRP_CCP_RMXP, RCRP_NCCP_RMXP, RCRP_RCCP_RMXP),3)

  
  return(mat_entry)
  
}


#### 9. Expected Type Function
#### A function that takes in calculated preferences
#### and a subject's first stage responses and calculates 
#### an expected value of h_AC, h_AB, h_DE

expected_type_function <- function(estimates, h_AC, h_AB, h_DE, h_AC_repeat, h_AB_repeat, h_DE_repeat) {
  #### Assign Values
  h_X <- (estimates)[1]
  h_Y <- (estimates)[2]
  h_Z <- (estimates)[3]
  gamma_X <- (estimates)[4]
  gamma_Y <- (estimates)[5]
  gamma_Z <- (estimates)[6]
  kappa_X <- (estimates)[7]
  kappa_Y <- (estimates)[8]
  kappa_Z <- (estimates)[9]
  covXY <- (estimates)[10]
  covXZ <- (estimates)[11]
  covYZ <- (estimates)[12]

  #### Preference Component
  m1 <- c(h_X, h_Y, h_Z)
  s11 <- as.matrix(rbind(
    c(gamma_X^2, covXY, covXZ ),
    c(covXY , gamma_Y^2 , covYZ),
    c(covXZ , covYZ, gamma_Z^2)
  ))
  
  #### Data Component (absent repeats)
  m2 <- c(h_X, h_Y, h_Z, h_Z)
  s22 <- as.matrix(rbind(
    c(gamma_X^2 + kappa_X^2, covXY, covXZ, covXZ ),
    c(covXY , gamma_Y^2 +  kappa_Y^2, covYZ, covYZ ),
    c(covXZ , covYZ, gamma_Z^2+ kappa_Z^2, gamma_Z^2),
    c(covXZ , covYZ, gamma_Z^2, gamma_Z^2+ kappa_Z^2)
  ))
  
  #### Data Component (with repeats)
  m2_alt <- c(h_X, h_Y, h_Z, h_X, h_Y, h_Z) 
  s22_alt <-  as.matrix(rbind(
    c(gamma_X^2 + kappa_X^2, covXY, covXZ, gamma_X^2, covXY, covXZ  ),
    c(covXY , gamma_Y^2 + kappa_Y^2, covYZ,  covXY, gamma_Y^2, covYZ),
    c(covXZ , covYZ, gamma_Z^2 + kappa_Z^2,  covXZ, covYZ, gamma_Z^2),
    c(gamma_X^2, covXY, covXZ, gamma_X^2  + kappa_X^2, covXY, covXZ  ),
    c(covXY , gamma_Y^2, covYZ,  covXY, gamma_Y^2  + kappa_Y^2, covYZ),
    c(covXZ , covYZ, gamma_Z^2 ,  covXZ, covYZ, gamma_Z^2 + kappa_Z^2)
  ))
  
  #### Data/Preference Component
  s12 <- as.matrix(rbind(
    c(gamma_X^2, covXY, covXZ, covXZ ),
    c(covXY , gamma_Y^2, covYZ, covYZ ),
    c(covXZ , covYZ, gamma_Z^2, gamma_Z^2)
  ))

  #### Data/Preference Component with repeats
  s12_alt <- as.matrix(rbind(
    c(gamma_X^2, covXY, covXZ, gamma_X^2, covXY, covXZ ),
    c(covXY , gamma_Y^2, covYZ, covXY , gamma_Y^2, covYZ ),
    c(covXZ , covYZ, gamma_Z^2, covXZ , covYZ, gamma_Z^2)
  ))
  

  #### Establish Type Function
  
  type_function <- Vectorize(function(a, b, c, d) {
    t <- m1 + (s12 %*% solve(s22) %*% (c(a, b, c, d) - m2 ))
    return(t)
    
  })
  
  type_function_alt <- Vectorize(function(a, b, c, d, e, f) {
    t <- m1 + (s12_alt %*% solve(s22_alt) %*% (c(a, b, c, d,e,f) - m2_alt ))
    return(t)
    
  })
  
  type_function_combined  <- Vectorize(function(a, b, c, d, e, f) {
    if(!is.na(d)) { 
                     type_function_alt(a,b,c,d,e,f)
          }
          else{type_function(a,b,c,f) }                   
  })      
  
  type <- type_function_combined(h_AC, h_AB, h_DE, h_AC_repeat, h_AB_repeat, h_DE_repeat)
  #type <- type_function(h_AC, h_AB, h_DE, h_DE_repeat)
  
  return(type)
}
  











