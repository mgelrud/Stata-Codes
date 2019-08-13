* Part (a)

gen dlogvalue = log(value) - log(value70)

reg dlogvalue regulated [w = pop + pop70]
	   	   
sum white70 if regulated == 1
sum white70 if regulated == 0

* Part (b)

global observables value70 income70 unemployment70 owner70 bed170-bed570 white70 pop70
	   
reg dlogvalue regulated $observables [w = pop + pop70], r

* Part (c)

gen white70_2 = white70 * white70
gen unemp70_2 = unemployment70 * unemployment70
gen bed170_2 = bed170 * bed170
gen bed270_2 = bed270 * bed270
gen bed370_2 = bed370 * bed370
gen bed470_2 = bed470 * bed470
gen bed570_2 = bed570 * bed570
gen owner70_2 = owner70 * owner70
gen income70_2 = income70 * income70
gen pop70_2 = pop70 * pop70

gen white70_3 = white70 * white70 * white70
gen unemp70_3 = unemployment70 * unemployment70 * unemployment70
gen bed170_3 = bed170 * bed170 * bed170
gen bed270_3 = bed270 * bed270 * bed270
gen bed370_3 = bed370 * bed370 * bed370
gen bed470_3 = bed470 * bed470 * bed470
gen bed570_3 = bed570 * bed570 * bed570
gen owner70_3 = owner70 * owner70 * owner70
gen income70_3 = income70 * income70 * income70
gen pop70_3 = pop70 * pop70 * pop70

gen income_white70 = white70 * income70
gen value_white70 = white70 * value70
gen unemp_white70 = white70 * unemployment70
gen owner_white70 = white70 * owner70
gen bed170_white70 = white70 * bed170
gen bed270_white70 = white70 * bed270
gen bed370_white70 = white70 * bed370
gen bed470_white70 = white70 * bed470
gen bed570_white70 = white70 * bed570
gen value_income70 = income70 * value70
gen unemp_income70 = income70 * unemployment70
gen owner_income70 = income70 * owner70
gen bed170_income70 = income70 * bed170
gen bed270_income70 = income70 * bed270
gen bed370_income70 = income70 * bed370
gen bed470_income70 = income70 * bed470
gen bed570_income70 = income70 * bed570
gen income_pop70 = pop70 * income70
gen value_pop70 = pop70 * value70
gen unemp_pop70 = pop70 * unemployment70
gen owner_pop70 = pop70 * owner70
gen bed170_pop70 = pop70 * bed170
gen bed270_pop70 = pop70 * bed270
gen bed370_pop70 = pop70 * bed370
gen bed470_pop70 = pop70 * bed470
gen bed570_pop70 = pop70 * bed570


global observables_additional pop70_3 income70_3 owner70_3 bed570_3 bed470_3 bed370_3 ///
bed270_3 bed170_3 unemp70_3 white70_3 bed570_pop70 bed470_pop70 bed370_pop70 bed270_pop70 ///
bed170_pop70 owner_pop70 unemp_pop70 value_pop70 income_pop70 pop70_2 white70_2 unemp_white70 ///
unemp70_2 income_white70 value_white70 bed370_white70 bed470_white70 bed570_white70 owner_white70 ///
bed170_white70 bed270_white70 bed170_2 bed270_2 bed370_2 bed470_2 bed570_2 owner70_2 bed170_income70 ///
owner_income70 unemp_income70 value_income70 income70_2 bed570_income70 bed470_income70 bed370_income70 bed270_income70

reg dlogvalue regulated $observables $observables_additional [w = pop + pop70], r

* Part (e)

drop prop_score num_block
pscore regulated $observables $observables_additional, pscore(prop_score) blockid(num_block)

reg dlogvalue regulated prop_score [w = pop + pop70], r

* Stratification Matching
atts dlogvalue regulated $observables $observables_additional, pscore(prop_score) blockid(num_block)

gen num_block_balanced = num_block
replace num_block_balanced = 0 if (num_block == 2 | num_block == 3 | num_block == 4 | num_block == 13)
atts dlogvalue regulated $observables $observables_additional if num_block_balanced > 0, pscore(prop_score) blockid(num_block_balanced)

xtile pscore_quintiles = prop_score, n(5)
atts dlogvalue regulated $observables $observables_additional, pscore(prop_score) blockid(pscore_quintiles)

* Nearest neighbor matching 
attnd dlogvalue regulated $observables $observables_additional, pscore(prop_score)
* Radius matching 
attr dlogvalue regulated $observables $observables_additional, pscore(prop_score) radius(0.1)
* Kernel Matching
attk dlogvalue regulated $observables $observables_additional, pscore(prop_score)

* Part (f)

gen pscore_w = prop_score / (1 - prop_score)
gen dlogvalue_w = dlogvalue
replace dlogvalue_w = dlogvalue * pscore_w if regulated == 0

reg dlogvalue_w regulated [w = pop + pop70], r

* Part (g)
xtile pscore_25 = prop_score, n(25)
sort regulated pscore_25
by regulated pscore_25: egen dlogvalue_mean_reg_25 = mean(dlogvalue)
by regulated pscore_25: egen pscore_mean_reg_25 = mean(prop_score)

twoway (line dlogvalue_mean_reg_25 pscore_mean_reg_25 if regulated == 1, color(red)) ///
	   (line dlogvalue_mean_reg_25 pscore_mean_reg_25 if regulated == 0, color(green)), ///
       legend(label(1 "Regulated") label(2 "Not Regulated")) ytitle("Mean dlogvalue") xtitle("Mean pscore") 

* Latex Regression Table

quietly eststo: reg dlogvalue regulated [w = pop + pop70], r
quietly eststo: reg dlogvalue regulated $observables [w = pop + pop70], r
quietly eststo: reg dlogvalue regulated $observables $observables_additional [w = pop + pop70], r
quietly eststo: reg dlogvalue regulated prop_score [w = pop + pop70], r
quietly eststo: reg dlogvalue_w regulated [w = pop + pop70], r
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab2}) scalars(r2)
eststo drop 1 2 3 4 5






