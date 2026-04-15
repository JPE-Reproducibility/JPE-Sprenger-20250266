## Appendix: Detailed PII Detection Results

*Generated on 2026-04-15 19:47:07*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Data Files

**/replication-package/replication_filesv2/README.txt**

- Variable: `- Published-Blat-CCE-data-2022-AEJMicro_csv`
  - Matched terms: lat
  - Sample values: as published., then saved to CSV.

**/replication-package/replication_filesv2/raw-data/demographics-anonymized.csv**

- Variable: `countryofresidence`
  - Matched terms: country
  - Sample values: Portugal, United States, United Kingdom
- Variable: `sex`
  - Matched terms: sex
  - Sample values: Male, Female

**/replication-package/replication_filesv2/raw-data/qualtrics-raw.csv**

- Variable: `blockpaid`
  - Matched terms: block, loc
  - Sample values: 1, 2, 3
- Variable: `personpaid`
  - Matched terms: son
  - Sample values: 4, 1, 3

### Code Files

**/replication-package/replication_filesv2/R/functions.R**

- Line 10: lat
  ```
  ####      3. calculate_rf: based on a given dataset produces calculations
  ```
- Line 58: lat
  ```
  #### Calculate Grand Likelihood
  ```
- Line 106: lat
  ```
  #### 3. calculate_rf
  ```
- Line 107: lat
  ```
  calculate_rf <- function(dataset) {
  ```
- Line 297: lat
  ```
  #### 7. simulate_rf
  ```
- Line 298: lat
  ```
  simulate_rf <- function(estimates) {
  ```
- Line 319: lat
  ```
  #### Construct Simulated Preference Dataset
  ```
- Line 384: lat
  ```
  #### 8. simulate_rf_calc
  ```
- Line 385: lat
  ```
  simulate_rf_calc <- function(estimates) {
  ```
- Line 406: lat
  ```
  #### Construct Simulated Preference Dataset
  ```
- Line 475: lat
  ```
  #### and a subject's first stage responses and calculates
  ```

**/replication-package/replication_filesv2/R/mainR.R**

- Line 9: lat
  ```
  ##### 2. Performing Calculation and ML Estimation
  ```
- Line 19: son
  ```
  dir <- "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"
  ```
- Line 32: name
  ```
  to_install <- setdiff(pkgs, rownames(installed.packages()))
  ```
- Line 45: name
  ```
  # The Stata cleaning now outputs paper-aligned valuation names:
  ```
- Line 47: name
  ```
  # The decomposition functions in mcgetal_functions.R expect the legacy names:
  ```
- Line 66: lat
  ```
  #### 2. Conduct Calculations of Decomposition Exercise and Construct Expected Preferences ----
  ```
- Line 88: minute, second
  ```
  "main.R finished.\nStart: %s\nEnd:   %s\nElapsed: %.2f seconds (%.2f minutes)\n",
  ```

**/replication-package/replication_filesv2/R/makeFigureD1.R**

- Line 6: lat
  ```
  #### Figure Relating MLE and Calculated Values
  ```

**/replication-package/replication_filesv2/R/makeTableD1.R**

- Line 11: lat
  ```
  agg_data_mle_levels, "latex",
  ```
- Line 13: name
  ```
  col.names = c("p", "r", "$\\hat{\\mu}_{AB}^*$", "$\\hat{\\mu}_{AB'}^*$", "$\\hat{\\mu}_{CD}^*$",
  ```
- Line 20: lat
  ```
  caption = "Decomposition Calculations (Levels)\\label{apptab:TableD1}"
  ```

**/replication-package/replication_filesv2/R/makeTableD2.R**

- Line 11: lat
  ```
  agg_data_mle, "latex",
  ```
- Line 13: name
  ```
  col.names = c("p", "r", "$\\hat{\\Delta}_{CR}^{**}$", "$\\hat{\\Delta}_{CC}^{**}$", "$\\hat{\\Delta}
  ```
- Line 19: lat
  ```
  caption = "Decomposition Calculations (Differences)\\label{apptab:TableD2}"
  ```

**/replication-package/replication_filesv2/R/reducedForm.R**

- Line 4: lon
  ```
  #### This file provides estimates of the mean preferences along with variances, covariances and nois
  ```
- Line 7: lat
  ```
  ####    1. Conducting Calculations of Decomposition Exercise
  ```
- Line 11: lat
  ```
  #### 1. Conducting Calculations
  ```
- Line 17: lname, name
  ```
  colnames(output_mat) <- c("p", "r", "mean_CRP", "mean_CCP", "mean_MXP",
  ```
- Line 22: lname, name
  ```
  colnames(output_mat_levels) <- c("p", "r", "mean_h_ac_star", "mean_h_ab_star", "mean_h_de_star",
  ```
- Line 35: lat
  ```
  #### Calculate
  ```
- Line 36: lat
  ```
  calculations <- calculate_rf(dataset)
  ```
- Line 37: lat
  ```
  #### Assign Calculations
  ```
- Line 38: lat
  ```
  assign(paste("calculations",pvals[i], rvals[j], sep =""), calculations)
  ```
- Line 39: lat
  ```
  #### Interpret Calculations
  ```
- Line 40: lat
  ```
  output_mat[(i-1)*5 + j,1:14] <- interpret_rf_calc(calculations,i,j)
  ```
