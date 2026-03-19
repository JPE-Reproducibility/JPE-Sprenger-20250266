/*********************************************************
 Purpose: Produces additional statistics reported in the main text
 Last edited: 01/18/2026
**********************************************************/

/**********************************************************
Stats list:
	A) Page 11 : Summary of the prior literature's findings
	B) Page 19 : Bonus payments
	C) Page 24 : Pattern frequencies (full grid)
	D) Footnote 31 : Canonical vs other parameter regions
	E) Page 25 (footnote 33) : Boundary observations in price lists
	F) Pages 26-27 (footnote 38) : Intransitive patterns
	G) Pages 26-27 : Marked patterns (posterior vs raw)
	H) Page 32 : Decomposed preference patterns (posterior vs raw)
	I) Page 33 : Risk tolerance/aversion and Proposition 2 pattern predictions
***********************************************************/


/*** A) Page 11 : Summary of the prior literature's findings
    1) "Of the 143 prior CR experiments, 48 (34%) use the Kahneman and Tversky (1979) values..."
    2) "...of the 81 prior CC experiments, 34 (42%) use the Allais (1953) values"
*/

/* 1) KT parameters */
use "$cdata/ExperimentData.dta", clear
replace p = round(p*100)
replace r = round(r*100)
gen kt = (p == 80 & r == 25) if CRtest
tab kt if prior_lit

/* 2) Allais parameters */
gen allais = (p == 91 & r == 11) if CCtest
tab allais if prior_lit


/*** B) Page 19 : Bonus payments
    1) "...the average bonus payment for selected participants was $15.76".
*/

* 1) average bonus payment
use "$cdata/demographics.dta", clear
su bonuspayment
su bonuspayment if personpaid==1


/*** C) Page 24 : Pattern frequencies (full grid)
    1) "Such observations constitute only a small fraction of the observed patterns (21.0 percent)"
    2) "Most frequent single pattern is ΔCR > 0, ΔCC < 0, and ΔMX > 0 ... 14.6 percent"
*/

use types, replace
drop if missing(pattern)

/* 1) ΔCC > 0 and ΔCR > 0 */
count if Delta_CCP > 0 & Delta_CRP > 0
di r(N)/_N*100

/* 2) ΔCR > 0, ΔCC < 0, ΔMX > 0 */
count if Delta_CRP > 0 & Delta_CCP < 0 & Delta_MXP > 0
di r(N)/_N*100


/*** D) Footnote 31 : Canonical vs other parameter regions
    1) "Near the canonical parameterizations ... ΔCR > 0 and ΔCC > 0 ... 28.9 percent"
    2) "Nonetheless ... ΔCR > 0, ΔCC < 0, and ΔMX > 0 ... 13.9 percent"
    3) "Alternatively ... (p = 0.3 or 0.5 and r = 0.1, 0.2, or 0.3), that combination constitutes 21.4 percent"
*/

* Canonical region
use types_canonical, replace
drop if missing(pattern)

/* 1) ΔCC > 0 and ΔCR > 0 */
count if Delta_CCP > 0 & Delta_CRP > 0
di r(N)/_N*100

/* 2) ΔCR > 0, ΔCC < 0, ΔMX > 0 */
count if Delta_CCP < 0 & Delta_CRP > 0 & Delta_MXP > 0
di r(N)/_N*100

* Other region
use types_other, replace
drop if missing(pattern)

/* 3) ΔCR > 0, ΔCC < 0, ΔMX > 0 */
count if Delta_CCP < 0 & Delta_CRP > 0 & Delta_MXP > 0
di r(N)/_N*100


/*** E) Page 25 (footnote 33) : Boundary observations in price lists
    1) "only approximately 10% of observations lie at the boundaries of our price lists"
*/

* 1)
use "cleaned_data_long", clear
keep if part == 1
gen h_max = 30*p + 50 + 0.5
gen h_min = 30*p - 0.5
gen hit_either = (h == h_min | h == h_max)
su hit_either


/*** F) Pages 26-27 (footnote 38) : Intransitive patterns
    1) "intransitive patterns represent 26% of overall response patterns,"
    2) "...averaging 1.9% of observations per pattern"
    3) "...and exceeding 3% in only two cases."
*/

use types, clear
drop if missing(pattern)

/* 1) Intransitive total share */
gen intransitive = inlist(pattern,5,6,9,10,15,16,18,20,22,23,28,29,32,33)
su intransitive

/* 2) Average share per intransitive pattern (14 listed patterns) */
di `r(mean)'/14*100

/* 3) Number of listed intransitive patterns with share > 3% */
gen byte listed = inlist(pattern,5,6,9,10,15,16,18,20,22,23,28,29,32,33)
count
local N = r(N)
keep if listed
contract pattern, freq(n)
gen pct = 100 * n / `N'
count if pct > 3
display "Number of listed patterns with share > 3%: " r(N)
list pattern n pct, noobs sep(0)


