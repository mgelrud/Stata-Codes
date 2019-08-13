* Part (a)

global controls dwhite dblack dunemployment dincome downer dbed1-dbed5

reg dlogvalue dtsp [w = pop7080], r
reg dlogvalue dtsp $controls [w = pop7080], r

corr dlogvalue dtsp dunemployment dincome [w = pop7080]

* Part (b)

corr regulation dunemployment dincome [w = pop7080]

* Part (c)

reg dtsp regulation [w = pop7080], r
reg dtsp regulation $controls [w = pop7080], r

reg dlogvalue regulation [w = pop7080], r
reg dlogvalue regulation $controls [w = pop7080], r

ivregress 2sls dlogvalue (dtsp = regulation) [w = pop7080]
ivregress 2sls dlogvalue $controls (dtsp = regulation) [w = pop7080]

* Part (d)

ivregress 2sls dlogvalue (dtsp = tsp74) [w = pop7080]
ivregress 2sls dlogvalue $controls (dtsp = tsp74) [w = pop7080]

* Part (e)

drop dtsp_smoothed
lowess dtsp tsp74, bwidth(0.2) gen(dtsp_smoothed)

twoway lowess dtsp tsp74, bwidth(0.2) ///
	xline(75, lpattern("--")) ytitle("dtsp") xtitle("tsp74") title("bandwidth = 0.2")
	
twoway lowess dtsp tsp74, bwidth(0.8) ///
	xline(75, lpattern("--")) ytitle("dtsp") xtitle("tsp74") title("bandwidth = 0.8")

twoway (scatter dtsp tsp74, mcolor(*.6)) (lowess dtsp tsp74, bwidth(0.2)), ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dtsp") xtitle("tsp74") title("bandwidth = 0.2")

twoway (scatter dtsp tsp74, mcolor(*.6)) (lowess dtsp tsp74, bwidth(0.8)), ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dtsp") xtitle("tsp74") title("bandwidth = 0.8")
	
	
drop dlogvalue_smoothed
lowess dlogvalue tsp74, bwidth(0.2) gen(dlogvalue_smoothed)

twoway lowess dlogvalue tsp74, bwidth(0.2) ///
	xline(75, lpattern("--")) ytitle("dlogvalue") xtitle("tsp74") title("bandwidth = 0.2")

twoway lowess dlogvalue tsp74, bwidth(0.8) ///
	xline(75, lpattern("--")) ytitle("dlogvalue") xtitle("tsp74") title("bandwidth = 0.8") 	

twoway (scatter dlogvalue tsp74, mcolor(*.6)) (lowess dlogvalue tsp74, bwidth(0.2)), ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dlogvalue") xtitle("tsp74") title("bandwidth = 0.2")
	
twoway (scatter dlogvalue tsp74, mcolor(*.6)) (lowess dlogvalue tsp74, bwidth(0.8)), ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dlogvalue") xtitle("tsp74") title("bandwidth = 0.8")
		
* Part (f)	  

gen tsp74_2 = tsp74 * tsp74
gen tsp74_3 = tsp74 * tsp74 * tsp74
global tsp74_controls tsp74 tsp74_2 tsp74_3

reg dlogvalue regulation $controls $tsp74_controls, r

* Part (g)	

twoway (scatter dtsp tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), mcolor(*.6)) ///
	(lowess dtsp tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), bwidth(0.2)), by(regulation) ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dtsp") xtitle("tsp74")
	
twoway (scatter dtsp tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), mcolor(*.6)) ///
	(lowess dtsp tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), bwidth(0.8)), by(regulation) ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dtsp") xtitle("tsp74")
	 
twoway (lowess dtsp tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 0)), bwidth(0.2)) ///
	   (lowess dtsp tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 1)), bwidth(0.2)), ///
	   legend(label(1 "Not Regulated") label(2 "Regulated")) ///
	   ytitle("dtsp") xtitle("tsp74") title("bandwidth = 0.2")
	   
twoway (lowess dtsp tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 0)), bwidth(0.8)) ///
	   (lowess dtsp tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 1)), bwidth(0.8)), ///
	   legend(label(1 "Not Regulated") label(2 "Regulated")) ///
	   ytitle("dtsp") xtitle("tsp74") title("bandwidth = 0.8")	   
	
	
twoway (scatter dlogvalue tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), mcolor(*.6)) ///
	(lowess dlogvalue tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), bwidth(0.2)), by(regulation) ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dlogvalue") xtitle("tsp74")
	