- Line 41: lat
  ```
  output_mat_levels[(i-1)*5 + j,1:17] <- interpret_rf_calc_levels(calculations,i,j)
  ```
- Line 42: lat
  ```
  #### Simulate Data Patterns
  ```
- Line 43: lat
  ```
  sim_pattern_mat[(i-1)*5 + j,1:27] <- simulate_rf_calc(calculations)*dim(dataset)[1]
  ```
- Line 45: lat
  ```
  expected_types <- expected_type_function(calculations, dataset$h_ac, dataset$h_ab, dataset$h_de, dat
  ```
- Line 49: lat
  ```
  #### Remove Calculations
  ```
- Line 50: lat
  ```
  rm(calculations)
  ```
- Line 77: lat
  ```
  ### Total Up Simulation and Calculations
  ```
- Line 80: lat, lname, name
  ```
  colnames(sim_pattern_mat) <- colnames(simulate_rf_calc(calculations3010))
  ```
- Line 83: lat
  ```
  #### Write Out Calculations
  ```
- Line 86: name
  ```
  write.csv(agg_data_calc,        file.path(output, "estimated_output_calc.csv"),        row.names = F
  ```
- Line 87: name
  ```
  write.csv(agg_data_calc_levels, file.path(output, "estimated_output_calc_levels.csv"), row.names = F
  ```
- Line 95: lname, name
  ```
  colnames(output_mat) <- c("p", "r", "mean_CRP", "mean_CCP", "mean_MXP",
  ```
- Line 100: lname, name
  ```
  colnames(output_mat_levels) <- c("p", "r", "mean_h_ac_star", "mean_h_ab_star", "mean_h_de_star",
  ```
- Line 132: name
  ```
  write.csv(agg_data_mle,        file.path(output, "estimated_output_mle.csv"),        row.names = FAL
  ```
- Line 133: name
  ```
  write.csv(agg_data_mle_levels, file.path(output, "estimated_output_mle_levels.csv"), row.names = FAL
  ```
- Line 138: lat
  ```
  remove(list=ls(pattern="calculations"))
  ```

**/replication-package/replication_filesv2/matlab/makeFigure1.m**

- Line 7: son
  ```
  dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
  ```
- Line 20: lat
  ```
  set(groot,'defaultAxesTickLabelInterpreter','latex');
  ```
- Line 49: lat
  ```
  text(0.02,0+0.02,'$A$','Color','k','Fontsize', 15,'Interpreter','latex')
  ```
- Line 54: lat
  ```
  text((1-p)*r+0.02,r*p+0.02,'$B^\prime$','Color','k','Fontsize', 15,'Interpreter','latex')
  ```
- Line 59: lat
  ```
  text(1-p+0.02,p+0.02,'$B$','Color','k','Fontsize', 15,'Interpreter','latex')
  ```
- Line 64: lat
  ```
  text(1-r+0.02,0.02,'$C$','Color','k','Fontsize', 15,'Interpreter','latex')
  ```
- Line 69: lat
  ```
  text(1-r*p+0.02,r*p+0.02,'$D$','Color','k','Fontsize', 15,'Interpreter','latex')
  ```
- Line 74: lat
  ```
  xlabel('$q_L$','Interpreter','latex')
  ```
- Line 75: lat
  ```
  ylabel('$q_H$','Interpreter','latex')
  ```
- Line 109: lat
  ```
  set(groot,'defaultAxesTickLabelInterpreter','latex');
  ```
- Line 118: lat
  ```
  text(0.5,0.09,"$N$:",'Interpreter','latex','fontsize', 12)
  ```
- Line 119: lat
  ```
  text(0.785,0.09,"2,500",'Interpreter','latex','fontsize', 12)
  ```
- Line 120: lat
  ```
  text(0.655,0.09,"500",'Interpreter','latex','fontsize', 12)
  ```
- Line 121: lat
  ```
  text(0.55,0.09,"100",'Interpreter','latex','fontsize', 12)
  ```
- Line 128: lat
  ```
  xlabel('$r$','Interpreter','latex')
  ```
- Line 129: lat
  ```
  ylabel('$p$','Interpreter','latex')
  ```
- Line 130: lat, loc, location
  ```
  lgd=legend({'CR Study','CC Study'},'Location','southoutside','NumColumns',3,'FontSize',14,'Interpret
  ```

**/replication-package/replication_filesv2/matlab/makeFigure9.m**

- Line 7: son
  ```
  dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
  ```
- Line 18: name
  ```
  caseName = cases{z};  % 'I1', 'I2', 'I3', 'I4', or 'I5'
  ```
- Line 21: name
  ```
  switch caseName
  ```
- Line 33: name
  ```
  error('Unknown case name.')
  ```
- Line 37: name
  ```
  switch caseName
  ```
- Line 100: lat
  ```
  set(groot,'defaultAxesTickLabelInterpreter','latex');
  ```
- Line 134: lat
  ```
  'Color','k', 'FontSize',15, 'Interpreter','latex')
  ```
- Line 140: lat
  ```
  xlabel('$q_L$','Interpreter','latex')
  ```
- Line 141: lat
  ```
  ylabel('$q_H$','Interpreter','latex')
  ```
- Line 145: name
  ```
  % Export file named by case
  ```

**/replication-package/replication_filesv2/matlab/makeFigureE1.m**

- Line 7: son
  ```
  dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
  ```
