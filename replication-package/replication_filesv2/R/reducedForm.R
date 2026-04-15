#### McGranaghan et al. (2026)
#### reducedForm.R
#### ------------------------
#### This file provides estimates of the mean preferences along with variances, covariances and noise
#### requiring `functions.R' as source. 
#### File has 2 main components.
####    1. Conducting Calculations of Decomposition Exercise
####    2. Conducting MLE Estimation of Decomposition Exercise


#### 1. Conducting Calculations
#### Set conditions
pvals <- c(30, 50, 80, 90)
rvals <- c(10, 20, 30, 50, 80)
#### Set output matrix
output_mat <- matrix(nrow = 20, ncol = 14)
colnames(output_mat) <- c("p", "r", "mean_CRP", "mean_CCP", "mean_MXP",
                          "var_CRP", "var_CCP", "var_MXP",
                          "var_CRE_hat", "var_CCE_hat", "var_MXE_hat",
                           "alpha_CRE", "alpha_CCE", "alpha_MXE")
output_mat_levels <- matrix(nrow = 20, ncol = 17)
colnames(output_mat_levels) <- c("p", "r", "mean_h_ac_star", "mean_h_ab_star", "mean_h_de_star",
                                 "theta2_ac", "theta2_ab", "theta2_de",
                                 "sigma2_ac", "sigma2_ab", "sigma2_de",
                                 "theta_acab", "theta_acde", "theta_abde",
                          "alpha_ac", "alpha_ab", "alpha_de")
sim_pattern_mat <- matrix(nrow = 21, ncol = 27)


#### Estimate within each condition
for(i in 1:4){
  for(j in 1:5) {
    #### Set Data Set
    dataset <- subset(dataset_master,  abs(p -(pvals[i]/100)) <= .01 & abs(r -(rvals[j]/100)) <= .01 & CRtest==1 )
    #### Calculate
    calculations <- calculate_rf(dataset)
    #### Assign Calculations
    assign(paste("calculations",pvals[i], rvals[j], sep =""), calculations)
    #### Interpret Calculations
    output_mat[(i-1)*5 + j,1:14] <- interpret_rf_calc(calculations,i,j)
    output_mat_levels[(i-1)*5 + j,1:17] <- interpret_rf_calc_levels(calculations,i,j)
    #### Simulate Data Patterns
    sim_pattern_mat[(i-1)*5 + j,1:27] <- simulate_rf_calc(calculations)*dim(dataset)[1]
    #### Set Expected Type
    expected_types <- expected_type_function(calculations, dataset$h_ac, dataset$h_ab, dataset$h_de, dataset$h_ac_repeat, dataset$h_ab_repeat, dataset$h_de_repeat)
    dataset_master$expected_h_ac[abs(dataset_master$p -(pvals[i]/100)) <= .01 & abs(dataset_master$r -(rvals[j]/100)) <= .01 & dataset_master$CRtest ==1] <- expected_types[1,]
    dataset_master$expected_h_ab[abs(dataset_master$p -(pvals[i]/100)) <= .01 & abs(dataset_master$r -(rvals[j]/100)) <= .01 & dataset_master$CRtest ==1] <- expected_types[2,]
    dataset_master$expected_h_de[abs(dataset_master$p -(pvals[i]/100)) <= .01 & abs(dataset_master$r -(rvals[j]/100)) <= .01 & dataset_master$CRtest ==1] <- expected_types[3,]
    #### Remove Calculations
    rm(calculations)
    print(c(i,j))
  }
}

### Fill in Expected Types
dataset_master <- dataset_master %>%
  group_by(responseid, p, r) %>%
  mutate(expected_h_ac_fill = mean(expected_h_ac, na.rm=TRUE), 
         expected_h_ab_fill = mean(expected_h_ab, na.rm=TRUE), 
         expected_h_de_fill = mean(expected_h_de, na.rm=TRUE),
         expected_CRP_fill = expected_h_ac_fill - expected_h_de_fill,
         expected_CCP_fill = expected_h_ab_fill - expected_h_de_fill,
         expected_MXP_fill = expected_h_ac_fill - expected_h_ab_fill,
         expected_ra_fill = ifelse(p*expected_h_ac_fill - p*30 >0,1,0),
         expected_CRP_sign_fill = ifelse(expected_CRP_fill >0,1,0),
         expected_P1_fill = ifelse(expected_CRP_fill <0 & expected_CCP_fill <0 & expected_MXP_fill > 0,1, 0),
         expected_P12_fill = ifelse(expected_CRP_fill ==0 & expected_CCP_fill <0 & expected_MXP_fill > 0,1, 0),
         expected_P2_fill = ifelse(expected_CRP_fill >0 & expected_CCP_fill <0 & expected_MXP_fill > 0,1, 0),
         expected_P23_fill = ifelse(expected_CRP_fill >0 & expected_CCP_fill ==0 & expected_MXP_fill > 0,1, 0),
         expected_P3_fill = ifelse(expected_CRP_fill >0 & expected_CCP_fill >0 & expected_MXP_fill > 0,1, 0),
         expected_P34_fill = ifelse(expected_CRP_fill >0 & expected_CCP_fill >0 & expected_MXP_fill == 0,1, 0),
         expected_P4_fill = ifelse(expected_CRP_fill >0 & expected_CCP_fill >0 & expected_MXP_fill < 0,1, 0)
         ) %>%
  ungroup() 


