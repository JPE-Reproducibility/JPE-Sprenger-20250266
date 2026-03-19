/*********************************************************
 Purpose: Makes Appendix Tables		
 Last edited: 01/18/2026 		                                              
***********************************************************/

/**********************************************************
Table list:
	A) Table A.1: Participant Demographics
	B) Table A.2: Mean Valuations by p and r
	C) Table A.3: Correlations Between h_XY and h_ XY by p and r
	D) Table A.4: Mean ΔCR, ΔCC, and ΔMX by p and r
	E) Table A.5: Predicting the Prevalence of CR, CC, and MX by p and r
	F) Table A.6: Means and Sign Tests
	G) Table A.7: Decomposition Estimates Using Sample Variances and Covariances
	H) Table A.8: Preference-Noise Decomposition Using Estimates from Appendix Table A.7
	I) Table A.9: Sensitivity of Results to Experimental Parameters in our Stage 2 Experiments
	J) Table C.1: Regressions Predicting Stage 2 Binary Choices Using Stage 1 Valuations
***********************************************************/

********************************************
******* (A) Appendix Table A.1
********************************************

	use "$cdata/demographics.dta", clear

	* Generate new vars
	gen female=sex=="Female"
	gen student=studentstatus=="Yes"
	gen college_degree=inlist(highesteducationlevelcompleted,"Graduate degree (MA/MSc/MPhil/other)","Undergraduate degree (BA/BSc/other)","Doctorate degree (PhD/other)")
	gen working=inlist(employmentstatus,"Full-Time","Part-Time")
	gen english_first = language=="English"
	gen res_US=countryofresidence=="United States"
	gen res_UK=countryofresidence=="United Kingdom"
	gen res_PR=countryofresidence=="Portugal"
	gen res_ES=countryofresidence=="Spain"
	gen res_DE=countryofresidence=="Germany"

	* Put on the correct scale
	replace  timetaken=timetaken/60
	local case_demographics "female student college_degree working english_first paidQ_correct attention_correct mpl_correct bin_correct both_correct res_US res_UK res_PR res_ES res_DE" 
	foreach v in `case_demographics' {
			replace `v'=`v'*100
	}

	* Scale r
	forvalues j = 1/4 {
		replace r_`j' = round(r_`j'*100)
	}

	* Summarize demographics by group
	estpost su timetaken age approvalrate totalapprovals `case_demographics'
	matrix D=e(N), e(mean) 

	* By ever r
	foreach j in 10 20 30 50 80 {
		estpost su timetaken age approvalrate totalapprovals `case_demographics' if r_1 == `j' | r_2 == `j' | r_3 == `j' | r_4 == `j' 
		matrix D`j'= e(N), e(mean)
	}

	* Save as table
	matrix D = (D \ D10 \ D20 \ D30 \ D50 \ D80)'
	mat colnames D= "Full Sample"  "Any $ r = 0.1$"  "Any $ r = 0.2$" "Any $ r = 0.3$" "Any $ r = 0.5$" "Any $ r = 0.8$"
	mat rownames D =  "Number of Participants" "Time Taken (in minutes)" "Age" "Prolific Score" "Number of Approvals" "Female" "Current Student" "College Degree" "Working (full- or part-time)" "English First Language" "Incentive Question Correct" "Passed Attention Check" "MPL Question Correct" "Bin Question Correct" "Both Questions Correct"  "\hspace{12pt}United States" "\hspace{12pt}United Kingdom" "\hspace{12pt}Portugal" "\hspace{12pt}Spain" "\hspace{12pt}Germany"
	esttab matrix(D, fmt(1 1 1 1 1 1)) using "$tables/TableA1.tex", fragment replace tex substitute("\hspace{12pt}United States" " \textit{Current Residency} & & & & \\ \hspace{12pt}United States" "Incentive Question Correct" " \textit{Attention Checks} & & & & \\ \hspace{12pt}Incentive Question Correct" "MPL Question Correct" " \textit{Comprehension Questions} & & & & \\ \hspace{12pt}MPL Question Correct" "Passed Attention Check" "\hspace{12pt}Passed Attention Check" "Bin Question Correct" "\hspace{12pt}Bin Question Correct" "Both Questions Correct" "\hspace{12pt}Both Questions Correct" ".0&" " &" ".0\\" "\\") nomtitles


	
********************************************
******* (B) Appendix Table A.2
********************************************
    
	matrix drop _all
	use "$cdata/part1_cleaned", replace // import stage 1 data
	foreach r in 10 20 30 50 80 {
		foreach p in 30 50 80 90 {
			* Compute stats
			foreach t in h_ab h_abprime h_cd  h_ab_repeat h_abprime_repeat h_cd_repeat {
				qui su `t' if r_condition==`r' & p_condition==`p'
				local mean_`t' = `r(mean)'
				local N`t' = `r(N)'
				}
			* Save for a given r
			matrix A`r' = nullmat(A`r') \ (`mean_h_ab', `mean_h_abprime', `mean_h_cd' , `mean_h_cd_repeat', `Nh_cd_repeat', `mean_h_ab_repeat', `mean_h_abprime_repeat', `Nh_ab_repeat')
		}
		* Export table
		mat colnames A`r' =  "$ h_{AB}$" "$ h_{AB^\prime}$"  "$ h_{CD}$" "$ h_{CD}^\prime$" "N" "h_{AB}"  "h^\prime_{AB^\prime}" "N"
		mat rownames A`r' =  "$ p = 0.3$" "$ p = 0.5$" "$ p = 0.8$" "$ p = 0.9$"
		esttab matrix(A`r', fmt(2 2 2 2 0 2 2 0)) using "$tables/TableA2_r`r'", fragment replace tex  nomtitles collabels(none) substitute(\hline " ") 
	}
	
