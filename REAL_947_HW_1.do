* Install the LaTeX package
ssc install estout, replace

* Part (a)

gen log_value = log(value)
scatter log_value tsp, msize(small)

bysort tsp: egen mean_log_value = mean(log_value)
scatter mean_log_value tsp, msize(small)

gen income2 = income * income
gen income3 = income2 * income
gen income4 = income3 * income
gen employment = 1 - unemployment
global beds "bed1 bed2 bed3 bed4 bed5"

egen pop_sum = sum(pop)
gen log_value_w = log_value * pop / pop_sum
gen tsp_w = tsp * pop / pop_sum
gen income_w = income * pop / pop_sum
gen income2_w = income_w * income_w
gen income3_w = income2_w * income_w
gen income4_w = income3_w * income_w
gen white_w = white * pop / pop_sum
gen black_w = black * pop / pop_sum
gen employment_w = employment * pop / pop_sum
gen bed1_w = bed1 * pop / pop_sum
gen bed2_w = bed2 * pop / pop_sum
gen bed3_w = bed3 * pop / pop_sum
gen bed4_w = bed4 * pop / pop_sum
gen bed5_w = bed5 * pop / pop_sum
gen bed6_w = bed6 * pop / pop_sum
global beds_w "bed1_w bed2_w bed3_w bed4_w bed5_w"
gen owner_w = owner * pop / pop_sum
scatter log_value_w tsp_w, msize(small)

bysort tsp_w: egen mean_log_value_w = mean(log_value_w)
scatter mean_log_value_w tsp_w, msize(small)

eststo: quietly reg log_value_w tsp_w
eststo: quietly reg log_value_w tsp_w income_w income2_w white_w black_w employment_w $beds_w owner_w
eststo: quietly reg log_value_w tsp_w income_w white_w black_w employment_w $beds_w owner_w
eststo: quietly reg log_value_w tsp_w income_w income2_w income3_w white_w black_w employment_w $beds_w owner_w
eststo: quietly reg log_value_w tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab1}) scalars(r2_p)
eststo drop 1 2 3 4 5

eststo: quietly reg log_value tsp
eststo: quietly reg log_value tsp income income2 white black employment $beds owner
eststo: quietly reg log_value tsp income white black employment $beds owner
eststo: quietly reg log_value tsp income income2 income3 white black employment $beds owner
eststo: quietly reg log_value tsp income income2 income3 income4 white black employment $beds owner
esttab using table2.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab2}) scalars(r2_p)
eststo drop 1 2 3 4 5

* Part (b)

egen tsp_med = median(tsp)
sum if tsp > tsp_med
sum if tsp <= tsp_med

* Part (c)

scatter value tsp, msize(small)

gen value_w = value * pop / pop_sum
scatter value_w tsp_w, msize(small)

* Part (d)

eststo: quietly reg log_value_w tsp_w, r
eststo: quietly reg log_value_w tsp_w income_w income2_w white_w black_w employment_w $beds_w owner_w, r
eststo: quietly reg log_value_w tsp_w income_w white_w black_w employment_w $beds_w owner_w, r
eststo: quietly reg log_value_w tsp_w income_w income2_w income3_w white_w black_w employment_w $beds_w owner_w, r
eststo: quietly reg log_value_w tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w, r
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab3}) scalars(r2_p)
eststo drop 1 2 3 4 5

eststo: quietly reg log_value tsp, r
eststo: quietly reg log_value tsp income income2 white black employment $beds owner, r
eststo: quietly reg log_value tsp income white black employment $beds owner, r
eststo: quietly reg log_value tsp income income2 income3 white black employment $beds owner, r
eststo: quietly reg log_value tsp income income2 income3 income4 white black employment $beds owner, r
esttab using table2.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab4}) scalars(r2_p)
eststo drop 1 2 3 4 5

* Part (e)

reg log_value_w tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w
predict log_value_resid, resid
gen log_value_resid2 = log_value_resid * log_value_resid
reg log_value_resid2 tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w
display e(r2) * e(N)

reg value_w tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w
predict value_resid, resid
gen value_resid2 = value_resid * value_resid
reg value_resid2 tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w
display e(r2) * e(N)

* Part (f)

gen county = substr(tractid, 1, 5)
eststo: quietly reg log_value_w tsp_w, cluster(county)
eststo: quietly reg log_value_w tsp_w income_w income2_w white_w black_w employment_w $beds_w owner_w, cluster(county)
eststo: quietly reg log_value_w tsp_w income_w white_w black_w employment_w $beds_w owner_w, cluster(county)
eststo: quietly reg log_value_w tsp_w income_w income2_w income3_w white_w black_w employment_w $beds_w owner_w, cluster(county)
eststo: quietly reg log_value_w tsp_w income_w income2_w income3_w income4_w white_w black_w employment_w $beds_w owner_w, cluster(county)
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab6}) scalars(r2_p)
eststo drop 1 2 3 4 5