twoway (scatter dlogvalue tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), mcolor(*.6)) ///
	(lowess dlogvalue tsp74 if ((tsp74 >= 50) & (tsp74 < 75)), bwidth(0.8)), by(regulation) ///
	legend(label(1 "Data") label(2 "Conditional Mean Function")) ///
	ytitle("dlogvalue") xtitle("tsp74")	
	
twoway (lowess dlogvalue tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 0)), bwidth(0.2)) ///
	   (lowess dlogvalue tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 1)), bwidth(0.2)), ///
	   legend(label(1 "Not Regulated") label(2 "Regulated")) ///
	   ytitle("dlogvalue") xtitle("tsp74") title("bandwidth = 0.2")	

twoway (lowess dlogvalue tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 0)), bwidth(0.8)) ///
	   (lowess dlogvalue tsp74  if ((tsp74 >= 50) & (tsp74 < 75) & (regulation == 1)), bwidth(0.8)), ///
	   legend(label(1 "Not Regulated") label(2 "Regulated")) ///
	   ytitle("dlogvalue") xtitle("tsp74") title("bandwidth = 0.8")

* Part (i)	

drop dtsp_ols eta_hat
reg dtsp $controls $tsp74_controls [w = pop7080]
predict dtsp_ols
gen eta_hat = dtsp - dtsp_ols
hist eta_hat
sum eta_hat

gen dwhite_2 = dwhite * dwhite
gen dblack_2 = dblack * dblack
gen dunemployment_2 = dunemployment * dunemployment
gen dincome_2 = dincome * dincome
gen downer_2 = downer * downer
gen dbed1_2 = dbed1 * dbed1
gen dbed2_2 = dbed2 * dbed2
gen dbed3_2 = dbed3 * dbed3
gen dbed4_2 = dbed4 * dbed4
gen dbed5_2 = dbed5 * dbed5

global controls_2 dwhite_2 dblack_2 dunemployment_2 dincome_2 downer_2 ///
	dbed1_2 dbed2_2 dbed3_2 dbed4_2 dbed5_2 
	
gen dwhite_dtsp = dwhite * dtsp
gen dblack_dtsp = dblack * dtsp
gen dunemployment_dtsp = dunemployment * dtsp
gen dincome_dtsp = dincome * dtsp
gen downer_dtsp = downer * dtsp
gen dbed1_dtsp = dbed1 * dtsp
gen dbed2_dtsp = dbed2 * dtsp
gen dbed3_dtsp = dbed3 * dtsp
gen dbed4_dtsp = dbed4 * dtsp
gen dbed5_dtsp = dbed5 * dtsp

global controls_dtsp dwhite_dtsp dblack_dtsp dunemployment_dtsp dincome_dtsp downer_dtsp ///
	dbed1_dtsp dbed2_dtsp dbed3_dtsp dbed4_dtsp dbed5_dtsp 

gen dtsp_2 = dtsp * dtsp
drop dtsp_eta_hat
gen dtsp_eta_hat = dtsp * eta_hat
	
reg dlogvalue dtsp $controls dtsp_2 $controls_2 $controls_dtsp eta_hat dtsp_eta_hat [w = pop7080], r
	   

* Latex Regression Tables

* Part (a)
quietly eststo: reg dlogvalue dtsp [w = pop7080], r
quietly eststo: reg dlogvalue dtsp $controls [w = pop7080], r
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab1}) scalars(r2)
eststo drop 1 2

* Part (c) and (d)
quietly eststo: reg dtsp regulation [w = pop7080], r
quietly eststo: reg dtsp regulation $controls [w = pop7080], r
quietly eststo: reg dlogvalue regulation [w = pop7080], r
quietly eststo: reg dlogvalue regulation $controls [w = pop7080], r
quietly eststo: ivregress 2sls dlogvalue (dtsp = regulation) [w = pop7080]
quietly eststo: ivregress 2sls dlogvalue $controls (dtsp = regulation) [w = pop7080]
quietly eststo: ivregress 2sls dlogvalue (dtsp = tsp74) [w = pop7080]
quietly eststo: ivregress 2sls dlogvalue $controls (dtsp = tsp74) [w = pop7080]
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab4}) scalars(r2)
eststo drop 1 2 3 4 5 6 7 8

* Part (i)	

quietly eststo: reg dtsp $controls $tsp74_controls [w = pop7080]
quietly eststo: reg dlogvalue dtsp $controls dtsp_2 $controls_2 $controls_dtsp eta_hat dtsp_eta_hat [w = pop7080], r
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab5}) scalars(r2)
eststo drop 1 2


