/**************************************************************************
 Purpose: Clean the raw experimental data and prior literature data     
 Last edited: 01/08/26                                                  
**************************************************************************/


*****************************************************
***** (A) Import and initial cleaning of the raw data 
*****************************************************
	
	* Import raw data
	insheet using "$rdata/qualtrics-raw.csv", clear

	* Generate a Unique ID
	unique responseid // 2104 unique ids
	gen id = _n 	  // generate numeric id		 

	* Missing data for 2 participants
	drop if q179 == 6 // Drop 2 participants did not consent to participant

	* Bonus payments
	gen bonuspayment = 0
	replace bonuspayment=mplbonus if blockpaid==1 & personpaid==1
	replace bonuspayment=binbonus if blockpaid==2 & personpaid==1
	replace bonuspayment=quizbonus if blockpaid==3 & personpaid==1

	* Comprehension Qs (save for later)
	preserve
		gen paidQ_correct=q133==2
		gen attention_correct=q136==2
		gen mpl_correct=testmpl==24.5
		gen bin_correct=testbin==1
		gen both_correct = (bin_correct & mpl_correct)
		keep responseid paidQ_correct attention_correct mpl_correct bin_correct both_correct r_1 r_2 r_3 r_4 bonuspayment personpaid
		save compQs, replace
	restore


*************************************
***** (B) Reshape data to be long
*************************************

	* Reshape long 
	keep responseid id choice1-choice44 type1-type44 hval1-hval44 pval1-pval44 rval1-rval44
	reshape long choice type hval pval rval, i(id) j(trial)

	*------------------------------------------------------------
	* Standardize Qualtrics type codes to paper notation
	* Raw mapping: AC -> AB, AB -> ABprime, DE -> CD
	*-----------------------------------------------------------
	gen type_new = ""
	replace type_new = "CD"            if type == "DE"
	replace type_new = "CDrepeat"      if type == "DErepeat"
	replace type_new = "ABprime"       if type == "AB"
	replace type_new = "ABprimerepeat" if type == "ABrepeat"
	replace type_new = "AB"            if type == "AC"
	replace type_new = "ABrepeat"      if type == "ACrepeat"
	drop type
	rename type_new type

	* label if part 1 or 2
	gen part = (trial>20)+1

	* Separate "choice" into valuations and binary choice
	gen valuation = choice if part == 1
	gen binary_choice = ""

	* Only define binary_choice for stage 2 rows
	replace binary_choice = "A"      if part==2 & choice == 4 & inlist(type,"AB","ABprime")
	replace binary_choice = "C"      if part==2 & choice == 4 & type=="CD"
	replace binary_choice = "B"      if part==2 & choice == 5 & type=="AB"
	replace binary_choice = "Bprime" if part==2 & choice == 5 & type=="ABprime"
	replace binary_choice = "D"      if part==2 & choice == 5 & type=="CD"

	* Label choice as risky vs safe
	replace choice = . if part == 1
	label define choice_lab 4 "Safe" 5 "Risky"
	label values choice choice_lab

	* Label the valuations (paper-aligned)
	gen h_ab      = valuation if inlist(type,"AB","ABrepeat")
	gen h_abprime = valuation if inlist(type,"ABprime","ABprimerepeat")
	gen h_cd      = valuation if inlist(type,"CD","CDrepeat")

	* Denote repeats
	gen repeat = substr(type,-6,.) == "repeat"
	replace repeat=. if part == 2

	* Order and save
	rename (rval pval hval) (r p H)
	order id trial p r valuation h_ab h_abprime h_cd binary_choice choice H part repeat type
	
	gen h = .
	replace h = h_ab      if !missing(h_ab)
	replace h = h_abprime if !missing(h_abprime)
	replace h = h_cd      if !missing(h_cd)

	* Save for later
	save "cleaned_data_long", replace