/*** G) Pages 26-27 : Marked patterns (posterior vs raw)
    1) "Four most prominent strict patterns ... account for approximately 73 percent of simulated preferences"
    2) "...but only 44 percent of raw responses"
    3) "The three most prominent weak patterns ... 8 percent of simulated preferences"
    4) "...and 11 percent of raw responses"
    5) "Together, the seven marked patterns account for 81 percent of simulated preferences"
    6) "...and 55 percent of raw responses"
*/

* 1) Four strict patterns: simulated (posterior)
use types_posterior, clear
gen UP_strict_patterns_star = (pattern1 | pattern3 | pattern11 | pattern27)
su UP_strict_patterns_star

* 2) Four strict patterns: raw
use types, clear
drop if missing(pattern)
gen UP_strict_patterns = inlist(pattern,1,3,11,27)
su UP_strict_patterns

* 3) Three weak patterns: simulated (posterior)
use types_posterior, clear
gen UP_weak_patterns_star = (pattern2 | pattern7 | pattern14)
su UP_weak_patterns_star

* 4) Three weak patterns: raw
use types, clear
drop if missing(pattern)
gen UP_weak_patterns = inlist(pattern,2,7,14)
su UP_weak_patterns

* 5) Seven marked patterns: simulated (posterior)
use types_posterior, replace
gen UP_patterns = (pattern1 | pattern2 | pattern3 | pattern7 | pattern11 | pattern14 | pattern27)
su UP_patterns

* 6) Seven marked patterns: raw
use types, replace
drop if missing(pattern)
gen UP_patterns = inlist(pattern,1,2,3,7,11,14,27)
su UP_patterns


/*** H) Page 32 : Decomposed preference patterns (posterior vs raw)
    1) "the seven patterns from Proposition 1 account for 81 percent of observations"
    2) "...with the other six possible patterns accounting for only 19 percent."
    3) "the seven patterns from Proposition 1 still account for 55 percent"
    4) "...with the other six possible transitive patterns accounting for only 18 percent."
*/

* 1) Seven UP patterns: simulated (posterior)
use types_posterior, replace
gen UP_patterns = (pattern1 | pattern2 | pattern3 | pattern7 | pattern11 | pattern14 | pattern27)
su UP_patterns

* 2) Other six possible patterns: simulated (posterior)
gen other_patterns = (pattern19 | pattern24 | pattern31 | pattern35 | pattern36 | pattern37)
su other_patterns

* 3) Seven UP patterns: raw
use types, replace
drop if missing(pattern)
gen UP_patterns = inlist(pattern,1,2,3,7,11,14,27)
su UP_patterns

* 4) Other six possible transitive patterns: raw
gen other_patterns = inlist(pattern,19,24,31,35,36,37)
su other_patterns


/*** I) Page 33 : Risk tolerance/aversion and Proposition 2 pattern predictions
    1) "Roughly 13 percent of observations exhibit risk tolerance"
    2) "of these, the majority (55 percent) exhibit RCRP"
    3) "The remaining 87 percent of observations exhibit risk aversion"
	4) "...of these, the majority (69 percent) exhibit CRP"
    5) "Risk aversion significantly correlated with CR preferences ... Fisher p<0.001"
    6) "we find that for risk tolerant observations ... 48% exhibit P1 ... while 21% of risk averse observations exhibit P1 ... (p < 0.001)"
    7) "In contrast for risk averse observations, 69% exhibit P2, P3, or P4 ... while 45% of risk tolerant observations exhibit
P2, P3, or P4 ... (p < 0.001)"
*/

use "$cdata/part1_cleaned", replace
merge m:1 id p_condition r_condition using posterior_valuations, nogen

* Risk attitude based on AB posterior valuation relative to M=30
gen Risk_Averse    = (p*h_ab_posterior > p*30)
gen Risk_Tolerant  = (p*h_ab_posterior < p*30)

* Preference indicators (posterior)
gen CRP = (h_ab_posterior      > h_cd_posterior)        // AB > CD
gen CCP = (h_abprime_posterior > h_cd_posterior)        // ABprime > CD
gen MXP = (h_ab_posterior      > h_abprime_posterior)   // AB > ABprime

gen P1 = (!CRP & !CCP & MXP)
gen P2 = (CRP & !CCP & MXP)
gen P3 = (CRP & CCP & MXP)
gen P4 = (CRP & CCP & !MXP)
gen P234 = (P2 | P3 | P4)

/* 1) Share risk tolerant vs risk averse */
su Risk_Tolerant 

/* 2) CRP among risk tolerant */
tab CRP if Risk_Tolerant

/* 3) Share risk averse */
su Risk_Averse

/* 4) Share risk averse */
tab CRP if Risk_Averse

/* 5) Fisher exact test: Risk_Averse x CRP */
tab Risk_Averse CRP, exact

/* 6) P1 shares + Fisher exact test */
su P1 if Risk_Averse == 0
su P1 if Risk_Averse == 1
tab Risk_Averse P1, exact

/* 7) P2|P3|P4 shares + Fisher exact test */
su P234 if Risk_Averse == 0
su P234 if Risk_Averse == 1
tab Risk_Averse P234, exact