### Total Up Simulation and Calculations
output_mat <- rbind(output_mat, colMeans(output_mat, na.rm=TRUE))
output_mat_levels <- rbind(output_mat_levels, colMeans(output_mat_levels, na.rm=TRUE))
colnames(sim_pattern_mat) <- colnames(simulate_rf_calc(calculations3010))
sim_pattern_mat[21,] <- (colSums(sim_pattern_mat[1:20,])/dim(dataset_master)[1])*(dim(dataset_master)[1]/2)

#### Write Out Calculations 
agg_data_calc <- as.data.frame(output_mat)
agg_data_calc_levels <- as.data.frame(output_mat_levels)
write.csv(agg_data_calc,        file.path(output, "estimated_output_calc.csv"),        row.names = FALSE)
write.csv(agg_data_calc_levels, file.path(output, "estimated_output_calc_levels.csv"), row.names = FALSE)

#### 3. Conducting MLE Estimates
#### Set conditions
pvals <- c(30, 50, 80, 90)
rvals <- c(10, 20, 30, 50, 80)
#### Set output matrix
output_mat <- matrix(nrow = 20, ncol = 14)
colnames(output_mat) <- c("p", "r", "mean_CRP", "mean_CCP", "mean_MXP",
                          "var_CRP", "var_CCP", "var_MXP",
                          "var_CRE_hat", "var_CCE_hat", "var_MXE_hat",
                          "alpha_CRE", "alpha_CCE", "alpha_MXE")
output_mat_levels <- matrix(nrow = 20, ncol = 17)
colnames(output_mat_levels) <- c("p", "r", "mean_h_ac_star", "mean_h_ab_star", "mean_h_de_star",
                                 "theta2_ac", "theta2_ab", "theta2_de",
                                 "sigma2_ac", "sigma2_ab", "sigma2_de",
                                 "theta_acab", "theta_acde", "theta_abde",
                                 "alpha_ac", "alpha_ab", "alpha_de")

#### Estimate within each condition
for(i in 1:4){
  for(j in 1:5) {
    #### Set Data Set
    dataset <- subset(dataset_master,  abs(p -(pvals[i]/100)) <= .01 & abs(r -(rvals[j]/100)) <= .01 & CRtest==1  )
    #### Estimate
    estimates <- estimate_rf(dataset)
    #### Assign Estimates
    assign(paste("estimates",pvals[i], rvals[j], sep =""), estimates)
    #### Interpret Estimates
    output_mat[(i-1)*5 + j,1:14] <- interpret_rf(estimates,i,j)
    output_mat_levels[(i-1)*5 + j,1:17] <- interpret_rf_levels(estimates,i,j)
    #### Remove Estimates
    rm(estimates)
    print(c(i,j))
  }
}

#### Total Up Estimates
output_mat <- rbind(output_mat, colMeans(output_mat, na.rm=TRUE))
output_mat_levels <- rbind(output_mat_levels, colMeans(output_mat_levels, na.rm=TRUE))


#### Write Out MLE Estimates
agg_data_mle <- as.data.frame(output_mat)
agg_data_mle_levels <- as.data.frame(output_mat_levels)
write.csv(agg_data_mle,        file.path(output, "estimated_output_mle.csv"),        row.names = FALSE)
write.csv(agg_data_mle_levels, file.path(output, "estimated_output_mle_levels.csv"), row.names = FALSE)


#### Clean Up
remove(dataset, expected_types, output_mat, output_mat_levels, i, j)
remove(list=ls(pattern="calculations"))
remove(list=ls(pattern="estimates"))
