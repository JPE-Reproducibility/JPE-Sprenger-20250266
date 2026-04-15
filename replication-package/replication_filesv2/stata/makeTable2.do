/*********************************************************
 Purpose: Makes table 2 from the main text		
 Last edited: 01/18/2026 		                                              
***********************************************************/

/**********************************************************
Table list:
	A) Table 2: Sensitivity of Results to Experimental Parameters in the Prior Literature
***********************************************************/


***********************************************
*** (A) Table 2
***********************************************
	
	***** Panel A: Sensitivity to experimental parameters
	
	* Import Part 2 data
	use "$cdata/ExperimentData", clear
	drop if MXtest
		
	* Relative Stakes and CCE dummy 
	gen MH_ratio = M/(p*H)    
	replace gap = gap*100 

	* Regressions 
	label variable p " $ H$ Probability: $ p$ "
	label variable r " Common Ratio: $ r$ "
	label variable real "Real Stakes"
	label variable MH_ratio " $ M/(pH)$"
	label variable H " $ H$"

	eststo temp1: reg gap p r real MH_ratio H  [aw = N] if prior_lit==1 & CRtest
	su gap if e(sample)
	estadd local mean=round(`r(mean)',0.01): temp1
	estadd local sample "\cite{blavatskyy2023common}": temp1
	estadd local space " ": temp1

	eststo temp2: reg gap p r real MH_ratio H  [aw = N] if prior_lit==1 & CCtest
	su gap if e(sample)
	estadd local mean=round(`r(mean)',0.01): temp2
	estadd local sample "\cite{blavatskyy2022experimental}": temp2
	estadd local space " ": temp2
	
	esttab using "$tables/table2a.tex", fragment replace tex nonumber noobs label order(p r MH_ratio real) keep(p r) cells(b(nostar fmt(%9.2f)) se(par fmt(%9.2f))) nomtitles collabels(none) nolines substitute(\_ _ - $-$ " 0.00" " " (.) " " 0000000000001 "")  stats(space sample mean N, fmt(%15.0fc %15.0fc %15.2fc %15.0fc) labels(" "  "Sample" "Outcome Mean" "Observations"))
	eststo clear
	
	***** Panel B: Canoncial vs. non-Canonical

	* Import data and gen additional variables
	use "$cdata/ExperimentData", clear
	drop if MXtest
	replace p=round(p*100)
	replace r=round(r*100)
	replace gap=gap*100
	gen allais_values = (p == 91 & r == 11)
	gen KT_values = (p==80 & r==25)
		
	*** Panel B(i)
	label variable gap "CRE - RCRE"
	* Summary stats
	eststo kt1: quietly estpost summarize gap  [aw = N] if prior_lit==1 & CRtest & KT_values
	eststo nonkt1: quietly estpost summarize gap   [aw = N] if prior_lit == 1 & CRtest & KT_values==0
	
	* Regression to compare statistical significance
	preserve
	rename (gap KT_values) (gap1 gap)
	replace gap = !gap
	eststo diff1:  quietly reg gap1 gap  [aw = N]if prior_lit==1 & CRtest
	restore
	
	* Output as table 
	esttab kt1 nonkt1 diff1 using "$tables/table2bi.tex", cells("mean(pattern(1 1 0) fmt(2)) b(nostar pattern(0 0 1) fmt(2))" "sd(pattern(1 1 0) par) t(pattern(0 0 1) par([ ]) fmt(2))") nomtitles collabels(none) nolines nonumber replace fragment label substitute(- $-$) stats(N, fmt(%15.0fc) labels("Experiments")) nocons
	
	
	*** Panel B(ii)
	label variable gap "CCE - RCCE"
	
	* Summary stats
	eststo allais1: quietly estpost summarize gap  [aw = N] if prior_lit == 1 & CCtest & allais_values
	eststo nonallais1: quietly estpost summarize gap  [aw = N] if prior_lit == 1 & CCtest & allais_values==0
	
	* Regression to compare statistical significance
	preserve
	rename (gap allais_values) (gap1 gap)   // rename so that esttab produces single rows
	replace gap = !gap						// flip sign for table 
	eststo diff1:  quietly reg gap1 gap  [aw = N] if prior_lit==1 & CCtest
	restore
	
	* Output as table 
	esttab allais1 nonallais1 diff1 using "$tables/table2bii.tex", cells("mean(pattern(1 1 0) fmt(2)) b(nostar pattern(0 0 1) fmt(2))" "sd(pattern(1 1 0) par) t(pattern(0 0 1) par([ ]) fmt(2))") nomtitles collabels(none) nolines nonumber replace fragment label substitute(- $-$) stats(N, fmt(%15.0fc) labels("Experiments")) nocons

	