*****************************************
***** (C) Clean Part 1 Data - wide format
***************************************** 
	
	* Import the long format data
	use "cleaned_data_long", clear
	keep if part == 1
	keep responseid id trial p r valuation trial type

	* Reshape wide
	reshape wide valuation trial, i(id p r) j(type, string)

	* Rename variables (paper-aligned)
	rename (valuationAB valuationABrepeat trialAB trialABrepeat) ///
	       (h_ab h_ab_repeat trial_ab trial_ab_repeat)

	rename (valuationABprime valuationABprimerepeat trialABprime trialABprimerepeat) ///
	       (h_abprime h_abprime_repeat trial_abprime trial_abprime_repeat)

	rename (valuationCD valuationCDrepeat trialCD trialCDrepeat) ///
	       (h_cd h_cd_repeat trial_cd trial_cd_repeat)

	* Preference measures (paper-aligned; matches ExperimentData definitions)
	gen Delta_CCP = h_abprime - h_cd_repeat
	gen Delta_CRP = h_ab - h_cd
	gen Delta_MXP = h_ab_repeat - h_abprime_repeat

	* Additional Variables for analysis
	gen p_condition = round(p*100)
	gen r_condition = round(r*100)
	egen h_ab_avg      = rowmean(h_ab h_ab_repeat) 
	egen h_abprime_avg = rowmean(h_abprime h_abprime_repeat) 
	egen h_cd_avg      = rowmean(h_cd h_cd_repeat) 

	gen Delta_CRP_CCP    = Delta_CRP - Delta_CCP
	gen Delta_CCP_repeat = h_abprime_repeat - h_cd
	gen Delta_CRP_repeat = h_ab_repeat - h_cd_repeat

	*** Add definitions + export codebook CSV

	* Define variable definitions as variable labels 
	capture label var id               "Numeric row id for participant."
	capture label var p                "Probability of the H outcome in lottery B and D."
	capture label var r                "Common ratio / mixing weight parameter r."

	capture label var h_ab             "Indifference value h for AB valuation task (paper AB; raw AC)."
	capture label var trial_ab         "Round index in Qualtrics for AB valuation (paper AB; raw AC)."
	capture label var h_ab_repeat      "Indifference value h for AB valuation repeat (paper AB; raw AC)."
	capture label var trial_ab_repeat  "Trial index in Qualtrics for AB valuation repeat (paper AB; raw AC)."

	capture label var h_abprime        "Indifference value h for AB' valuation task (paper AB'; raw AB)."
	capture label var trial_abprime    "Round index in Qualtrics for AB' valuation (paper AB'; raw AB)."
	capture label var h_abprime_repeat "Indifference value h for AB' valuation repeat (paper AB'; raw AB)."
	capture label var trial_abprime_repeat "Trial index in Qualtrics for AB' valuation repeat (paper AB'; raw AB)."

	capture label var h_cd             "Indifference value h for CD valuation task (paper CD; raw DE)."
	capture label var trial_cd         "Round index in Qualtrics for CD valuation (paper CD; raw DE)."
	capture label var h_cd_repeat      "Indifference value h for CD valuation repeat (paper CD; raw DE)."
	capture label var trial_cd_repeat  "Trial index in Qualtrics for CD valuation repeat (paper CD; raw DE)."

	capture label var responseid       "Qualtrics respondent id used to merge across parts."

	* Preference measures
	capture label var Delta_CCP        "Delta_CCP = h_ABprime - h_CD_repeat (common consequence preference)."
	capture label var Delta_CRP        "Delta_CRP = h_AB - h_CD (common ratio preference)."
	capture label var Delta_MXP        "Delta_MXP = h_AB_repeat - h_ABprime_repeat (mixture preference)."

	* Convenience re-encodings and aggregates
	capture label var p_condition      "p expressed as integer percent: round(p*100)."
	capture label var r_condition      "r expressed as integer percent: round(r*100)."

	capture label var h_ab_avg         "Average of AB valuations across repeats: mean(h_ab,h_ab_repeat)."
	capture label var h_abprime_avg    "Average of AB' valuations across repeats: mean(h_abprime,h_abprime_repeat)."
	capture label var h_cd_avg         "Average of CD valuations across repeats: mean(h_cd,h_cd_repeat)."

	capture label var Delta_CRP_CCP    "Difference between CR and CC measures: Delta_CRP - Delta_CCP."
	capture label var Delta_CCP_repeat "Repeat-based CC measure: h_ABprime_repeat - h_CD."
	capture label var Delta_CRP_repeat "Repeat-based CR measure: h_AB_repeat - h_CD_repeat."

	* Export variable + definition as CSV
	tempname fh
	file open `fh' using "$cdata/part1_cleaned_definitions.csv", write replace text
	file write `fh' "variable,definition" _n

	ds
	foreach v of varlist `r(varlist)' {
		local def : variable label `v'
		if `"`def'"' == "" local def "(no definition provided)"
		local def = subinstr(`"`def'"', `"""', `"""""', .)
		file write `fh' `"`v',"`def'""' _n
	}
	file close `fh'
	
	* Save data as (p,r) pairs
	save "$cdata/part1_cleaned", replace
	outsheet using "$cdata/part1_cleaned.csv", comma replace


*****************************************
***** (D) Clean Part 2 Data 
***************************************** 

	use "cleaned_data_long", clear
	keep if part == 2
	keep responseid id binary_choice H p r type

	* Reshape
	bysort id p H: gen t = _n 
	reshape wide binary_choice type, i(id H) j(t)

	* Clean up and rename
	rename (type1 type2 binary_choice1 binary_choice2) (decision1 decision2 choice1 choice2)
	order id H p r
	sort  id H

	* Decision type (paper-aligned)
	gen decision_type = "CRE" if (decision1=="CD" & decision2=="AB") | (decision1=="AB" & decision2=="CD")
	replace decision_type = "CCE" if (decision1=="CD" & decision2=="ABprime") | (decision1=="ABprime" & decision2=="CD")
	replace decision_type = "MXE"  if (decision1=="ABprime" & decision2=="AB") | (decision1=="AB" & decision2=="ABprime")

	* Merge in stage 1 preferences (paper-aligned)
	merge m:1 id p r using "$cdata/part1_cleaned", keepusing(Delta_CCP Delta_CRP Delta_MXP h_ab h_abprime h_cd h_ab_repeat h_abprime_repeat h_cd_repeat) nogen

	***** Gen new variables

	* Generate Type of Test
	gen CRtest =  0
	replace CRtest = 1 if ((decision1 == "AB" & decision2 == "CD") | (decision1 == "CD" & decision2 == "AB"))

	gen CCtest = 0
	replace CCtest = 1 if ((decision1 == "ABprime" & decision2 == "CD") | (decision1 == "CD" & decision2 == "ABprime"))

	gen MXtest = 0
	replace MXtest = 1 if ((decision1 == "ABprime" & decision2 == "AB") | (decision1 == "AB" & decision2 == "ABprime"))

	* Is there an effect?
	gen gap = 0

	* MX test (decision types AB and ABprime; risky options are B and Bprime; safe is A)
	replace gap =  1 if MXtest == 1 & ((choice1=="Bprime" & choice2=="A") | (choice1=="A" & choice2=="Bprime"))
	replace gap = -1 if MXtest == 1 & ((choice1=="A"      & choice2=="B") | (choice1=="B" & choice2=="A"))

	* CC test (decisions ABprime and CD; safe in CD is C, risky in CD is D)
	replace gap =  1 if CCtest == 1 & ((choice1=="A" & choice2=="D") | (choice1=="D" & choice2=="A"))
	replace gap = -1 if CCtest == 1 & ((choice1=="Bprime" & choice2=="C") | (choice1=="C" & choice2=="Bprime"))

	* CR test (decisions AB and CD; safe in CD is C, risky in CD is D)
	replace gap =  1 if CRtest == 1 & ((choice1=="A" & choice2=="D") | (choice1=="D" & choice2=="A"))
	replace gap = -1 if CRtest == 1 & ((choice1=="B" & choice2=="C") | (choice1=="C" & choice2=="B"))


	* code 4 possible outcomes: both safe
	gen safesafe = 0
	replace safesafe = 1 if (choice1=="A" & inlist(choice2,"A","C")) | (choice1=="C" & choice2=="A")

	gen riskyrisky = 0
	replace riskyrisky = 1 if decision_type=="MXE"  & ((choice1=="B"      & choice2=="Bprime") | (choice1=="Bprime" & choice2=="B"))
	replace riskyrisky = 1 if decision_type=="CRE" & ((choice1=="B"      & choice2=="D")      | (choice1=="D"      & choice2=="B"))
	replace riskyrisky = 1 if decision_type=="CCE" & ((choice1=="Bprime" & choice2=="D")      | (choice1=="D"      & choice2=="Bprime"))

	* Generate Average Value 
	gen h_bar = .
	replace h_bar = (h_ab + h_cd)/2 if CRtest
	replace h_bar = (h_abprime + h_cd_repeat)/2 if CCtest
	replace h_bar = (h_ab_repeat + h_abprime_repeat)/2 if MXtest

	* Generate Distance to Indifference
	gen hdist = (1 - r)*p*(h_bar - H)

	* Rounded p and r
	gen p_condition = round(p*100)
	gen r_condition = round(r*100)
	
	    *** Add definitions + export codebook CSV (part2_cleaned)

    * Core identifiers / lottery params
    capture label var id          "Numeric row id for participant."
    capture label var responseid  "Qualtrics respondent id used to merge across parts."
    capture label var H           "High monetary outcome used in the lotteries."
    capture label var p           "Probability of the H outcome in lottery B and D."
    capture label var r           "Common ratio / mixing weight parameter r."

    * Stage-2 choices and decision labels (paper-aligned)
    capture label var decision1   "First stage-2 decision shown (AB, ABprime, or CD)."
    capture label var choice1     "Choice in decision1: A/C are safe; B/Bprime/D are risky (C safe, D risky in CD)."
    capture label var decision2   "Second stage-2 decision shown (AB, ABprime, or CD)."
    capture label var choice2     "Choice in decision2: A/C are safe; B/Bprime/D are risky (C safe, D risky in CD)."
    capture label var decision_type "Decision pair type: CRE (AB vs CD), CCE (ABprime vs CD), MXE (AB vs ABprime)."

    * Stage-1 valuations merged into part 2 (paper-aligned)
    capture label var h_ab             "Stage-1 indifference value h for AB (paper AB; raw AC)."
    capture label var h_ab_repeat      "Stage-1 indifference value h for AB repeat."
    capture label var h_abprime        "Stage-1 indifference value h for ABprime (paper AB'; raw AB)."
    capture label var h_abprime_repeat "Stage-1 indifference value h for ABprime repeat."
    capture label var h_cd             "Stage-1 indifference value h for CD (paper CD; raw DE)."
    capture label var h_cd_repeat      "Stage-1 indifference value h for CD repeat."

    * Preference measures (from part 1; used in analysis and collapse later)
    capture label var Delta_CCP "Delta_CCP = h_ABprime - h_CD_repeat (common consequence preference)."
    capture label var Delta_CRP "Delta_CRP = h_AB - h_CD (common ratio preference)."
    capture label var Delta_MXP "Delta_MXP = h_AB_repeat - h_ABprime_repeat (mixture preference)."

    * Which test is implemented by the stage-2 decision pair
    capture label var CRtest "Indicator: 1 if CR test (AB vs CD)."
    capture label var CCtest "Indicator: 1 if CC test (ABprime vs CD)."
    capture label var MXtest "Indicator: 1 if MX test (AB vs ABprime)."

    * Outcome coding from stage-2 choices
    capture label var gap "Effect indicator for the relevant test: +1 standard effect, -1 reverse effect, 0 otherwise."
    capture label var safesafe "Indicator: chose safe option in both stage-2 decisions (A with A/C, or C with A)."
    capture label var riskyrisky "Indicator: chose risky option in both stage-2 decisions (test-specific risky pair)."

    * Derived continuous measures used for distance-to-indifference
    capture label var h_bar "Average valuation used for hdist: CR=(h_ab+h_cd)/2; CC=(h_abprime+h_cd_repeat)/2; MX=(h_ab_repeat+h_abprime_repeat)/2."
    capture label var hdist "Distance-to-indifference measure: (1-r)*p*(h_bar - H)."

    * Convenience re-encodings
    capture label var p_condition "p expressed as integer percent: round(p*100)."
    capture label var r_condition "r expressed as integer percent: round(r*100)."

    * Export variable + definition as CSV
    tempname fh
    file open `fh' using "$cdata/part2_cleaned_definitions.csv", write replace text
    file write `fh' "variable,definition" _n

    ds
    foreach v of varlist `r(varlist)' {
        local def : variable label `v'
        if `"`def'"' == "" local def "(no definition provided)"
        local def = subinstr(`"`def'"', `"""', `"""""', .)
        file write `fh' `"`v',"`def'""' _n
    }
    file close `fh'

		
	* Save data
	save "$cdata/part2_cleaned", replace
	outsheet using "$cdata/part2_cleaned.csv", replace comma 


