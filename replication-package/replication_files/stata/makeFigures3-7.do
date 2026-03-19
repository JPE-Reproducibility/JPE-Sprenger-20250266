/*********************************************************
 Purpose: Makes figures 3- 7 from the main text				   	                                     
 Last edited: 01/18/2026 		                                              
***********************************************************/

/**********************************************************
Figure list:
	A) Figure 3: Stage 1 Valuations: Mean ΔCR, ΔCC, and ΔMX by p for each r
	B) Figure 4: Stage 2 Choices: Mean CRE - RCRE, CCE - RCCE, MXE - RMXE by p for each r
	C) Figure 5: Histogram of Response Patterns
	D) Figure 6: Preference Patterns vs. Data Patterns
	E) Figure 7: Predicting Stage 2 Results using Stage 1 Valuations
***********************************************************/

***********************************************
*** (A) Figure 3
***********************************************

	* Import and set up the data
	use "$cdata/part1_cleaned", replace 
	collapse Delta_CRP Delta_CCP Delta_MXP, by(r_condition p_condition)
	
	* Graph each average preference by p for each r 
	local k=0
	local colors "cranberry ebblue purple" 
	local panels "a b c" 
	foreach t in CR CC MX {
		local k = `k'+1
		local color : word `k' of `colors'	
		local p : word `k' of `panels'
		twoway (connected Delta_`t'P p_condition if r_condition==10, color(`color')) (connected Delta_`t'P p_condition if r_condition==20, color(`color'%80)) (connected Delta_`t'P p_condition if 		r_condition==30, color(`color'%60)) (connected Delta_`t'P p_condition if r_condition==50, color(`color'%45)) (connected Delta_`t'P p_condition if r_condition==80, color(`color'%30)),  	xlabel(20 "0.2" 30 "0.3" 40 "0.4" 50 "0.5" 60 "0.6" 70 "0.7" 80 "0.8" 90 "0.9" 100 "1.0") ylabel(20(5)45) xsize(5.5) ysize(5) legend(order(1 "r=0.1" 2 "r=0.2" 3 "r=0.3" 4 "r=0.5" 5 "r=0.8  ") rows(1) size(small)) xtitle("Probability (p)") ytitle("Mean {&Delta}{sub:`t'}" " " " ") ylabel(-15(5)15) yline(0, lp(solid) lc(gs8))
		graph export "$figures/Figure3`p'.pdf", replace
	}
	
	
***********************************************
*** (B) Figure 4
***********************************************

	* Import and set up the data
	use "$cdata/part2_cleaned", replace 
	
	* Clean variables
	replace gap = gap*100
	
	* Collapse
	collapse gap, by(r_condition p_condition decision_type)
	
	* Plot for each decision type
	local emdash = ustrunescape("\u2013")
	local k=0
	local colors "cranberry ebblue purple" 
	local panels "a b c" 
	foreach t in CRE CCE MXE {
		local k = `k'+1
		local color : word `k' of `colors' 
		local p : word `k' of `panels'
		twoway (connected gap p_condition if r_condition==10 & decision_type=="`t'", color(`color')) (connected gap p_condition if r_condition==20 & decision_type=="`t'", color(`color'%80)) (connected gap p_condition if 	r_condition==30 & decision_type=="`t'", color(`color'%60)) (connected gap p_condition if r_condition==50 & decision_type=="`t'", color(`color'%45)) (connected gap p_condition if r_condition==80 & decision_type=="`t'", color(`color'%30)),  	xlabel(20 "0.2" 30 "0.3" 40 "0.4" 50 "0.5" 60 "0.6" 70 "0.7" 80 "0.8" 90 "0.9" 100 "1.0") ylabel(-35 " " -30(10)30 35 " ") xsize(5.5) ysize(5) legend(order(1 "r=0.1" 2 "r=0.2" 3 "r=0.3" 4 "r=0.5" 5 "r=0.8  ") rows(1) size(small)) xtitle("Probability (p)") ytitle("Mean `t' `emdash' R`t'" " " " ") yline(0, lp(solid) lc(gs8))
		graph export "$figures/Figure4`p'.pdf", replace
	}
	
	
***********************************************
*** (C) Figure 5
***********************************************
	
	* Import the data
	use "$cdata/part1_cleaned", replace 
	
	* Generate trinary type variables based on the data (note reverse coded for the graph)
	foreach t in CRP CCP MXP {
		gen t_`t' = 0 if !missing(Delta_`t')
		replace t_`t' = 1 if Delta_`t' < 0 &  !missing(Delta_`t')
		replace t_`t' = -1 if Delta_`t' > 0 &  !missing(Delta_`t')
	}
	
	* Plot
	egen pattern = group(t_MXP t_CRP t_CCP) // groups 1-9: MXP, groups 10-18: No MLP; groups 19-27: RMXP
	
	* Add spacing for bar chart between MXP, No MXP, and RMXP
	replace pattern = pattern + 2 if pattern>9
	replace pattern = pattern + 2 if pattern>20

	* Add spacing for bar chart between MXP, No MXP, and RMXP
	replace pattern = pattern + 1 if pattern>3
	replace pattern = pattern + 1 if pattern>7
	
	replace pattern = pattern + 1 if pattern>16
	replace pattern = pattern + 1 if pattern>20

	replace pattern = pattern + 1 if pattern>29
	replace pattern = pattern + 1 if pattern>33
		
	**** Numbers for the text (i.e., green bars)
	count if !missing(pattern)
	local N = `r(N)'

	count if Delta_CCP > 0 & Delta_CRP > 0 & !missing(pattern)
	di  r(N)/`N'*100
	
	count if Delta_CCP < 0 & Delta_CRP > 0 & !missing(pattern)
	di  r(N)/`N'*100
	
	count if Delta_CCP < 0 & Delta_CRP > 0  & Delta_MXP > 0  & !missing(pattern)
	di  r(N)/`N'*100
	
	**** T12, T23, T34
	
	* T23
	count if Delta_MXP>0 & Delta_CRP > 0 & Delta_CCP == 0 & !missing(pattern)
	local T23 = r(N)/`N'*100
	
	* T12
	count if Delta_MXP>0 & Delta_CRP == 0 & Delta_CCP < 0 & !missing(pattern)
	local T12 = r(N)/`N'*100
	
	* T34
	count if Delta_MXP==0 & Delta_CRP > 0 & Delta_CCP > 0 & !missing(pattern)
	local T34 = r(N)/`N'*100
		
	* Save sample size for later
	count if !missing(pattern)
	local N = `r(N)'
	
	* Save types for later
	save types, replace
	
	* Plot figure
	forvalues j = 1(1)3{
		local l`j' = `N'*0.`j'
	}
	twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
	(hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
	(hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///	
	legend(off) ylabel(`l1' "10%" `l2' "20%" `l3' "30%") ///
	xlabel(none)  xtitle("") ytitle("Percent of Observations")  graphregion(margin(3 3 5 3)) plotregion(margin(1 3 0 5) lstyle(none)) xsize(8) ysize(5)
	
	* Save graph
	graph export "$figures/Figure5.pdf", replace
	
	
*******************************************************
*** (D) Figure 6
*******************************************************
	
	* Start with actual data patterns with shaded bars
	twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
	(hist pattern if inlist(pattern,5,6,9,10,15,16,18,20,22,23,28,29,32,33), start(1) width(0.999) freq  lalign(center) fcolor(gray%25)) ///
	(hist pattern if inlist(pattern,1,3,11,27), start(1) width(0.999) freq  lalign(center) fcolor(ebblue%80)) ///
    (hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%50)) ///	
	(hist pattern if inlist(pattern,2,7,14), start(1) width(0.999) freq  lalign(center) fcolor(ebblue%35)), ///
	legend(ring(0) pos(3) rows(3) size(vsmall)) ylabel(`l1' "10%" `l2' "20%" `l3' "30%") ///
	xlabel(none)  xtitle("") ytitle("Percent of Cases")  graphregion(margin(3 3 5 3)) plotregion(margin(1 3 0 5) lstyle(none)) xsize(8) ysize(5)
	
	*** Add simulated preference types
	drop *
	set obs 100000
	gen n = _n
	forvalues k = 1(1)20 {
		di `k'
		* Simulate data based on preferences 
		matrix mu    = (M[`k',1], M[`k',2], M[`k',3])
		matrix sigma = (G[`k',1], C[`k',1], C[`k',2] \ C[`k',1], G[`k',2], C[`k',3] \ C[`k',2], C[`k',3], G[`k',3])
		
		* Draw values (order must match mu and sigma: AB, ABprime, CD)
		drawnorm h_ab_sim`k' h_abprime_sim`k' h_cd_sim`k', means(mu) cov(sigma) forcepsd

		* Convert to response scale
		foreach t in ab abprime cd {
			replace h_`t'_sim`k' = (ceil(h_`t'_sim`k') + floor(h_`t'_sim`k'))/2
		}

		* Calculate simulated preference differences consistent with new notation
		gen Delta_CR_sim`k' = h_ab_sim`k' - h_cd_sim`k'
		gen Delta_CC_sim`k' = h_abprime_sim`k' - h_cd_sim`k'
		gen Delta_MX_sim`k' = h_ab_sim`k' - h_abprime_sim`k'

	}	
	
	* Reshape the data long
	reshape long h_ab_sim h_abprime_sim h_cd_sim Delta_CR_sim Delta_CC_sim Delta_MX_sim, i(n) j(sim_num)
	
	* Classify types
	local z = 0
	foreach i in > == < {
		foreach j in > == < {
			foreach k in > == < {
				* Update counter
				local z = `z' + 1
				* Generate pattern dummy
				gen pattern`z'  = (Delta_MX_sim `i' 0 &  Delta_CR_sim `j' 0 & Delta_CC_sim `k' 0)
			}
			* Add spacing between CR types
			local z = `z' + 1
		}
		* Add spacing between MX types
		local z = `z' + 1
	}
	
	* Save data for later
	save types_posterior, replace
	
	* Calculate shares
	keep pattern*
	collapse pattern*
	gen id = 1
	reshape long pattern, i(id) j(t)
	rename (t pattern) (pattern share)
	
	* Add points to graph
	replace share = `N'*share
	replace pattern = pattern + 0.5

	* Save graph
	graph addplot scatter share pattern, m(O) mcolor(black%60) legend(order(2 "Intransitive" 3 "Prominent (Strict)" 5 "Prominent (Weak)" 6 "Preferences") ring(0) pos(3) rows(4) size(vsmall))    ylabel(`l1' "10%" `l2' "20%" `l3' "30%") xlabel(none)  xtitle("") ytitle("Percent of Observations")  graphregion(margin(3 3 5 3)) plotregion(margin(1 3 0 5) lstyle(none)) xsize(8) ysize(5)
	graph export "$figures/Figure6.pdf", replace



	
*******************************************************
*** (D) Figure 7
*******************************************************


	
**** Figure 7: Valuations/Preferences vs. Stage-2 choice

	* Reshape to include repeats
	use "$cdata/part2_cleaned", replace
	
	* Merge in posterior valuations
	merge m:1 id p_condition r_condition using posterior_valuations, nogen
	
	* Scale values
	gen scaled_value_CR_star = p*(h_ab_posterior - h_cd_posterior)
	gen scaled_value_CC_star = p*(h_abprime_posterior - h_cd_posterior)
	gen scaled_value_MX_star = p*(h_ab_posterior - h_abprime_posterior)
	
	* Scale values
	gen scaled_value_CR = p*Delta_CRP
	gen scaled_value_CC = p*Delta_CCP
	gen scaled_value_MX = p*Delta_MXP

	* Make Panels A - F
	local emdash = ustrunescape("\u2013")
	replace gap = gap*100
	local k=0
	local colors "cranberry ebblue purple" 
	local top_label "a b c" 
	local bottom_label "d e f" 
	foreach t in CR CC MX {
		local k = `k'+1
		local color :  word `k' of `colors' 
		local top :    word `k' of `top_label' 
		local bottom : word `k' of `bottom_label' 

		* Scaled stage 1 raw valuation vs stage 2 choices (raw)
		binscatter gap scaled_value_`t' if `t'test,  nquantiles(100)  color(`color'%40) xsize(6) ysize(5.5) lc(`color'%30) ytitle("`t'E `emdash' R`t'E") xtitle("Stage 1 Value Difference: p {&Delta}{sub:`t'}") xlabel(-40(10)45) ylabel(-50(10)60) yline(0, lc(black%50) lp(dash))  xline(0, lc(black%50) lp(dash)) legend(off) 	
		graph export "$figures/Figure7`top'.pdf", replace
		
		* Scaled stage 1 preference vs stage 2 choices
		binscatter gap scaled_value_`t'_star if `t'test,  nquantiles(100)  color(`color'%60) xsize(6) ysize(5.5) lc(`color'%60)  ytitle("`t'E `emdash' R`t'E") xtitle("Decomposed Preferences: p E[{&Delta}*{sub:`t'}|stage 1]") xlabel(-20(10)23) ylabel(-50(10)80) yline(0, lc(black%50) lp(dash))  xline(0, lc(black%50) lp(dash)) legend(off) 
		graph export "$figures/Figure7`bottom'.pdf", replace
	}	
	