- Line 44: lat
  ```
  text(12,130, '$\kappa(qX) < q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
  ```
- Line 45: lat
  ```
  text(12,120, '$ \Rightarrow \; \; \; C > qX$', 'Interpreter','latex', 'Color','k','fontsize', 14);
  ```
- Line 46: lat
  ```
  text(62,130, '$\kappa(qX) > q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
  ```
- Line 47: lat
  ```
  text(62,120, '$\Rightarrow \; \; C < qX$', 'Interpreter','latex', 'Color','k','fontsize', 14);
  ```
- Line 48: lat
  ```
  text(65,85, '$\kappa(qX)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
  ```
- Line 49: lat
  ```
  text(65,35, '$q^2\kappa(X)$', 'Interpreter','latex', 'Color','k','fontsize', 14);
  ```
- Line 53: lat
  ```
  set(gca, 'XTickLabel', {'0', '$\bar{q}$', '1'}, 'TickLabelInterpreter', 'latex');
  ```
- Line 54: lat
  ```
  xlabel('$q$', 'Interpreter','latex');
  ```
- Line 58: lat
  ```
  set(gca, 'YTickLabel', {'$\kappa(X)$'}, 'TickLabelInterpreter', 'latex');
  ```

**/replication-package/replication_filesv2/matlab/structuralEstimates.m**

- Line 7: son
  ```
  dir = "/Users/jasonsomerville/Desktop/CRP CCP BP/replication_files"; %Set directory
  ```
- Line 88: name
  ```
  UPspec(1).name     = "UP_flex2";
  ```
- Line 100: name
  ```
  UPspec(2).name     = "UP_flex1";
  ```
- Line 112: name
  ```
  UPspec(3).name     = "UP_form1";
  ```
- Line 124: name
  ```
  UPspec(4).name     = "UP_form2";
  ```
- Line 136: name
  ```
  UPspec(5).name     = "UP_form3";
  ```
- Line 290: lat
  ```
  set(groot,'defaultAxesTickLabelInterpreter','latex');
  ```
- Line 300: lat
  ```
  xlabel("Outcome z",'Interpreter','Latex'); xticks(0:5:50);
  ```
- Line 301: lat
  ```
  ylabel("$\kappa(z;\theta)$",'Interpreter','Latex');
  ```