*****************************************
***** (D) Clean Demographics Data 
***************************************** 

	* Import the data
	import delimited "$rdata/demographics-anonymized.csv", varnames(1)  clear
	assert c(N) == 2100 // (i.e. missing 2)

	* Only keep necessary variables
	keep responseid timetaken totalapprovals-employmentstatus

	* Destring age
	destring age, replace force

	* Merge in comprehension Qs
	merge 1:1 responseid using compQs, nogen

	* Define variable definitions as variable labels
	label var responseid "Unique participant identifier (qualtrics)."
	label var timetaken "Time taken to complete the experiment."
	label var totalapprovals "Total number of approved Prolific submissions (platform metadata)."
	label var totalrejections "Total number of rejected Prolific submissions (platform metadata)."
	label var approvalrate "Prolific approval rate; sample required >=99%."
	label var fluentlanguages "Languages fluent in; eligibility required fluent in English."
	label var highesteducationlevelcompleted "Highest education level completed; at least high school."
	label var age "Age in years; eligibility restricted to 18-31."
	label var sex "Sex/gender category; gender-balanced recruitment."
	label var ethnicitysimplified "Simplified ethnicity category (platform metadata)."
	label var countryofbirth "Country of birth (platform metadata)."
	label var countryofresidence "Current residence; eligibility US or Western Europe (platform metadata)."
	label var nationality "Nationality (platform metadata)."
	label var language "Primary language / language of participation (platform metadata)."
	label var studentstatus "Student status (platform metadata)."
	label var employmentstatus "Employment status (platform metadata)."
	label var personpaid "Indicator selected for performance-based bonus (1 in 5 selected)."
	label var r_1 "Common ratio/mixing weight r for parameterization 1."
	label var r_2 "Common ratio/mixing weight r for parameterization 2."
	label var r_3 "Common ratio/mixing weight r for parameterization 3."
	label var r_4 "Common ratio/mixing weight r for parameterization 4."
	label var bonuspayment "Bonus amount paid (conditional on selection)."
	label var paidQ_correct "Correct on payment-mechanism quiz (pre Stage 1)."
	label var attention_correct "Passed attention check (pre Stage 1)."
	label var mpl_correct "Correct on comprehension check: MPL task."
	label var bin_correct "Correct on comprehension check: binary-choice task."
	label var both_correct "Correct on both comprehension checks."

	* Export variable definition as CSV
	tempname fh
	file open `fh' using "$cdata/demographics_definitions.csv", write replace text
	file write `fh' "variable,definition" _n

	ds
	foreach v of varlist `r(varlist)' {
		local def : variable label `v'
		* escape quotes for CSV safety
		local def = subinstr(`"`def'"', `"""', `"""""', .)
		file write `fh' `"`v',"`def'""' _n
	}
	file close `fh'

	* Save
	save "$cdata/demographics", replace
	outsheet using "$cdata/demographics.csv", replace comma 

*****************************************
***** (E) Clean Prior Literature Data 
***************************************** 

	*** i) Clean the CRE Data (Blavatskyy, et al., 2023)
	import delimited "$rdata/Published-Blat-CRE-data-2023-EE.csv", varnames(1)  clear
	
	* Lottery Parameters
	gen p =  probabilityofhighestoutcomein
	gen r = commonratio
	gen currency = substr(highestoutcome,-3,.)
	replace highestoutcome = substr(highestoutcome, 1, strlen(highestoutcome) - 4)
	destring(highestoutcome), force generate(H)
	destring(simplelottery1frequencyformat), force generate(SimpleLottery)
	destring(student1ornot0), force generate(StudentSample)
	replace H = 5000000 if highestoutcome == "5M"
	replace H = 30000000 if inlist(highestoutcome,"30M","30 M ")
	gen M =  ratioofmiddletohighestoutcome*H 
	drop highestoutcome simplelottery1frequencyformat student1ornot0
	rename real1orhypothetical0incentives real

	* Choices
	gen AD =  riskaverseeutconsistentchoice
	gen CE =  riskseekingeutconsistentchoice
	gen AE = commonratiochoicepattern
	gen CD = reversecommonratiochoicepattern

	gen CR = (AE)/(AD+CE+AE+CD)
	gen RCR = (CD)/(AD+CE+AE+CD)
	gen gap = CR-RCR

	* Experimental Parameters
	gen N = (AD+CE+AE+CD)
	gen decision_type = "CRE"
	gen prior_lit = 1

	* Rename and save
	rename (CR RCR) (effect reverse_effect)
	keep p r H M effect reverse_effect gap N real prior_lit decision_type
	save Blat_CRE_data.dta, replace

	*** ii) Clean the CCE Data (Blavatskyy, et al., 2022)
	import delimited "$rdata/Published-Blat-CCE-data-2022-AEJMicro.csv", varnames(1)  clear

	* Lottery Parameters
	gen p = probofthehighestoutcome/(probofthelowestoutcome+probofthehighestoutcome)
	gen r = probofthelowestoutcome+probofthehighestoutcome
	replace highestoutcomein2010usd = subinstr(highestoutcomein2010usd, ",", "", .)
	destring(highestoutcomein2010usd), force generate(H)
	gen M =  middlehighestoutcome*H

	* Choices
	gen ADorBE =  eutconsistentchoices*obs
	gen AE = fanningoutconsistentchoices*obs
	gen BD = fanninginconsistentchoices*obs

	gen CC = AE/(ADorBE + AE + BD)
	gen RCC = BD/(ADorBE + AE + BD)
	gen gap = CC-RCC

	* Experimental Parameters
	gen N = obs
	gen real =  (real1orhypothetical0incentives==1)
	gen decision_type = "CCE"
	gen prior_lit = 1

	* Rename and save
	rename (CC RCC) (effect reverse_effect)
	keep p r H M effect reverse_effect gap N real prior_lit decision_type
	save Blat_CCE_data, replace


	*** iii) Add in current data (stage 2)
	use "$cdata/part2_cleaned", replace

	* Generate new variables and collapse to experiment level
	gen N = 1
	gen effect = (gap==1)
	gen reverse_effect = (gap==-1)
	collapse effect reverse_effect gap Delta* hdist (sum) N, by(p_condition r_condition H decision_type)

	* Make naming consistent
	rename (p_condition r_condition) (p r)
	replace p=p/100
	replace r=r/100
	gen prior_lit = 0 
	gen real = 1
	gen M = p*30
	
	*** iv) Join all datasets

	* Append prior lit
	append using Blat_CRE_data
	append using Blat_CCE_data

	* Addition vars
	gen CCtest=(decision_type == "CCE")
	gen CRtest=(decision_type == "CRE")
	gen MXtest=(decision_type == "MXE")
	drop decision_type
	
	* ExperimentData: add definitions + export codebook CSV
	capture label var H            "High monetary outcome used in the lotteries."
	capture label var p            "Probability of the non-zero outcome in lottery B (and D)."
	capture label var r            "Common ratio scaling A,B to C,D; also mixing weight generating B' from A and B."
	capture label var effect       "Share exhibiting the standard effect for that decision type (CR/CC/MX)."
	capture label var reverse_effect "Share exhibiting the reverse effect for that decision type."
	capture label var gap          "Net effect size: effect minus reverse_effect."

	capture label var Delta_CCP    "Valuation-based common consequence preference: h_ABprime - h_CD (higher => more CCP)."
	capture label var Delta_CRP    "Valuation-based common ratio preference: h_AB - h_CD (higher => more CRP)."
	capture label var Delta_MXP    "Valuation-based mixture preference: h_AB - h_ABprime (higher => more MXP)."

	capture label var hdist        "Distance metric for valuation/indifference data."
	capture label var N            "Number of observations contributing to the experiment-level cell."
	capture label var prior_lit    "Indicator: 1 prior literature, 0 current experiment."
	capture label var real         "Indicator: 1 real (incentivized) stakes, 0 hypothetical."
	capture label var M            "Middle outcome amount used in lotteries."

	capture label var CCtest       "Indicator: 1 if CC (CCE) test."
	capture label var CRtest       "Indicator: 1 if CR (CRE) test."
	capture label var MXtest       "Indicator: 1 if MX (mixture) test."

	* Export variable + definition as CSV
	tempname fh
	file open `fh' using "$cdata/ExperimentData_definitions.csv", write replace text
	file write `fh' "variable,definition" _n

	ds
	foreach v of varlist `r(varlist)' {
		local def : variable label `v'
		if `"`def'"' == "" local def "(no definition provided)"
		* escape quotes for CSV safety
		local def = subinstr(`"`def'"', `"""', `"""""', .)
		file write `fh' `"`v',"`def'""' _n
	}
	file close `fh'


	* Save data
	save "$cdata/ExperimentData", replace
	outsheet using "$cdata/ExperimentData.csv", comma replace

	
	*** Delete temp data
	mi erase Blat_CRE_data
	mi erase Blat_CCE_data
	mi erase compQs 
	mi erase cleaned_data
