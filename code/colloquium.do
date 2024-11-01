capture log close
set more off
clear all

cd "M:\My Drive\Levy MS\Graduate Programs\Recruitment\202411 Econ Sproj Colloquium"

log using colloquium.log, replace

/*
	File: colloquium.do
	Date: 2024-11-01
	Author: Thomas Masterson
	Purpose: provide guidance on the use of STATA for data management and 
			analysis for Economics Senior Project Colloquium

*/



** Import the Penn World Tables
import excel Data/pwt1001.xlsx, sheet("Data") first clear

* get some summary stats
///
su
* The previous line didn't run, because the /// ignores the new line character
su
means

* generating a table of values by group
tabstat rgdpe if country=="Ghana", by(year)

* make a frequency table
tab year

* Be careful of missing values!
gen high = rgdpo>150000
tab high

* use the mi() function to test for missing values
replace high = . if mi(rgdpo)
tab high

* Let's run a regression
use Data/mroz, clear
su

* (over-)simplified wage model
reg lwage exper expersq age educ

* In STATA, the results are saved in special macros and matrices:
eret list

* They'll be over-written unless we store the results
est store wage1

* We can use estout to make a more pleasing table 
* and combine several models' results into one table
estout wage1, ///
	cells("b(label(Coef.) fmt(%6.3f)) se(label(Std. Err.))") ///
	stats(r2_a N, fmt(%6.3f %6.0f) labels("Adj. R^2" "No. of cases")) ///
	varlabels(_cons Constant exper Experience expersq "Experience Squared" ///
				age Age educ Education ) varwidth(30) ///
	prehead("Wage determination using the Mroz data")

reg lwage exper expersq age educ city
est store wage2

* now treat city as a categorical variable with i.
reg lwage exper expersq age educ i.city
est store wage3

* Combine all three model results into one table
estout wage1 wage2 wage3, ///
	cells("b(label(Coef.) fmt(%6.3f)) se(label(Std. Err.))") ///
	stats(r2_a N, fmt(%6.3f %6.0f) labels("Adj. R^2" "No. of cases")) ///
	varlabels(_cons Constant exper Experience expersq "Experience Squared" ///
				age Age educ Education ) varwidth(30) ///
	prehead("Wage determination using the Mroz data")


log close