- Line 304: lat
  ```
  text(35,40,['MSE: ',num2str(round(mse_levels,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 305: lat
  ```
  text(35,30,['$R^2$: ',num2str(round(r2_levels,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 306: lat
  ```
  text(35,20,['$\rho(h,\hat{h})$: ',num2str(round(rho_levels,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 307: lat
  ```
  text(35,10,['$\rho(\Delta,\hat{\Delta})$: ',num2str(round(rho_differences,2))],'FontSize',14,'Interp
  ```
- Line 325: block, loc
  ```
  % ----- model-specific settings for the shared 3-panel block -----
  ```
- Line 344: block, loc, name
  ```
  % unify stat names expected by the shared block
  ```
- Line 359: lat
  ```
  set(groot,'defaultAxesTickLabelInterpreter','latex');
  ```
- Line 372: lat
  ```
  title(fig_title_left,'Interpreter','Latex');
  ```
- Line 373: lat
  ```
  xlabel(left_xlabel,'Interpreter','Latex'); xticks(0:5:42);
  ```
- Line 374: lat
  ```
  ylabel(left_ylabel,'Interpreter','Latex');
  ```
- Line 378: lat
  ```
  text(32,22,['MSE: ',num2str(round(mse_levels_or_mse,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 379: lat
  ```
  text(33,12,['$R^2$: ',num2str(round(r2_levels_or_r2,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 392: lat
  ```
  xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
  ```
- Line 393: lat
  ```
  title("\textbf{In-Sample Fit - Levels}",'Interpreter','Latex');
  ```
- Line 394: lat
  ```
  text(37,23,['$\rho(h,\hat{h})$ = ',num2str(round(rho_levels,2))],'FontSize',14,'Interpreter','Latex'
  ```
- Line 396: lat, loc, location
  ```
  legend({'',"$h_{AB}$","$h_{AB'}$",'$h_{CD}$'},'Location','northwest','Interpreter','Latex');
  ```
- Line 407: lat
  ```
  xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
  ```
- Line 408: lat
  ```
  title("\textbf{In-Sample Fit - Differences}",'Interpreter','Latex');
  ```
- Line 409: lat
  ```
  text(10,-8,['$\rho(\Delta,\hat{\Delta})$ = ',num2str(round(rho_differences,2))],'FontSize',14,'Inter
  ```
- Line 412: lat, loc, location
  ```
  legend({'','$\Delta_{CR}$',"$\Delta_{CC}$",'$\Delta_{MX}$'},'Location','northwest','Interpreter','La
  ```
- Line 439: son
  ```
  error('Could not open %s for writing.\nReason: %s', texFile, errmsg);
  ```
- Line 477: degree
  ```
  % Degrees of Freedom
  ```
- Line 478: degree
  ```
  fprintf(fid,'Degrees of Freedom');
  ```
- Line 565: name
  ```
  models(1).name     = "CPT_TK92";
  ```
- Line 575: name
  ```
  models(2).name     = "CPT_LBW92";
  ```
- Line 585: name
  ```
  models(3).name     = "CPT_FLEX";
  ```
- Line 595: name
  ```
  models(4).name     = "OPT_TK92";
  ```
- Line 605: name
  ```
  models(5).name     = "OPT_LBW92";
  ```
- Line 615: name
  ```
  models(6).name     = "OPT_FLEX";
  ```
- Line 756: lat
  ```
  set(groot,'defaultAxesTickLabelInterpreter','latex');
  ```
- Line 775: lat
  ```
  title(models(m).title_txt,'Interpreter','Latex');
  ```
- Line 776: lat
  ```
  xlabel("Probability",'Interpreter','Latex'); xticks(0:0.1:1);
  ```
- Line 777: lat
  ```
  ylabel("Probability Weight",'Interpreter','Latex');
  ```
- Line 779: lat
  ```
  text(0.72,0.2,['MSE: ',num2str(round(mseH,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 780: lat
  ```
  text(0.75,0.13,['$R^2$: ',num2str(round(r2H,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 789: lat
  ```
  xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
  ```
- Line 790: lat
  ```
  title("\textbf{In-Sample Fit - Levels}",'Interpreter','Latex');
  ```
- Line 791: lat
  ```
  text(37,23,['$\rho(h,\hat{h})$ = ',num2str(round(rhoH,2))],'FontSize',14,'Interpreter','Latex')
  ```
- Line 793: lat, loc, location
  ```
  legend({'',"$h_{AB}$","$h_{AB'}$",'$h_{CD}$'},'Location','northwest','Interpreter','Latex');
  ```
- Line 802: lat
  ```
  xlabel("Predicted",'Interpreter','Latex'); ylabel("Actual",'Interpreter','Latex');
  ```
- Line 803: lat
  ```
  title("\textbf{In-Sample Fit - Differences}",'Interpreter','Latex');
  ```
- Line 804: lat
  ```
  text(10,-8,['$\rho(\Delta,\hat{\Delta})$ = ',num2str(round(rhoD,2))],'FontSize',14,'Interpreter','La
  ```
- Line 807: lat, loc, location
  ```
  legend({'','$\Delta_{CR}$',"$\Delta_{CC}$",'$\Delta_{MX}$'},'Location','northwest','Interpreter','La
  ```
- Line 836: son
  ```
  error('Could not open %s for writing.\nReason: %s', texFile, errmsg);
  ```
- Line 904: degree
  ```
  % Degrees of Freedom
  ```
- Line 905: degree
  ```
  fprintf(fid,'Degrees of Freedom');
  ```

**/replication-package/replication_filesv2/stata/clean_data.do**

- Line 23: block, loc, son
  ```
  replace bonuspayment=mplbonus if blockpaid==1 & personpaid==1
  ```
- Line 24: block, loc, son
  ```
  replace bonuspayment=binbonus if blockpaid==2 & personpaid==1
  ```
- Line 25: block, loc, son
  ```
  replace bonuspayment=quizbonus if blockpaid==3 & personpaid==1
  ```
- Line 27: lat
  ```
  * Comprehension Qs (save for later)
  ```
- Line 34: son
  ```
  keep responseid paidQ_correct attention_correct mpl_correct bin_correct both_correct r_1 r_2 r_3 r_4
  ```
- Line 40: lon
  ```
  ***** (B) Reshape data to be long
  ```
- Line 43: lon
  ```
  * Reshape long
  ```
- Line 59: name
  ```
  rename type_new type
  ```
- Line 90: name
  ```
  rename (rval pval hval) (r p H)
  ```
- Line 98: lat
  ```
  * Save for later
  ```
- Line 99: lon
  ```
  save "cleaned_data_long", replace
  ```
- Line 105: lon
  ```
  * Import the long format data
  ```
- Line 106: lon
  ```
  use "cleaned_data_long", clear
  ```
- Line 113: name
  ```
  * Rename variables (paper-aligned)
  ```
- Line 114: name
  ```
  rename (valuationAB valuationABrepeat trialAB trialABrepeat) ///
  ```
- Line 117: name
  ```
  rename (valuationABprime valuationABprimerepeat trialABprime trialABprimerepeat) ///
  ```
- Line 120: name
  ```
  rename (valuationCD valuationCDrepeat trialCD trialCDrepeat) ///
  ```
- Line 181: name
  ```
  tempname fh
  ```
- Line 187: loc
  ```
  local def : variable label `v'
  ```
- Line 188: loc
  ```
  if `"`def'"' == "" local def "(no definition provided)"
  ```
- Line 189: loc
  ```
  local def = subinstr(`"`def'"', `"""', `"""""', .)
  ```
- Line 203: lon
  ```
  use "cleaned_data_long", clear
  ```
- Line 211: name
  ```
  * Clean up and rename
  ```
- Line 212: name
  ```
  rename (type1 type2 binary_choice1 binary_choice2) (decision1 decision2 choice1 choice2)
  ```
- Line 286: second
  ```
  capture label var decision2   "Second stage-2 decision shown (AB, ABprime, or CD)."
  ```
- Line 322: name
  ```
  tempname fh
  ```
- Line 328: loc
  ```
  local def : variable label `v'
  ```
- Line 329: loc
  ```
  if `"`def'"' == "" local def "(no definition provided)"
  ```
- Line 330: loc
  ```
  local def = subinstr(`"`def'"', `"""', `"""""', .)
  ```
- Line 361: lat
  ```
  label var totalapprovals "Total number of approved Prolific submissions (platform metadata)."
  ```
- Line 362: lat
  ```
  label var totalrejections "Total number of rejected Prolific submissions (platform metadata)."
  ```
- Line 365: school
  ```
  label var highesteducationlevelcompleted "Highest education level completed; at least high school."
  ```
- Line 367: gender, sex
  ```
  label var sex "Sex/gender category; gender-balanced recruitment."
  ```
- Line 368: country, lat
  ```
  label var countryofresidence "Current residence; eligibility US or Western Europe (platform metadata
  ```
- Line 369: lat
  ```
  label var language "Primary language / language of participation (platform metadata)."
  ```
- Line 370: lat
  ```
  label var studentstatus "Student status (platform metadata)."
  ```
- Line 371: lat
  ```
  label var employmentstatus "Employment status (platform metadata)."
  ```
- Line 372: son
  ```
  label var personpaid "Indicator selected for performance-based bonus (1 in 5 selected)."
  ```
- Line 385: name
  ```
  tempname fh
  ```
- Line 391: loc
  ```
  local def : variable label `v'
  ```
- Line 393: loc
  ```
  local def = subinstr(`"`def'"', `"""', `"""""', .)
  ```
- Line 421: name
  ```
  rename real1orhypothetical0incentives real
  ```
- Line 438: name
  ```
  * Rename and save
  ```
- Line 439: name
  ```
  rename (CR RCR) (effect reverse_effect)
  ```
- Line 441: lat
  ```
  save Blat_CRE_data.dta, replace
  ```
- Line 468: name
  ```
  * Rename and save
  ```
- Line 469: name
  ```
  rename (CC RCC) (effect reverse_effect)
  ```
- Line 471: lat
  ```
  save Blat_CCE_data, replace
  ```
- Line 484: name
  ```
  rename (p_condition r_condition) (p r)
  ```
- Line 526: name
  ```
  tempname fh
  ```
- Line 532: loc
  ```
  local def : variable label `v'
  ```
- Line 533: loc
  ```
  if `"`def'"' == "" local def "(no definition provided)"
  ```
- Line 535: loc
  ```
  local def = subinstr(`"`def'"', `"""', `"""""', .)
  ```
- Line 547: lat
  ```
  mi erase Blat_CRE_data
  ```
- Line 548: lat
  ```
  mi erase Blat_CCE_data
  ```

**/replication-package/replication_filesv2/stata/mainS.do**

- Line 7: second
  ```
  Run time: 20 seconds
  ```
- Line 11: loc
  ```
  local folder "Desktop/CRP CCP BP/replication_files" // update based on local directory (e.g. Desktop
  ```
- Line 12: name
  ```
  global user  "`c(username)'"
  ```
- Line 85: lon
  ```
  mi erase cleaned_data_long
  ```
- Line 89: loc, second
  ```
  display (clock(t2, "hms") - clock(t1, "hms")) / 1000 " second(s)"
  ```

**/replication-package/replication_filesv2/stata/makeAppendixFigures.do**

- Line 53: loc
  ```
  local l`j' = `r(N)'*0.`j'
  ```
- Line 64: lat
  ```
  * Save data for later
  ```
- Line 106: loc
  ```
  local l`j' = `r(N)'*0.`j'
  ```
- Line 155: loc
  ```
  local l`j' = `r(N)'*0.`j'
  ```
- Line 166: lat
  ```
  * Save for later
  ```
- Line 194: loc
  ```
  local emdash = ustrunescape("\u2013")
  ```
- Line 242: loc
  ```
  local emdash = ustrunescape("\u2013")
  ```
- Line 243: loc
  ```
  local overline = uchar(773)
  ```
- Line 245: loc
  ```
  local k=0
  ```
- Line 246: loc
  ```
  local colors "cranberry ebblue purple"
  ```
- Line 247: loc
  ```
  local labels1 "h`overline'{sub:CR} h`overline'{sub:CC} h`overline'{sub:MX}"
  ```
- Line 248: loc
  ```
  local labels2 "h`overline'*{sub:CR} h`overline'*{sub:CC} h`overline'*{sub:MX}"
  ```
- Line 249: loc
  ```
  local top_label "a b c"
  ```
- Line 250: loc
  ```
  local bottom_label "d e f"
  ```
- Line 252: loc
  ```
  local k = `k'+1
  ```
- Line 253: loc
  ```
  local color : word `k' of `colors'
  ```
- Line 254: loc
  ```
  local newlabel1 : word `k' of `labels1'
  ```
- Line 255: loc
  ```
  local newlabel2 : word `k' of `labels2'
  ```
- Line 256: loc
  ```
  local top :    word `k' of `top_label'
  ```
- Line 257: loc
  ```
  local bottom : word `k' of `bottom_label'
  ```

**/replication-package/replication_filesv2/stata/makeAppendixTables.do**

- Line 10: lat
  ```
  C) Table A.3: Correlations Between h_XY and h_ XY by p and r
  ```
- Line 27: sex
  ```
  gen female=sex=="Female"
  ```
- Line 29: degree
  ```
  gen college_degree=inlist(highesteducationlevelcompleted,"Graduate degree (MA/MSc/MPhil/other)","Und
  ```
- Line 32: country
  ```
  gen res_US=countryofresidence=="United States"
  ```
- Line 33: country
  ```
  gen res_UK=countryofresidence=="United Kingdom"
  ```
- Line 34: country
  ```
  gen res_PR=countryofresidence=="Portugal"
  ```
- Line 35: country
  ```
  gen res_ES=countryofresidence=="Spain"
  ```
- Line 36: country
  ```
  gen res_DE=countryofresidence=="Germany"
  ```
- Line 40: degree, loc
  ```
  local case_demographics "female student college_degree working english_first paidQ_correct attention
  ```
- Line 62: lname, name
  ```
  mat colnames D= "Full Sample"  "Any $ r = 0.1$"  "Any $ r = 0.2$" "Any $ r = 0.3$" "Any $ r = 0.5$" 
  ```
- Line 63: degree, minute, name
  ```
  mat rownames D =  "Number of Participants" "Time Taken (in minutes)" "Age" "Prolific Score" "Number 
  ```
- Line 79: loc
  ```
  local mean_`t' = `r(mean)'
  ```
- Line 80: loc
  ```
  local N`t' = `r(N)'
  ```
- Line 86: lname, name
  ```
  mat colnames A`r' =  "$ h_{AB}$" "$ h_{AB^\prime}$"  "$ h_{CD}$" "$ h_{CD}^\prime$" "N" "h_{AB}"  "h
  ```
- Line 87: name
  ```
  mat rownames A`r' =  "$ p = 0.3$" "$ p = 0.5$" "$ p = 0.8$" "$ p = 0.9$"
  ```
- Line 104: name
  ```
  matrix  rownames rho_`t' = "$ p = 0.3$" "$ p = 0.5$" "$ p = 0.8$" "$ p = 0.9$"
  ```
- Line 122: loc
  ```
  local mu_diff =   `r(mu_1)'
  ```
- Line 124: loc
  ```
  local mean_p_value = -999
  ```
- Line 127: loc
  ```
  local mean_p_value = -111
  ```
- Line 133: loc
  ```
  local sign_p_value = -888
  ```
- Line 137: loc
  ```
  local sign_p_value = -777
  ```
- Line 140: loc
  ```
  local sign_p_value = -111
  ```
- Line 147: name
  ```
  mat rownames Z`t'= "$ r = 0.1$" "$ r = 0.2$" "$ r = 0.3$" "$ r = 0.5$" "$ r = 0.8$"
  ```
- Line 161: loc
  ```
  local k=0
  ```
- Line 163: loc
  ```
  local k =`k' + 1
  ```
- Line 167: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp`k'
  ```
- Line 168: loc
  ```
  estadd local space " ": temp`k'
  ```
- Line 188: loc
  ```
  local med_diff = `r(p50)'
  ```
- Line 190: loc
  ```
  local mu_diff =   `r(mu_1)'
  ```
- Line 191: loc
  ```
  local mu_diff_p = `r(p)'
  ```
- Line 199: name
  ```
  mat rownames C`t'= "0.3" "0.3" "0.3" "0.3" "0.3" "0.5" "0.5" "0.5" "0.5" "0.5" "0.8" "0.8" "0.8" "0.
  ```
- Line 216: name
  ```
  rename (h_ab h_abprime h_cd h_ab_repeat h_abprime_repeat h_cd_repeat) ///
  ```
- Line 218: lon
  ```
  reshape long h_ab h_abprime h_cd, i(id r_condition p_condition) j(repeat)
  ```
- Line 226: loc
  ```
  local cov_ab_abprime = `r(cov_12)'
  ```
- Line 229: loc
  ```
  local cov_ab_cd = `r(cov_12)'
  ```
- Line 232: loc
  ```
  local cov_abprime_cd = `r(cov_12)'
  ```
- Line 244: loc
  ```
  local k = 0
  ```
- Line 248: loc
  ```
  local k = `k' + 1
  ```
- Line 250: lat
  ```
  * Calculate covariance for h_ab
  ```
- Line 252: loc
  ```
  local gamma_ab = `r(cov_12)'
  ```
- Line 253: loc
  ```
  local sigma_ab = V[`k',1] - `r(cov_12)'
  ```
- Line 255: lat
  ```
  * Calculate covariance for h_abprime
  ```
- Line 257: loc
  ```
  local gamma_abprime = `r(cov_12)'
  ```
- Line 258: loc
  ```
  local sigma_abprime = V[`k',2] - `r(cov_12)'
  ```
- Line 260: lat
  ```
  * Calculate covariance for h_cd
  ```
- Line 262: loc
  ```
  local gamma_cd = `r(cov_12)'
  ```
- Line 263: loc
  ```
  local sigma_cd = V[`k',3] - `r(cov_12)'
  ```
- Line 265: lat
  ```
  * Calculate fraction attributable to preference
  ```
- Line 266: loc
  ```
  local frac_ab      = round(`gamma_ab'/(`gamma_ab' + `sigma_ab'), 0.01)
  ```
- Line 267: loc
  ```
  local frac_abprime = round(`gamma_abprime'/(`gamma_abprime' + `sigma_abprime'), 0.01)
  ```
- Line 268: loc
  ```
  local frac_cd      = round(`gamma_cd'/(`gamma_cd' + `sigma_cd'), 0.01)
  ```
- Line 283: loc
  ```
  local mean_p = round((0.3+0.5+0.8+0.9)/4,0.01)
  ```
- Line 284: name
  ```
  mat rownames D = "0.30" "0.30" "0.30" "0.30" "0.30" "0.50" "0.50" "0.50" "0.50" "0.50" "0.80" "0.80"
  ```
- Line 293: loc
  ```
  local k = 0
  ```
- Line 297: loc
  ```
  local k = `k' + 1
  ```
- Line 300: loc
  ```
  local mean_CR = M[`k',1] - M[`k',3]
  ```
- Line 301: loc
  ```
  local mean_CC = M[`k',2] - M[`k',3]
  ```
- Line 302: loc
  ```
  local mean_MX = M[`k',1] - M[`k',2]
  ```
- Line 305: loc
  ```
  local var_CR = sqrt(G[`k',1] + G[`k',3] - 2*C[`k',2])^2
  ```
- Line 306: loc
  ```
  local var_CC = sqrt(G[`k',2] + G[`k',3] - 2*C[`k',3])^2
  ```
- Line 307: loc
  ```
  local var_MX = sqrt(G[`k',1] + G[`k',2] - 2*C[`k',1])^2
  ```
- Line 310: loc
  ```
  local var_CR_hat = G[`k',1] + S[`k',1] + G[`k',3] + S[`k',3] - 2*C[`k',2]
  ```
- Line 311: loc
  ```
  local var_CC_hat = G[`k',2] + S[`k',2] + G[`k',3] + S[`k',3] - 2*C[`k',3]
  ```
- Line 312: loc
  ```
  local var_MX_hat = G[`k',1] + S[`k',1] + G[`k',2] + S[`k',2] - 2*C[`k',1]
  ```
- Line 315: loc
  ```
  local share_CR = `var_CR'/`var_CR_hat'
  ```
- Line 316: loc
  ```
  local share_CC = `var_CC'/`var_CC_hat'
  ```
- Line 317: loc
  ```
  local share_MX = `var_MX'/`var_MX_hat'
  ```
- Line 327: loc
  ```
  local sum = 0
  ```
- Line 328: loc
  ```
  local count = 0
  ```
- Line 331: loc
  ```
  local sum = `sum' + P[`j', `i']
  ```
- Line 332: loc
  ```
  local count = `count' + 1
  ```
- Line 335: lat
  ```
  * Calculate the mean
  ```
- Line 341: loc
  ```
  local mean_p = round((0.3+0.5+0.8+0.9)/4,0.01)
  ```
- Line 342: name
  ```
  mat rownames P = "0.30" "0.30" "0.30" "0.30" "0.30" "0.50" "0.50" "0.50" "0.50" "0.50" "0.80" "0.80"
  ```
- Line 345: lat
  ```
  * Save as Stata file for later
  ```
- Line 350: name
  ```
  rename (Ps*) (p r Delta_CR Delta_CC Delta_MX Delta_CR_var Delta_CC_var Delta_MX_var Delta_CR_hat_var
  ```
- Line 352: lat
  ```
  * Save Decomposition for later
  ```
- Line 355: lat
  ```
  **** Compute Posterier preferences given observed averages (will need these later)
  ```
- Line 361: loc
  ```
  local k = 0
  ```
- Line 366: loc
  ```
  local k = `k' + 1
  ```
- Line 380: loc
  ```
  local N = _N
  ```
- Line 426: lat
  ```
  * Save for later
  ```
- Line 430: name
  ```
  rename (Post*) (id p_condition r_condition h_ab_posterior h_abprime_posterior h_cd_posterior)
  ```
- Line 448: loc
  ```
  local k =`k' + 1
  ```
- Line 452: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp`k'
  ```
- Line 453: loc
  ```
  estadd local space " ": temp`k'
  ```
- Line 455: loc
  ```
  estadd local exp=round(`r(unique)',0.01): temp`k'
  ```
- Line 484: name
  ```
  rename (gap allais_values) (gap1 gap)   // rename so that esttab produces single rows
  ```
- Line 499: name
  ```
  rename (gap KT_values) (gap1 gap)
  ```
- Line 573: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp1
  ```
- Line 574: loc
  ```
  estadd local ind=`e(N)'/4: temp1
  ```
- Line 575: loc
  ```
  estadd local space " ": temp1
  ```
- Line 579: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp2
  ```
- Line 580: loc
  ```
  estadd local ind=`e(N)'/4: temp2
  ```
- Line 581: loc
  ```
  estadd local space " ": temp2
  ```
- Line 585: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp3
  ```
- Line 586: loc
  ```
  estadd local ind=`e(N)'/4: temp3
  ```
- Line 587: loc
  ```
  estadd local space " ": temp3
  ```
- Line 590: name
  ```
  rename (scaled_value_`t'_star scaled_dist_`t'_star) (scaled_value_`t' scaled_dist_`t')
  ```
- Line 593: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp4
  ```
- Line 594: loc
  ```
  estadd local ind=`e(N)'/4: temp4
  ```
- Line 595: loc
  ```
  estadd local space " ": temp4
  ```

**/replication-package/replication_filesv2/stata/makeFigures3-7.do**

- Line 24: loc
  ```
  local k=0
  ```
- Line 25: loc
  ```
  local colors "cranberry ebblue purple"
  ```
- Line 26: loc
  ```
  local panels "a b c"
  ```
- Line 28: loc
  ```
  local k = `k'+1
  ```
- Line 29: loc
  ```
  local color : word `k' of `colors'
  ```
- Line 30: loc
  ```
  local p : word `k' of `panels'
  ```
- Line 50: loc
  ```
  local emdash = ustrunescape("\u2013")
  ```
- Line 51: loc
  ```
  local k=0
  ```
- Line 52: loc
  ```
  local colors "cranberry ebblue purple"
  ```
- Line 53: loc
  ```
  local panels "a b c"
  ```
- Line 55: loc
  ```
  local k = `k'+1
  ```
- Line 56: loc
  ```
  local color : word `k' of `colors'
  ```
- Line 57: loc
  ```
  local p : word `k' of `panels'
  ```
- Line 96: loc
  ```
  local N = `r(N)'
  ```
- Line 111: loc
  ```
  local T23 = r(N)/`N'*100
  ```
- Line 115: loc
  ```
  local T12 = r(N)/`N'*100
  ```
- Line 119: loc
  ```
  local T34 = r(N)/`N'*100
  ```
- Line 121: lat
  ```
  * Save sample size for later
  ```
- Line 123: loc
  ```
  local N = `r(N)'
  ```
- Line 125: lat
  ```
  * Save types for later
  ```
- Line 130: loc
  ```
  local l`j' = `N'*0.`j'
  ```
- Line 155: lat
  ```
  *** Add simulated preference types
  ```
- Line 161: lat
  ```
  * Simulate data based on preferences
  ```
- Line 173: lat
  ```
  * Calculate simulated preference differences consistent with new notation
  ```
- Line 180: lon
  ```
  * Reshape the data long
  ```
- Line 181: lon
  ```
  reshape long h_ab_sim h_abprime_sim h_cd_sim Delta_CR_sim Delta_CC_sim Delta_MX_sim, i(n) j(sim_num)
  ```
- Line 184: loc
  ```
  local z = 0
  ```
- Line 189: loc
  ```
  local z = `z' + 1
  ```
- Line 194: loc
  ```
  local z = `z' + 1
  ```
- Line 197: loc
  ```
  local z = `z' + 1
  ```
- Line 200: lat
  ```
  * Save data for later
  ```
- Line 203: lat
  ```
  * Calculate shares
  ```
- Line 207: lon
  ```
  reshape long pattern, i(id) j(t)
  ```
- Line 208: name
  ```
  rename (t pattern) (pattern share)
  ```
- Line 246: loc
  ```
  local emdash = ustrunescape("\u2013")
  ```
- Line 248: loc
  ```
  local k=0
  ```
- Line 249: loc
  ```
  local colors "cranberry ebblue purple"
  ```
- Line 250: loc
  ```
  local top_label "a b c"
  ```
- Line 251: loc
  ```
  local bottom_label "d e f"
  ```
- Line 253: loc
  ```
  local k = `k'+1
  ```
- Line 254: loc
  ```
  local color :  word `k' of `colors'
  ```
- Line 255: loc
  ```
  local top :    word `k' of `top_label'
  ```
- Line 256: loc
  ```
  local bottom : word `k' of `bottom_label'
  ```

**/replication-package/replication_filesv2/stata/makeTable2.do**

- Line 22: lat
  ```
  * Relative Stakes and CCE dummy
  ```
- Line 35: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp1
  ```
- Line 36: loc
  ```
  estadd local sample "\cite{blavatskyy2023common}": temp1
  ```
- Line 37: loc
  ```
  estadd local space " ": temp1
  ```
- Line 41: loc
  ```
  estadd local mean=round(`r(mean)',0.01): temp2
  ```
- Line 42: loc
  ```
  estadd local sample "\cite{blavatskyy2022experimental}": temp2
  ```
- Line 43: loc
  ```
  estadd local space " ": temp2
  ```
- Line 67: name
  ```
  rename (gap KT_values) (gap1 gap)
  ```
- Line 85: name
  ```
  rename (gap allais_values) (gap1 gap)   // rename so that esttab produces single rows
  ```

**/replication-package/replication_filesv2/stata/statsInText.do**

- Line 44: son
  ```
  su bonuspayment if personpaid==1
  ```
- Line 96: lon
  ```
  use "cleaned_data_long", clear
  ```
- Line 123: loc
  ```
  local N = r(N)
  ```
- Line 133: lat
  ```
  1) "Four most prominent strict patterns ... account for approximately 73 percent of simulated prefer
  ```
- Line 135: lat
  ```
  3) "The three most prominent weak patterns ... 8 percent of simulated preferences"
  ```
- Line 137: lat
  ```
  5) "Together, the seven marked patterns account for 81 percent of simulated preferences"
  ```
- Line 141: lat
  ```
  * 1) Four strict patterns: simulated (posterior)
  ```
- Line 152: lat
  ```
  * 3) Three weak patterns: simulated (posterior)
  ```
- Line 163: lat
  ```
  * 5) Seven marked patterns: simulated (posterior)
  ```
- Line 182: lat
  ```
  * 1) Seven UP patterns: simulated (posterior)
  ```
- Line 187: lat
  ```
  * 2) Other six possible patterns: simulated (posterior)
  ```
- Line 207: lat
  ```
  5) "Risk aversion significantly correlated with CR preferences ... Fisher p<0.001"
  ```
- Line 216: lat
  ```
  * Risk attitude based on AB posterior valuation relative to M=30
  ```