********************************************
******* (C) Appendix Table A.3
********************************************

	use "$cdata/part1_cleaned", replace 
	foreach t in ab abprime cd {
		foreach p in 30 50 80 90 {
			foreach r in 10 20 30 50 80 {
				corr h_`t' h_`t'_repeat if r_condition==`r' & p_condition==`p'
					matrix rho_`t'`p' =   nullmat(rho_`t'`p'), `r(rho)'
			}
		}
		matrix rho_`t' = (rho_`t'30 \ rho_`t'50 \ rho_`t'80 \ rho_`t'90)
		matrix  rownames rho_`t' = "$ p = 0.3$" "$ p = 0.5$" "$ p = 0.8$" "$ p = 0.9$"
		esttab matrix(rho_`t', fmt(3 3 3 3 3)) using "$tables/TableA3_`t'", fragment replace tex substitute(\hline " ") nomtitle collabels(none)
	}
		
		
		

********************************************
******* (D) Appendix Table A.4
********************************************
		
	use "$cdata/part1_cleaned", replace
	foreach t in CRP CCP  CRP_CCP MXP {
		foreach r in 10 20 30 50 80 {
			foreach p in 30 50 80 90 {
				
				* Means test
				ttest Delta_`t' == 0 if r_condition==`r' & p_condition==`p'
				local mu_diff =   `r(mu_1)'
				if (`r(p)' < 0.05){
					local mean_p_value = -999
				}
				else {
					local mean_p_value = -111
				}
		
				* Sign test 
				signtest Delta_`t' = 0 if r_condition==`r' & p_condition==`p'
				if (`r(p)' < 0.05 &  ((`r(p_u)'< 0.025 & `mu_diff'>0) | (`r(p_l)'< 0.025 & `mu_diff'<0))){
					local sign_p_value = -888
				}
				* Sign doesn't align with direction of sign test
				else if (`r(p)' < 0.05 & ((`r(p_u)'< 0.025 & `mu_diff'<0) | (`r(p_l)'< 0.025 & `mu_diff'>0))){
					local sign_p_value = -777
				}	
				else {
					local sign_p_value = -111
				}
				matrix Z`r'`t' =   nullmat(Z`r'`t'), `mu_diff', `mean_p_value' , `sign_p_value'
			}
			matrix Z`t' =   nullmat(Z`t') \ Z`r'`t'
		}
		* save table 
		mat rownames Z`t'= "$ r = 0.1$" "$ r = 0.2$" "$ r = 0.3$" "$ r = 0.5$" "$ r = 0.8$" 
		esttab matrix(Z`t', fmt(2 0 0 2 0 0 2 0 0 2 0 0 0)) using "$tables/TableA4_`t'", replace tex fragment  nomtitles collabels(none) substitute("&        -999" "$^{*}$" "&        -888" "$^{\dagger}$" "&        -777" "$^{\ddagger}$" "&        -111" "" \hline " " - $-$ "." "&." "r = 0&." "\; r = 0." "}$$^{" ",")
	}

	
	