* Part (g)

bysort county: egen log_value_county = mean(log_value)
bysort county: egen tsp_county = mean(tsp)
bysort county: egen income_county = mean(income)
bysort county: egen white_county = mean(white)
bysort county: egen black_county = mean(black)
bysort county: egen employment_county = mean(employment)
bysort county: egen bed1_county = mean(bed1)
bysort county: egen bed2_county = mean(bed2)
bysort county: egen bed3_county = mean(bed3)
bysort county: egen bed4_county = mean(bed4)
bysort county: egen bed5_county = mean(bed5)
bysort county: egen bed6_county = mean(bed6)
bysort county: egen owner_county = mean(owner)
bysort county: egen pop_county = mean(pop)

gen log_value_county_w = log_value_county * pop_county / pop_sum
gen tsp_county_w = tsp_county * pop_county / pop_sum
gen income_county_w = income_county * pop_county / pop_sum
gen income2_county_w = income_county_w * income_county_w
gen income3_county_w = income2_county_w * income_county_w
gen income4_county_w = income3_county_w * income_county_w
gen white_county_w = white_county * pop_county / pop_sum
gen black_county_w = black_county * pop_county / pop_sum
gen employment_county_w = employment_county * pop_county / pop_sum
gen bed1_county_w = bed1_county * pop_county / pop_sum
gen bed2_county_w = bed2_county * pop_county / pop_sum
gen bed3_county_w = bed3_county * pop_county / pop_sum
gen bed4_county_w = bed4_county * pop_county / pop_sum
gen bed5_county_w = bed5_county * pop_county / pop_sum
gen bed6_county_w = bed6_county * pop_county / pop_sum
global beds_county_w "bed1_county_w bed2_county_w bed3_county_w bed4_county_w bed5_county_w"
gen owner_county_w = owner_county * pop_county / pop_sum

eststo: quietly reg log_value_county_w tsp_county_w, r
eststo: quietly reg log_value_county_w tsp_county_w income_county_w income2_county_w white_county_w black_county_w employment_county_w $beds_county_w owner_county_w, r
eststo: quietly reg log_value_county_w tsp_county_w income_county_w white_county_w black_county_w employment_county_w $beds_county_w owner_county_w, r
eststo: quietly reg log_value_county_w tsp_county_w income_county_w income2_county_w income3_county_w white_county_w black_county_w employment_county_w $beds_county_w owner_county_w, r
eststo: quietly reg log_value_county_w tsp_county_w income_county_w income2_county_w income3_county_w income4_county_w white_county_w black_county_w employment_county_w $beds_county_w owner_county_w, r
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab7}) scalars(r2_p)
eststo drop 1 2 3 4 5

* Part (i)

eststo: reg log_value tsp income income2 white black unemployment owner bed1-bed6 (tsp_alt income income2 white black unemployment owner bed1-bed6) [w = pop]
esttab using table1.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab8}) scalars(r2_p)
eststo drop 1

corr tsp tsp_alt

* Part (k)

gen d_log_value = log_value - log(value70)
gen d_tsp = tsp - tsp70
gen d_income = income - income70
gen d_income2 = income2 - income70 * income70
gen d_income3 = income3 - income70 * income70 * income70
gen d_income4 = income4 - income70 * income70 * income70 * income70
gen d_white = white - white70
gen d_black = black - black70
gen d_employment = employment - 1 + unemployment70
gen d_bed1 = bed1 - bed170
gen d_bed2 = bed2 - bed270
gen d_bed3 = bed3 - bed370
gen d_bed4 = bed4 - bed470
gen d_bed5 = bed5 - bed570
gen d_bed6 = bed6 - bed670
gen d_owner = owner - owner70

eststo: quietly reg d_log_value d_tsp, noconstant
eststo: quietly reg d_log_value d_tsp d_income d_income2 d_white d_black d_employment d_bed1-d_bed5 d_owner, noconstant
eststo: quietly reg d_log_value d_tsp d_income d_white d_black d_employment d_bed1-d_bed5 d_owner, noconstant
eststo: quietly reg d_log_value d_tsp d_income d_income2 d_income3 d_white d_black d_employment d_bed1-d_bed5 d_owner, noconstant
eststo: quietly reg d_log_value d_tsp d_income d_income2 d_income3 d_income4 d_white d_black d_employment d_bed1-d_bed5 d_owner, noconstant
esttab using table2.tex, se star (* 0.1 ** 0.05 *** 0.01) label replace booktabs title(Regression table\label{tab9}) scalars(r2_p)
eststo drop 1 2 3 4 5




