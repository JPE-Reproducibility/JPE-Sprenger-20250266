 /*********************************************************
 Purpose: Makes Appendix Figures		
 Last edited: 01/18/2026 		                                              
***********************************************************/

/**********************************************************
Figure list:
	A) Figure A.1: Histogram of Response Patterns for r ∈ {0.1, 0.2, 0.3} and p ∈ {0.8, 0.9}
	B) Figure A.2: Histogram of Response Patterns for r ∉ {0.1, 0.2, 0.3} and p ∉ {0.8, 0.9}
	C) Figure A.3: Histogram of Response Patterns for r ∈ {0.1, 0.2, 0.3} and p ∈ {0.3, 0.5}
	D) Figure A.4: Predicting Stage 2 Choice Probabilities using Stage 1 Valuations
***********************************************************/


	
********************************************
******* (A) Appendix Figure  A.1
********************************************

	* Import the data
	use "$cdata/part1_cleaned", replace
	
	* Keep/drop canonical values
	keep if inlist(r_condition,10, 20, 30) & inlist(p_condition, 80, 90)
	
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
			
	* Plot
	count if !missing(pattern)
	forvalues j = 1(1)3{
		local l`j' = `r(N)'*0.`j'
	}
	twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
	(hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
	(hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///	
	legend(off) ylabel(`l1' "10%" `l2' "20%" `l3' "30%") ///
	xlabel(none)  xtitle("") ytitle("Percent of Observations")  graphregion(margin(3 3 5 3)) plotregion(margin(1 3 0 5) lstyle(none)) xsize(8) ysize(5)
	
	* Save graph
	graph export "$figures/FigureA1.pdf", replace

	* Save data for later
	save types_canonical, replace


	
********************************************
******* (B) Appendix Figure  A.2
********************************************

	* Import the data
	use "$cdata/part1_cleaned", replace
	
	* Keep/drop canonical values
	drop if inlist(r_condition,10, 20, 30) & inlist(p_condition, 80, 90)
	
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
			
	* Plot
	count if !missing(pattern)
	forvalues j = 1(1)3{
		local l`j' = `r(N)'*0.`j'
	}
	twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
	(hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
	(hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///	
	legend(off) ylabel(`l1' "10%" `l2' "20%" `l3' "30%") ///
	xlabel(none)  xtitle("") ytitle("Percent of Observations")  graphregion(margin(3 3 5 3)) plotregion(margin(1 3 0 5) lstyle(none)) xsize(8) ysize(5)
	
	* Save graph
	graph export "$figures/FigureA2.pdf", replace
	
	
********************************************
******* (B) Appendix Figure  A.3
********************************************

	* Import the data
	use "$cdata/part1_cleaned", replace
	
	* Keep/drop canonical values
	keep if inlist(r_condition,10, 20, 30) & inlist(p_condition, 30, 50)
	
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
			
	* Plot
	count if !missing(pattern)
	forvalues j = 1(1)3{
		local l`j' = `r(N)'*0.`j'
	}
	twoway (hist pattern, start(1) width(0.999) freq lalign(center) fcolor(white%0)) ///
	(hist pattern if inlist(pattern,1,14,27), start(1) width(0.999) freq  lalign(center) fcolor(green%30)) ///
	(hist pattern if inlist(pattern,19), start(1) width(0.999) freq  lalign(center) fcolor(grey%20)), ///	
	legend(off) ylabel(`l1' "10%" `l2' "20%" `l3' "30%") ///
	xlabel(none)  xtitle("") ytitle("Percent of Observations")  graphregion(margin(3 3 5 3)) plotregion(margin(1 3 0 5) lstyle(none)) xsize(8) ysize(5)
	
	* Save graph
	graph export "$figures/FigureA3.pdf", replace
	
	* Save for later
	save types_other, replace

		
********************************************
******* (D) Appendix Figure  A.4
********************************************	
	use "$cdata/part2_cleaned", replace
	
	*** Plot
	merge m:1 id p_condition r_condition using posterior_valuations, nogen
	
	* Differences (values)
	gen diff_ab       = p*(h_ab - H)
	gen diff_ab_prime = p*(h_abprime - H)
	gen diff_cd       = p*(h_cd - H)

	* Differences (preferences)
	gen diff_ab_star       = p*(h_ab_posterior - H)
	gen diff_ab_prime_star = p*(h_abprime_posterior - H)
	gen diff_cd_star       = p*(h_cd_posterior - H)

	
	* Chpice Probabilities
	gen PrA_AB       = (choice1=="A" | choice2=="A") if (decision1=="AB"      | decision2=="AB")
	gen PrA_AB_prime = (choice1=="A" | choice2=="A") if (decision1=="ABprime" | decision2=="ABprime")
	gen PrC_CD       = (choice1=="C" | choice2=="C") if (decision1=="CD"      | decision2=="CD")

	local emdash = ustrunescape("\u2013")
	
	* h_ab
	binscatter PrA_AB diff_ab,  nquantiles(100)  color(green%30) xsize(6) ysize(5.5) ytitle("Pr(A|AB)") xlabel(-40(10)40) xtitle("Value Difference: p (h{sub:AB} `emdash' stage 2 H)")  yline(0.5, lc(black%50) lp(dash)) xline(0.5, lc(black%50) lp(dash))  ylabel(0(0.25)1, format(%9.2f))  line(none) legend(off)
	graph export "$figures/FigureA4a.pdf", replace
	
	* h_ab_star
	binscatter PrA_AB diff_ab_star,  nquantiles(100)  color(green%60) xsize(6) ysize(5.5)  ytitle("Pr(A|AB)") xlabel(-40(10)40) xtitle("Decomposed Preferences: p (E[h{sup:*}{sub:AB}|stage 1] `emdash' stage 2 H)")  yline(0.5, lc(black%50) lp(dash)) xline(0.5, lc(black%50) lp(dash))  ylabel(0(0.25)1, format(%9.2f))  line(none) legend(off)
	graph export "$figures/FigureA4b.pdf", replace

	* h_ab_prime
	binscatter PrA_AB_prime diff_ab_prime,  nquantiles(100)  color(gold%30) xsize(6) ysize(5.5) ytitle("Pr(A|AB')") xlabel(-40(10)40) xtitle("Value Difference: p (h{sub:AB'} `emdash' stage 2 H)")  yline(0.5, lc(black%50) lp(dash)) xline(0.5, lc(black%50) lp(dash))  ylabel(0(0.25)1, format(%9.2f))  line(none) legend(off)
	graph export "$figures/FigureA4c.pdf", replace
	
	* h_ab_prime_star
	binscatter PrA_AB_prime diff_ab_prime_star,  nquantiles(100)  color(gold%60) xsize(6) ysize(5.5) ytitle("Pr(A|AB')") xlabel(-40(10)40) xtitle("Decomposed Preferences: p (E[h{sup:*}{sub:AB'}|stage 1] `emdash' stage 2 H)")  yline(0.5, lc(black%50) lp(dash)) xline(0.5, lc(black%50) lp(dash))  ylabel(0(0.25)1, format(%9.2f))  line(none) legend(off)
	graph export "$figures/FigureA4d.pdf", replace

	* h_cd
	binscatter PrC_CD diff_cd,  nquantiles(100)  color(navy%30) xsize(6) ysize(5.5) ytitle("Pr(C|CD)") xlabel(-40(10)40) xtitle("Value Difference: p (h{sub:CD} `emdash' stage 2 H)")  yline(0.5, lc(black%50) lp(dash)) xline(0.5, lc(black%50) lp(dash))  ylabel(0(0.25)1, format(%9.2f))  line(none) legend(off)
	graph export "$figures/FigureA4e.pdf", replace
	
	* h_cd star
	binscatter PrC_CD diff_cd_star,  nquantiles(100)  color(navy%60) xsize(6) ysize(5.5) ytitle("Pr(C|CD)") xlabel(-40(10)40) xtitle("Decomposed Preferences: p (E[h{sup:*}{sub:CD}|stage 1] `emdash' stage 2 H)")  yline(0.5, lc(black%50) lp(dash)) xline(0.5, lc(black%50) lp(dash))  ylabel(0(0.25)1, format(%9.2f))  line(none) legend(off)
	graph export "$figures/FigureA4f.pdf", replace
	

********************************************
******* (E) Appendix Figure  C.1
********************************************

	use "$cdata/part2_cleaned", replace
	
	*** Merge in posterior valuations
	merge m:1 id p_condition r_condition using posterior_valuations, nogen
	
	* Scale values
	gen scaled_dist_CR = p*((h_ab + h_cd)/2 - H)
	gen scaled_dist_CC = p*((h_abprime + h_cd_repeat)/2 - H)
	gen scaled_dist_MX = p*((h_ab_repeat + h_abprime_repeat)/2 - H)
	
	* Scaled perferences
	gen scaled_dist_CR_star = p*((h_ab_posterior + h_cd_posterior)/2 - H)
	gen scaled_dist_CC_star = p*((h_abprime_posterior + h_cd_posterior)/2 - H)
	gen scaled_dist_MX_star = p*((h_ab_posterior + h_abprime_posterior)/2 - H)

	
	* Make graph
	local emdash = ustrunescape("\u2013")
	local overline = uchar(773) 
	replace gap = gap*100
	local k=0
	local colors "cranberry ebblue purple" 
	local labels1 "h`overline'{sub:CR} h`overline'{sub:CC} h`overline'{sub:MX}"
	local labels2 "h`overline'*{sub:CR} h`overline'*{sub:CC} h`overline'*{sub:MX}"
	local top_label "a b c" 
	local bottom_label "d e f" 
	foreach t in CR CC MX {
		local k = `k'+1
		local color : word `k' of `colors' 
		local newlabel1 : word `k' of `labels1'  	
		local newlabel2 : word `k' of `labels2'  	
		local top :    word `k' of `top_label' 
		local bottom : word `k' of `bottom_label' 
		
		* Scaled distance to indifference vs stage 2 choices (raw)
		binscatter gap scaled_dist_`t' if `t'test,  nquantiles(100)  color(`color'%30) xsize(6) ysize(5.5) lc(`color'%30) ytitle("`t'E `emdash' R`t'E") xtitle("Stage 1 Distance to Indifference: p(`newlabel1' `emdash' H)") xlabel(-35 " " -30(10)30 35 " ") ylabel(-55 " " -50(10)50 55 " ") yline(0, lc(black%50) lp(dash))  xline(0, lc(black%50) lp(dash)) legend(off) 	
		graph export "$figures/FigureC1`top'.pdf", replace
		
		
		* Scaled distance to indifference vs stage 2 choices 
		binscatter gap scaled_dist_`t'_star if `t'test,  nquantiles(100)  color(`color'%60) xsize(6) ysize(5.5) lc(`color'%30)  ytitle("`t'E `emdash' R`t'E") xtitle("Decomposed Preferences: p(E[`newlabel2'|stage 1] `emdash' H)") xlabel(-35 " " -30(10)30 35 " ") ylabel(-55 " " -50(10)50 55 " ") yline(0, lc(black%50) lp(dash))  xline(0, lc(black%50) lp(dash)) legend(off) 	
		graph export "$figures/FigureC1`bottom'.pdf", replace
	}