********************************************
******* (E) Appendix Table A.5
********************************************	

	use "$cdata/part1_cleaned", replace
	eststo clear
	replace p_condition = p_condition/100
	replace r_condition = r_condition/100
	local k=0
	foreach t in CRP CCP CRP_CCP MXP {
		local k =`k' + 1

		eststo temp`k': reg Delta_`t' p_condition r_condition, cluster(id) 
		su Delta_`t' if e(sample)
		estadd local mean=round(`r(mean)',0.01): temp`k'
		estadd local space " ": temp`k'
	}

	* Save results
	label variable p_condition "Probability ($ p$)"
	label variable r_condition "Common Ratio ($ r$)"
	esttab using "$tables/TableA5.tex", fragment replace tex nonumber noobs label cells(b(nostar fmt(%9.2f)) se(par fmt(%9.2f))) nomtitles collabels(none) nolines substitute(- $-$)  stats(space mean N, fmt(%15.0fc %15.0fc %15.0fc) labels(" " "Outcome Mean"  "Observations")) nocons
		
	
********************************************
******* (F) Appendix Table A.6
********************************************

	use "$cdata/part1_cleaned", replace
	foreach t in CRP CCP MXP {
		foreach p in 30 50 80 90 {
			foreach r in 10 20 30 50 80 {
			
				su Delta_`t' if r_condition==`r' & p_condition==`p', de

				local med_diff = `r(p50)'
				ttest Delta_`t' == 0 if r_condition==`r' & p_condition==`p'
				local mu_diff =   `r(mu_1)'
				local mu_diff_p = `r(p)' 
		
			// sign test 
			signtest Delta_`t' = 0 if r_condition==`r' & p_condition==`p'
			matrix C`t' =   nullmat(C`t') \ `r'/100, `mu_diff', `mu_diff_p', `r(N_pos)', `r(N_tie)', `r(N_neg)', `r(p)', `med_diff'
			}
		}
		* save table 
		mat rownames C`t'= "0.3" "0.3" "0.3" "0.3" "0.3" "0.5" "0.5" "0.5" "0.5" "0.5" "0.8" "0.8" "0.8" "0.8" "0.8" "0.9" "0.9" "0.9" "0.9" "0.9"
		esttab matrix(C`t', fmt(1 2 3 0 0 0 3 0)) using "$tables/TableA6_`t'", replace tex fragment  nomtitles collabels(none) substitute(- $-$ \hline " ")
	}
	
	

	
********************************************
******* (G) Appendix Table A.7
********************************************
	
	use "$cdata/part1_cleaned", replace
	clear matrix 
	
	* 1) Means and variances using all observations
	preserve
	keep h_ab h_abprime h_cd h_ab_repeat h_abprime_repeat h_cd_repeat r_condition p_condition id
	rename (h_ab h_abprime h_cd h_ab_repeat h_abprime_repeat h_cd_repeat) ///
		   (h_ab0 h_abprime0 h_cd0 h_ab1 h_abprime1 h_cd1)
	reshape long h_ab h_abprime h_cd, i(id r_condition p_condition) j(repeat)

		foreach p in 30 50 80 90 {
			foreach r in 10 20 30 50 80 {
			
			estpost su h_ab h_abprime h_cd if p_condition==`p' & r_condition==`r'

			corr h_ab h_abprime if p_condition==`p' & r_condition==`r', cov
			local cov_ab_abprime = `r(cov_12)'

			corr h_ab h_cd if p_condition==`p' & r_condition==`r', cov
			local cov_ab_cd = `r(cov_12)'

			corr h_abprime h_cd if p_condition==`p' & r_condition==`r', cov
			local cov_abprime_cd = `r(cov_12)'

			* Store
			matrix R = nullmat(R) \ 0.`r'
			matrix M = nullmat(M) \ e(mean)
			matrix V = nullmat(V) \ e(Var)
			matrix C = nullmat(C) \ (`cov_ab_abprime', `cov_ab_cd', `cov_abprime_cd')
			}
		}
	restore
	
	* 2) Variance/Covariance across repeats (gammas and kappas)
	local k = 0
	foreach p in 30 50 80 90 {
			foreach r in 10 20 30 50 80 {
			* Update counter
			local k = `k' + 1
			
			* Calculate covariance for h_ab
			corr h_ab h_ab_repeat if p_condition==`p' & r_condition==`r', cov
			local gamma_ab = `r(cov_12)'
			local sigma_ab = V[`k',1] - `r(cov_12)'

			* Calculate covariance for h_abprime
			corr h_abprime h_abprime_repeat if p_condition==`p' & r_condition==`r', cov
			local gamma_abprime = `r(cov_12)'
			local sigma_abprime = V[`k',2] - `r(cov_12)'

			* Calculate covariance for h_cd
			corr h_cd h_cd_repeat if p_condition==`p' & r_condition==`r', cov
			local gamma_cd = `r(cov_12)'
			local sigma_cd = V[`k',3] - `r(cov_12)'
			
			* Calculate fraction attributable to preference
			local frac_ab      = round(`gamma_ab'/(`gamma_ab' + `sigma_ab'), 0.01)
			local frac_abprime = round(`gamma_abprime'/(`gamma_abprime' + `sigma_abprime'), 0.01)
			local frac_cd      = round(`gamma_cd'/(`gamma_cd' + `sigma_cd'), 0.01)

			* Store
			matrix G = nullmat(G) \ (`gamma_ab', `gamma_abprime', `gamma_cd')
			matrix S = nullmat(S) \ (`sigma_ab', `sigma_abprime', `sigma_cd')
			matrix F = nullmat(F) \ (`frac_ab', `frac_abprime', `frac_cd')
			}
	}
	
	*** Note: add final row with averages
	matrix D = (R, M, G, S, C, F)
	
	* Add average to final row
	matrix colmeans = (J(1, rowsof(D), 1) * D) / rowsof(D)
	matrix D = D \ colmeans
	local mean_p = round((0.3+0.5+0.8+0.9)/4,0.01)
	mat rownames D = "0.30" "0.30" "0.30" "0.30" "0.30" "0.50" "0.50" "0.50" "0.50" "0.50" "0.80" "0.80" "0.80" "0.80" "0.80" "0.90" "0.90" "0.90" "0.90" "0.90" "0`mean_p'"
	esttab matrix(D, fmt(2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2)) using "$tables/TableA7", replace tex fragment  nomtitles collabels(none)	substitute("\hline" "")
	
		
	
********************************************
******* (H) Appendix Table A.8
********************************************
	* Build table
	local k = 0
	foreach p in 30 50 80 90 {
			foreach r in 10 20 30 50 80 {
			* Update counter
			local k = `k' + 1	
	
		    * Average Preferences 
			local mean_CR = M[`k',1] - M[`k',3]
			local mean_CC = M[`k',2] - M[`k',3]
			local mean_MX = M[`k',1] - M[`k',2]

    	    * Standard Deviation of Preferences 
			local var_CR = sqrt(G[`k',1] + G[`k',3] - 2*C[`k',2])^2
			local var_CC = sqrt(G[`k',2] + G[`k',3] - 2*C[`k',3])^2
			local var_MX = sqrt(G[`k',1] + G[`k',2] - 2*C[`k',1])^2

			* Empirical Standard Deviations
			local var_CR_hat = G[`k',1] + S[`k',1] + G[`k',3] + S[`k',3] - 2*C[`k',2]
			local var_CC_hat = G[`k',2] + S[`k',2] + G[`k',3] + S[`k',3] - 2*C[`k',3]
			local var_MX_hat = G[`k',1] + S[`k',1] + G[`k',2] + S[`k',2] - 2*C[`k',1]

			* Share Preference
			local share_CR = `var_CR'/`var_CR_hat'
			local share_CC = `var_CC'/`var_CC_hat'
			local share_MX = `var_MX'/`var_MX_hat'

			* Store
			matrix P = nullmat(P) \ (0.`r', `mean_CR', `mean_CC', `mean_MX', `var_CR', `var_CC', `var_MX', `var_CR_hat', `var_CC_hat', `var_MX_hat', `share_CR', `share_CC', `share_MX')
			}
	}
	* Add average to final row (ignore missing values)
	matrix colmeans = J(1, colsof(P), .)
	forvalues i = 1/`=colsof(P)' {
		* Extract the i-th column of the matrix
		local sum = 0
		local count = 0
		forvalues j = 1/`=rowsof(P)' {
			if (P[`j', `i'] != .) {
				local sum = `sum' + P[`j', `i']
				local count = `count' + 1
			}
		}
		* Calculate the mean
		if (`count' > 0) {
			matrix colmeans[1, `i'] = `sum' / `count'
		}
	}
	matrix P = P \ colmeans
    local mean_p = round((0.3+0.5+0.8+0.9)/4,0.01)
	mat rownames P = "0.30" "0.30" "0.30" "0.30" "0.30" "0.50" "0.50" "0.50" "0.50" "0.50" "0.80" "0.80" "0.80" "0.80" "0.80" "0.90" "0.90" "0.90" "0.90" "0.90" "0`mean_p'"
	esttab matrix(P, fmt(2 2 2 2 2 2 2 2 2 2 2 2 2)) using "$tables/TableA8", replace tex fragment  nomtitles collabels(none)	substitute("-" "$-$" ".&" "$-$&" ".\\" "$-$\\" "\hline" "") 
	
	* Save as Stata file for later
	drop *
	matrix Ps = (0.3 \ 0.3 \ 0.3 \ 0.3 \ 0.3 \ 0.5 \ 0.5 \ 0.5 \ 0.5 \ 0.5 \ 0.8 \ 0.8 \ 0.8 \ 0.8 \ 0.8 \ 0.9 \ 0.9 \ 0.9 \ 0.9 \ 0.9), P[1..20,.]  
	matrix list Ps
	svmat Ps
	rename (Ps*) (p r Delta_CR Delta_CC Delta_MX Delta_CR_var Delta_CC_var Delta_MX_var Delta_CR_hat_var Delta_CC_hat_var Delta_MX_hat_var share_CR share_CC share_MX)
	
	* Save Decomposition for later
	save decomposition, replace
	
	**** Compute Posterier preferences given observed averages (will need these later)

	* Import the raw data
	use "$cdata/part1_cleaned", replace
	
	* Loop through each p and r
	local k = 0
	foreach p in 30 50 80 90 {
			foreach r in 10 20 30 50 80 {
				
			* Update counter
			local k = `k' + 1	
			
			preserve
				
				* Restrict to given p and r combination
				keep if p_condition == `p' & r_condition == `r'
				
				* Preferences
				matrix m1 =  (M[`k',1],M[`k',2],M[`k',3])
				matrix s11 = (G[`k',1],C[`k',1],C[`k',2] \ ///
							  C[`k',1],G[`k',2],C[`k',3] \ ///
							  C[`k',2],C[`k',3], G[`k',3])
				
				* Data (loop over each value)
				local N = _N
				forvalues i = 1/`N' { 
					* Average valuations and variance/covariance matricies
					if missing(h_ab_repeat[`i']) {
						matrix h   = (h_ab[`i'], h_abprime[`i'], h_cd[`i'], h_cd_repeat[`i'])
						matrix m2  = (M[`k',1], M[`k',2], M[`k',3], M[`k',3])
						matrix s22 = (G[`k',1] + S[`k',1], C[`k',1], C[`k',2], C[`k',2] \  ///
									  C[`k',1], G[`k',2] + S[`k',2], C[`k',3] , C[`k',3] \ ///
									  C[`k',2], C[`k',3], G[`k',3]  +  S[`k',3] ,  G[`k',3] \ ///
									  C[`k',2], C[`k',3], G[`k',3],  G[`k',3] +  S[`k',3]) 
						matrix s12 = (G[`k',1], C[`k',1], C[`k',2], C[`k',2] \  ///
									  C[`k',1], G[`k',2], C[`k',3] , C[`k',3] \ ///
									  C[`k',2], C[`k',3], G[`k',3],  G[`k',3] ) 	
									  }
					else {
						matrix h  = (h_ab[`i'], h_abprime[`i'], h_cd[`i'], h_ab_repeat[`i'], h_abprime_repeat[`i'], h_cd_repeat[`i'])
						matrix m2 = (M[`k',1], M[`k',2], M[`k',3], M[`k',1], M[`k',2], M[`k',3])
						matrix s22 = (G[`k',1] + S[`k',1], C[`k',1], C[`k',2], G[`k',1], C[`k',1], C[`k',2] \  ///
									  C[`k',1], G[`k',2] + S[`k',2], C[`k',3], C[`k',1] , G[`k',2], C[`k',3] \  ///
									  C[`k',2],C[`k',3], G[`k',3] + S[`k',3], C[`k',2],C[`k',3], G[`k',3] \  ///
									  G[`k',1], C[`k',1], C[`k',2], G[`k',1] + S[`k',1], C[`k',1], C[`k',2] \  ///
									  C[`k',1] , G[`k',2] , C[`k',3], C[`k',1] , G[`k',2] + S[`k',2], C[`k',3] \  ///
									  C[`k',2],C[`k',3], G[`k',3] , C[`k',2],C[`k',3], G[`k',3] + S[`k',3]) 
						matrix s12 = (G[`k',1], C[`k',1], C[`k',2], G[`k',1], C[`k',1], C[`k',2] \  ///
									  C[`k',1], G[`k',2], C[`k',3] , C[`k',1] , G[`k',2], C[`k',3] \ ///
									  C[`k',2], C[`k',3], G[`k',3],  C[`k',2], C[`k',3], G[`k',3] )
						}		
	
					* Compute Posterior
					matrix posterior = m1' + s12*invsym(s22)*(h - m2)'

					* Store posteriors			
					matrix Post_r`r'_`p' = nullmat(Post_r`r'_`p') \ (id[`i'], `p', `r', posterior')
				}
			restore
			}
	}
	
	
	* Combine and save
	foreach p in 30 50 80 90 {
		foreach r in 10 20 30 50 80 {
			matrix Post = nullmat(Post) \ Post_r`r'_`p'
		}
	}
	
	* Save for later
	preserve
		drop *
		svmat Post
		rename (Post*) (id p_condition r_condition h_ab_posterior h_abprime_posterior h_cd_posterior)
		save posterior_valuations, replace
	restore	

	
********************************************
******* (I) Appendix Table A.9
********************************************

	* Import data 
	use "$cdata/part2_cleaned", clear 
	eststo clear
	replace gap = gap*100
	gen MH_ratio = 30/(p*H)
	egen experiment = group(p r H)

	*** Panel A
	foreach t in CR CC MX {
		local k =`k' + 1

		eststo temp`k': reg gap p r H MH_ratio if `t'test, cluster(id) 
	 	su gap if e(sample)
		estadd local mean=round(`r(mean)',0.01): temp`k'
		estadd local space " ": temp`k'
		unique experiment if e(sample) 
		estadd local exp=round(`r(unique)',0.01): temp`k'
	}

	* Save Results
	label variable p "Probability ($ p$)"
	label variable r "Common Ratio ($ r$)"
	esttab using "$tables/TableA9a.tex", fragment replace tex nonumber noobs label keep(p r) cells(b(nostar fmt(%9.2f)) se(par fmt(%9.2f))) nomtitles collabels(none) nolines substitute(- $-$)  stats(space mean exp N, fmt(%15.0fc %15.0fc %15.2fc %15.0fc) labels(" " "Outcome Mean" "Experiments"  "Observations")) nocons
		
	
	***** Panel B: Canoncial vs. non-Canonical
		
	* Import data and gen additional variables
	use "$cdata/ExperimentData", clear
	drop if MXtest
	replace p=round(p*100)
	replace r=round(r*100)
	replace gap=gap*100
	gen allais_values = (p == 90 & r == 10)
	gen KT_values = (p==80 & inlist(r,20,30))
	
	* Weighted versions
	label variable gap "CCE - RCCE"
	
	* Summary stats
	eststo allais0: quietly estpost summarize gap  [aw = N] if prior_lit == 0 & CCtest & allais_values
	eststo nonallais0: quietly estpost summarize gap  [aw = N] if prior_lit == 0 & CCtest & allais_values==0
	
	* Regression to compare statistical significance
	preserve
	rename (gap allais_values) (gap1 gap)   // rename so that esttab produces single rows
	replace gap = !gap						// flip sign for table 
	eststo diff0:  quietly reg gap1 gap  [aw = N] if prior_lit==0 & CCtest
	restore
	
	* Output as table 
	esttab allais0 nonallais0 diff0 using "$tables/TableA9bi.tex", cells("mean(pattern(1 1 0) fmt(2)) b(nostar pattern(0 0 1) fmt(2))" "sd(pattern(1 1 0) par) t(pattern(0 0 1) par([ ]) fmt(2))") nomtitles collabels(none) nolines nonumber replace fragment label substitute(- $-$) stats(N, fmt(%15.0fc) labels("Experiments")) nocons

	label variable gap "CRE - RCRE"
	* Summary stats
	eststo kt0: quietly estpost summarize gap [aw = N] if prior_lit == 0 & CRtest & KT_values
	eststo nonkt0: quietly estpost summarize gap [aw = N] if prior_lit == 0 & CRtest & KT_values==0
	
	* Regression to compare statistical significance
	preserve
	rename (gap KT_values) (gap1 gap)
	replace gap = !gap
	eststo diff0:  quietly reg gap1 gap  [aw = N]if prior_lit == 0 & CRtest
	restore
	
	* Output as table 
	esttab kt0 nonkt0 diff0 using "$tables/TableA9bii.tex", cells("mean(pattern(1 1 0) fmt(2)) b(nostar pattern(0 0 1) fmt(2))" "sd(pattern(1 1 0) par) t(pattern(0 0 1) par([ ]) fmt(2))") nomtitles collabels(none) nolines nonumber replace fragment label substitute(- $-$) stats(N, fmt(%15.0fc) labels("Experiments")) nocons

		
********************************************
******* (J) Appendix Table C.1
********************************************

	use "$cdata/part2_cleaned", replace 
	eststo clear
	
	* Merge in posterior valuations
	merge m:1 id p_condition r_condition using posterior_valuations, nogen
		
	* Scaled differences
	gen scaled_value_CR = p*Delta_CRP
	gen scaled_value_CC = p*Delta_CCP
	gen scaled_value_MX = p*Delta_MXP
	
	* Scale distance to indifference
	gen scaled_dist_CR = p*((h_ab + h_cd)/2 - H)
	gen scaled_dist_CC = p*((h_abprime + h_cd_repeat)/2 - H)
	gen scaled_dist_MX = p*((h_ab_repeat + h_abprime_repeat)/2 - H)
	
	* Scale decomposed differences
	gen scaled_value_CR_star = p*(h_ab_posterior - h_cd_posterior)
	gen scaled_value_CC_star = p*(h_abprime_posterior - h_cd_posterior)
	gen scaled_value_MX_star = p*(h_ab_posterior - h_abprime_posterior)
	
	* Scaled decomposed distance to indifference
	gen scaled_dist_CR_star = p*((h_ab_posterior + h_cd_posterior)/2 - H)
	gen scaled_dist_CC_star = p*((h_abprime_posterior + h_cd_posterior)/2 - H)
	gen scaled_dist_MX_star = p*((h_ab_posterior + h_abprime_posterior)/2 - H)
	
	* For MX choices, allow reusing valuations for MX for column (1) of the regression
	replace scaled_value_MX = p*(h_ab - h_abprime) if missing(Delta_MX)
	replace scaled_dist_MX  = p*((h_ab + h_abprime)/2 - H) if missing(Delta_MX)

	**** Instruments
	gen scaled_value_CR_prime = p*(h_ab_repeat - h_cd_repeat)
	gen scaled_value_CC_prime = p*(h_abprime_repeat - h_cd)
	gen scaled_value_MX_prime = p*(h_ab - h_abprime) if !missing(h_ab_repeat)

	gen scaled_dist_CR_prime = p*((h_ab_repeat + h_cd_repeat)/2 - H)
	gen scaled_dist_CC_prime = p*((h_abprime_repeat + h_cd)/2 - H)
	gen scaled_dist_MX_prime = p*((h_ab + h_abprime)/2 - H) if !missing(h_ab_repeat)

	
	* Label variables
	label variable scaled_value_CR "$ p\Delta_{CC}$" 
	label variable scaled_value_CC "$ p\Delta_{CR}$" 
	label variable scaled_value_MX "$ p\Delta_{MX}$" 
	label variable scaled_dist_CR "$ p(\bar{h}_{CR}$ - $ H)$" 
	label variable scaled_dist_CC "$ p(\bar{h}_{CC}$ - $ H)$" 
	label variable scaled_dist_MX "$ p(\bar{h}_{MX}$ - $ H)$" 
	label variable scaled_value_CR_star "$ p\Delta_{CR}$" 
	label variable scaled_value_CC_star "$ p\Delta_{CC}$" 
	label variable scaled_value_MX_star "$ p\Delta_{MX}$" 
	label variable scaled_dist_CR_star "$ p(\bar{h}_{CR}$ - $ H)$" 
	label variable scaled_dist_CC_star "$ p(\bar{h}_{CC}$ - $ H)$" 
	label variable scaled_dist_MX_star "$ p(\bar{h}_{MX}$ - $ H)$" 
	
	***** For CRP and CCP
	replace gap = gap*100
	foreach t in CR CC MX {
		gen `t'_IV_sample = (!missing(scaled_dist_`t') & !missing(scaled_dist_`t'_prime))

		eststo temp1: reg gap scaled_value_`t' scaled_dist_`t' i.p_condition i.r_condition if `t'test, cluster(id)
		su gap if e(sample)
		estadd local mean=round(`r(mean)',0.01): temp1
		estadd local ind=`e(N)'/4: temp1
		estadd local space " ": temp1

		eststo temp2: reg gap scaled_value_`t' scaled_dist_`t' i.p_condition i.r_condition if `t'test & `t'_IV_sample, cluster(id)
		su gap if e(sample)
		estadd local mean=round(`r(mean)',0.01): temp2
		estadd local ind=`e(N)'/4: temp2
		estadd local space " ": temp2

		eststo temp3: ivregress 2sls gap (scaled_value_`t' scaled_dist_`t' = scaled_value_`t'_prime scaled_dist_`t'_prime) i.p_condition i.r_condition if `t'test & `t'_IV_sample, first vce(cluster id)
		su gap if e(sample)
		estadd local mean=round(`r(mean)',0.01): temp3
		estadd local ind=`e(N)'/4: temp3
		estadd local space " ": temp3
		
		drop scaled_value_`t' scaled_dist_`t'
		rename (scaled_value_`t'_star scaled_dist_`t'_star) (scaled_value_`t' scaled_dist_`t')
		eststo temp4: reg gap scaled_value_`t' scaled_dist_`t' i.p_condition i.r_condition if `t'test, cluster(id)
		su gap if e(sample)
		estadd local mean=round(`r(mean)',0.01): temp4
		estadd local ind=`e(N)'/4: temp4
		estadd local space " ": temp4

		if ("`t'" == "MX"){
			esttab using "$tables/TableC1_`t'.tex", fragment replace tex nonumber noobs label order(scaled_value_`t' scaled_dist_`t') keep(scaled_value_`t' scaled_dist_`t') cells(b(nostar fmt(%9.2f)) se(par)) nomtitles collabels(none) nolines substitute(- $-$ main " ")  stats(space mean ind N, fmt(%15.0fc %15.2f %15.0fc) labels(" " "Outcome Mean" "Individuals" "Observations"))
		}
		else {
			esttab using "$tables/TableC1_`t'.tex", fragment replace tex nonumber noobs label order(scaled_value_`t' scaled_dist_`t') keep(scaled_value_`t' scaled_dist_`t') cells(b(nostar fmt(%9.2f)) se(par)) nomtitles collabels(none) nolines substitute(- $-$ main " ")  stats(space mean, fmt(%15.0fc %15.2f) labels(" " "Outcome Mean"))
		}
	}
