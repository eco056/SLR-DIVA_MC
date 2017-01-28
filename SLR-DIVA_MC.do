*********This program assumes that GEMPACK and MATLAB are installed and the user has admin access to the C drive************ 
qui{
set more off 
noisily: display _newline(200)

noisily: di in yellow "The following analysis collects qGDP and EV, do you want to collect another result?, y/n: " _request(yvaXX)
if  "$yvaXX"=="y"{
noisily: display "(a) each of the variables has the same number of arguments, and"
noisily: display "(b) each argument of every one of the variables VAR1, VAR2, VAR3 etc is either equal to, or has as a subset, the corresponding argument in the arguments specified."
noisily: di in yellow "If you want results for several variables to appear write them in the form VAR1 [arguments] : VAR2 : VAR3 and press ENTER: " _request(MAP)
local XX=0
local MAP="$MAP"
}
else{
local XX=1
noisily: display "qGDP and EV will be collected"
}

noisily: di in yellow "Do you want to run the simulations based on the Triangular distribution?, y/n: " _request(yval2)
di "A is $yval2"
if  "$yval2"=="y"{
noisily: display _newline(200)
noisily: di in yellow "Collecting DIVA data..."
use "https://www.dropbox.com/s/x24xwd2e20q71xq/DIVA%20data%20initial.dta?dl=1", clear 
//The program gets the basic DIVA data file///
capture program drop rtriangleA
qui{
noisily: di in yellow "Please enter an identification name for the experiment" _request(MCName) as input r(MM)
noisily: display _newline(200)
local Type="$MCName"
}

qui{
noisily: di in yellow "Please enter 1 if doing the total MC or 2 if doing the decomposed MCs, if any other number is specified, the program does the decomposed MCs: " _request(MCno2) as input r(MM)
noisily: display _newline(200)
di `=$MCno2'
}
qui{
noisily: di in yellow "Please enter a number of sim replications for the TD MC: " _request(MCnoX) as input r(MM)
noisily: display _newline(200)
di `=$MCnoX'
}


scalar NO=`=$MCnoX'-1
di `=NO'
***Initally the dataset has only one observation for every variable which is the shock per percentile/parameter/region (312 in total)****
***The W and W_C are created in Excel with the Norm.dist function times(*) 21.08165 for W_L and times(*) 20.318178 for W_C, so the mean shock in 50th percentile is 10.0000***
***The W_L and W_C for the other percentiles are calculated as a ratio between the nth percantile and the 50th. e.g if the shock for land in the 5th was 5 and 10 in the
***50th the ration being 0.5 so the W_L(5th)=W_L(50th)*0.5***
qui set obs `=$MCnoX'
qui{
foreach myvar in Africa5W CAsia5W China5W EEFSU5W EastAsia5W JaKoSing5W LatinAmer5W ///
NAmerica5W NEEurope5W NWEurope5W Oceania5W SEurope5W WAsia5W Africa17W CAsia17W China17W ///
EEFSU17W EastAsia17W JaKoSing17W LatinAmer17W NAmerica17W NEEurope17W NWEurope17W ///
Oceania17W SEurope17W WAsia17W Africa50W CAsia50W China50W EEFSU50W EastAsia50W JaKoSing50W ///
LatinAmer50W NAmerica50W NEEurope50W NWEurope50W Oceania50W SEurope50W WAsia50W Africa83W CAsia83W ///
China83W EEFSU83W EastAsia83W JaKoSing83W LatinAmer83W NAmerica83W NEEurope83W NWEurope83W Oceania83W ///
SEurope83W WAsia83W Africa95W CAsia95W China95W EEFSU95W EastAsia95W JaKoSing95W LatinAmer95W NAmerica95W ///
NEEurope95W NWEurope95W Oceania95W SEurope95W WAsia95W Africa99W CAsia99W China99W EEFSU99W EastAsia99W ///
JaKoSing99W LatinAmer99W NAmerica99W NEEurope99W NWEurope99W Oceania99W SEurope99W WAsia99W Africa5L CAsia5L ///
China5L EEFSU5L EastAsia5L JaKoSing5L LatinAmer5L NAmerica5L NEEurope5L NWEurope5L Oceania5L SEurope5L WAsia5L ///
Africa17L CAsia17L China17L EEFSU17L EastAsia17L JaKoSing17L LatinAmer17L NAmerica17L NEEurope17L NWEurope17L Oceania17L ///
SEurope17L WAsia17L Africa50L CAsia50L China50L EEFSU50L EastAsia50L JaKoSing50L LatinAmer50L NAmerica50L NEEurope50L NWEurope50L ///
Oceania50L SEurope50L WAsia50L Africa83L CAsia83L China83L EEFSU83L EastAsia83L JaKoSing83L LatinAmer83L NAmerica83L NEEurope83L NWEurope83L ///
Oceania83L SEurope83L WAsia83L Africa95L CAsia95L China95L EEFSU95L EastAsia95L JaKoSing95L LatinAmer95L NAmerica95L NEEurope95L NWEurope95L ///
Oceania95L SEurope95L WAsia95L Africa99L CAsia99L China99L EEFSU99L EastAsia99L JaKoSing99L LatinAmer99L NAmerica99L NEEurope99L NWEurope99L ///
Oceania99L SEurope99L WAsia99L Africa5W_C CAsia5W_C China5W_C EEFSU5W_C EastAsia5W_C JaKoSing5W_C LatinAmer5W_C NAmerica5W_C NEEurope5W_C NWEurope5W_C ///
Oceania5W_C SEurope5W_C WAsia5W_C Africa17W_C CAsia17W_C China17W_C EEFSU17W_C EastAsia17W_C JaKoSing17W_C LatinAmer17W_C NAmerica17W_C NEEurope17W_C NWEurope17W_C ///
Oceania17W_C SEurope17W_C WAsia17W_C Africa50W_C CAsia50W_C China50W_C EEFSU50W_C EastAsia50W_C JaKoSing50W_C LatinAmer50W_C NAmerica50W_C NEEurope50W_C NWEurope50W_C ///
Oceania50W_C SEurope50W_C WAsia50W_C Africa83W_C CAsia83W_C China83W_C EEFSU83W_C EastAsia83W_C JaKoSing83W_C LatinAmer83W_C NAmerica83W_C NEEurope83W_C ///
NWEurope83W_C Oceania83W_C SEurope83W_C WAsia83W_C Africa95W_C CAsia95W_C China95W_C EEFSU95W_C EastAsia95W_C JaKoSing95W_C LatinAmer95W_C NAmerica95W_C ///
NEEurope95W_C NWEurope95W_C Oceania95W_C SEurope95W_C WAsia95W_C Africa99W_C CAsia99W_C China99W_C EEFSU99W_C EastAsia99W_C JaKoSing99W_C LatinAmer99W_C ///
NAmerica99W_C NEEurope99W_C NWEurope99W_C Oceania99W_C SEurope99W_C WAsia99W_C Africa5C CAsia5C China5C EEFSU5C EastAsia5C JaKoSing5C LatinAmer5C NAmerica5C ///
NEEurope5C NWEurope5C Oceania5C SEurope5C WAsia5C Africa17C CAsia17C China17C EEFSU17C EastAsia17C JaKoSing17C LatinAmer17C NAmerica17C NEEurope17C NWEurope17C ///
Oceania17C SEurope17C WAsia17C Africa50C CAsia50C China50C EEFSU50C EastAsia50C JaKoSing50C LatinAmer50C NAmerica50C NEEurope50C NWEurope50C Oceania50C SEurope50C ///
WAsia50C Africa83C CAsia83C China83C EEFSU83C EastAsia83C JaKoSing83C LatinAmer83C NAmerica83C NEEurope83C NWEurope83C Oceania83C SEurope83C WAsia83C Africa95C CAsia95C ///
China95C EEFSU95C EastAsia95C JaKoSing95C LatinAmer95C NAmerica95C NEEurope95C NWEurope95C Oceania95C SEurope95C WAsia95C Africa99C CAsia99C China99C EEFSU99C EastAsia99C ///
JaKoSing99C LatinAmer99C NAmerica99C NEEurope99C NWEurope99C Oceania99C SEurope99C WAsia99C {
replace `myvar' = `myvar'[_n-1] if missing(`myvar') 
///The code replicates the percantile data for reference////
}
}
qui{
noisily: di in yellow "Do you want to change the seed?, y/n: " _request(yval2)
noisily: display _newline(200) 
//The seed is pre-set but this part allows for changes////
di "A is $yval2"
if  "$yval2"=="y"{
noisily: di in yellow "Please choose a seed (any number between 0 and 2^31)?: " _request(yval3) as input r(MM)
noisily: display _newline(200)
scalar Xseed=`=$yval3'
set seed `=$yval3'
}
else{
noisily: di as error "Seed set to 18050914" 
noisily: display _newline(200)
//Inital used seed///
scalar Xseed=18050914
qui set seed 18050914 
}
*! 1.0.0 Ryan Turner plus Statalist 8 Jan 2013 rtriangleA
//Since Stata does not have a build-in function for the triangular distribution you use the following program // 
program define rtriangleA
     version 8.2
     syntax [if] [in] , GENerate(str) [a(real 0.05) b(real 0.99) c(real 0.5)]
     marksample touse
     local g "`generate'"
     gen `g' = runiform() if `touse'
quietly replace `g'=cond(`g' < (`c'-`a')/(`b'-`a'),`a'+sqrt(`g'*(`b'-`a')*(`c'-`a')),`b'-sqrt((1-`g')*(`b'-`a')*(`b'-`c')))
end

noisily: di "******Triangular distribution data generation*******" 
//For every region / variable the code will samle from the TD based on the 99th 50th and 5th percentile///
***seed Rein***
local qq=0
foreach z in W W_C L C{
foreach x in Africa	China WAsia	CAsia EastAsia JaKoSing	LatinAmer NAmerica	NEEurope NWEurope SEurope Oceania EEFSU{
scalar a=`x'99`z'
scalar b=`x'5`z'
scalar c=`x'50`z'
local qq=`qq'+1
scalar seed=`qq'+`=Xseed'
set seed `=seed'
rtriangleA, gen(`x'`z') a(`=a') b(`=b') c(`=c')
}
}


noisily: di "****New generated data need to be transforned into string so Gempack can read zeros***"
foreach x in AfricaW ChinaW WAsiaW CAsiaW EastAsiaW JaKoSingW LatinAmerW NAmericaW NEEuropeW NWEuropeW SEuropeW OceaniaW EEFSUW AfricaW_C ChinaW_C WAsiaW_C CAsiaW_C EastAsiaW_C JaKoSingW_C LatinAmerW_C NAmericaW_C NEEuropeW_C NWEuropeW_C SEuropeW_C OceaniaW_C EEFSUW_C AfricaL ChinaL WAsiaL CAsiaL EastAsiaL JaKoSingL LatinAmerL NAmericaL NEEuropeL NWEuropeL SEuropeL OceaniaL EEFSUL AfricaC ChinaC WAsiaC CAsiaC EastAsiaC JaKoSingC LatinAmerC NAmericaC NEEuropeC NWEuropeC SEuropeC OceaniaC EEFSUC{
format %12.0g `x'
tostring `x', generate(`x'i) force
replace `x'i = "-0." + substr(`x'i, 3, .) if substr(`x'i, 1, 2) == "-."
}


****Generation of separate cmf files, the idea is to be able to run n parallel runs based on the cores/threads each pc has, here 4****
****Changes directory and makes a new folder in C, admin rights are needed***

scalar kk=round(`=$MCnoX'/2)
cd C:\
capture noisily if `=$MCno2'==1 {
capture noisily mkdir "SSA_TD_Total_(`Type')", public
cd "C:\SSA_TD_Total_(`Type')"
capture noisily mkdir "CMF files Total", public
capture noisily mkdir "MC_Total_Results", public
capture noisily mkdir "CMF files Total_C_0_`=kk'", public
capture noisily mkdir "CMF files Total_L_0_`=kk'", public
capture noisily mkdir "CMF files Total_C_`=kk'_`=$MCnoX'", public
capture noisily mkdir "CMF files Total_L_`=kk'_`=$MCnoX'", public
cd "C:\SSA_TD_Total_(`Type')\CMF files Total"
gen METHOD="MC`=$MCnoX'"
gen sim_no=_n-1
save "C:\SSA_TD_Total_(`Type')\CMF files Total\DIVA data_Total`=$MCnoX'.dta"
}
capture noisily else {
capture noisily mkdir "SSA_TD_Decomposed_(`Type')", public
cd "C:\SSA_TD_Decomposed_(`Type')"
capture noisily mkdir "MC_Decomposed_Results", public
capture noisily mkdir "CMF files Decomposed", public
capture noisily mkdir "CMF files Decomposed_C_0_`=kk'", public
capture noisily mkdir "CMF files Decomposed_L_0_`=kk'", public
capture noisily mkdir "CMF files Decomposed_C_`=kk'_`=$MCnoX'", public
capture noisily mkdir "CMF files Decomposed_L_`=kk'_`=$MCnoX'", public
cd "C:\SSA_TD_Decomposed_(`Type')\CMF files Decomposed"
gen METHOD="MC`=$MCnoX'"
gen sim_no=_n-1
save "C:\SSA_TD_Decomposed_(`Type')\CMF files Decomposed\DIVA data_Decomposed`=$MCnoX'.dta"
}

scalar NO=`=$MCnoX'-1
di `=NO'
****CMF generation for the DIVA_L scenario******
if `=$MCno2'==1{
local Name="Total"
}
else {
local Name="Decomposed"
}
di "`Name'"
if `=$MCno2'==1 {
quietly {
forvalues idx=0/`=NO' {

     log using PROPL`idx'.cmf, text replace
     noisily: di "auxiliary files = gtap;"
noisily: di "Method = gragg ;"
noisily: di "steps = 2 4 6;"
noisily: di "check-on-read all = no; ! Never use this."
noisily: di "iz1 = yes;              ! Ignore zeros at step 1."
noisily: di "nds = yes;              ! Do no displays."
noisily: di "nrp = yes;              ! Don't reuse pivots."
noisily: di "CPU = yes ;"
noisily: di "file gtapsets = sets.har;"
noisily: di "file gtapparm = Default.prm;"
noisily: di "file gtapdata = BaseData.har;"
noisily: di "exogenous"
noisily: di " afall"
noisily: di "    afcom"
noisily: di "    afeall"
noisily: di "    afecom"
noisily: di "    afereg"
noisily: di "    afesec"
noisily: di "    afreg"
noisily: di "    afsec"
noisily: di "    ams"
noisily: di "    aoall"
noisily: di "    aoreg"
noisily: di "    aosec"
noisily: di "    atall !changed"
noisily: di "    atd"
noisily: di "    atf"
noisily: di "    atm"
noisily: di "    ats"
noisily: di "    au"
noisily: di "    avareg"
noisily: di "    avasec"
noisily: di "    cgdslack"
noisily: di "    dpgov"
noisily: di "    dppriv"
noisily: di "    dpsave"
noisily: di "    endwslack"
noisily: di "    incomeslack"
noisily: di "    pfactwld"
noisily: di "    pop"
noisily: di "    profitslack"
noisily: di "    psaveslack"
noisily: di "    qo(ENDW_COMM,REG)"
noisily: di "    tm"
noisily: di "    tms"
noisily: di "    to"
noisily: di "    tp"
noisily: di "    tradslack"
noisily: di "    tx"
noisily: di "    txs"
noisily: di ";"
noisily: di "Rest Endogenous ;"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Africa""'") = uniform " AfricaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"China""'") = uniform "   ChinaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"WAsia""'") = uniform "   WAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"CAsia""'") = uniform "   CAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EastAsia""'") = uniform "   EastAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"JaKoSing""'") = uniform "   JaKoSingWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"LatinAmer""'") = uniform "   LatinAmerWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NAmerica""'") = uniform "   NAmericaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NEEurope""'") = uniform "   NEEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NWEurope""'") = uniform "   NWEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"SEurope""'") = uniform "   SEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Oceania""'") = uniform "  OceaniaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EEFSU""'") = uniform "   EEFSUWi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Africa""'") = uniform "   AfricaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","China""'") = uniform "   ChinaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","WAsia""'") = uniform "   WAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","CAsia""'") = uniform "   CAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EastAsia""'") = uniform "   EastAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","JaKoSing""'") = uniform "   JaKoSingCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","LatinAmer""'") = uniform "   LatinAmerCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NAmerica""'") = uniform "   NAmericaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NEEurope""'") = uniform "   NEEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NWEurope""'") = uniform "   NWEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","SEurope""'") = uniform "   SEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Oceania""'") = uniform "   OceaniaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EEFSU""'") = uniform "   EEFSUCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Africa""'") = uniform "   AfricaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","China""'") = uniform "   ChinaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","WAsia""'") = uniform "   WAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","CAsia""'") = uniform "   CAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EastAsia""'") = uniform "   EastAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","JaKoSing""'") = uniform "   JaKoSingLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","LatinAmer""'") = uniform "   LatinAmerLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NAmerica""'") = uniform "   NAmericaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NEEurope""'") = uniform "   NEEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NWEurope""'") = uniform "   NWEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","SEurope""'") = uniform "   SEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Oceania""'") = uniform "   OceaniaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EEFSU""'") = uniform "   EEFSULi[_n+`idx']  ";"
noisily: di "model               = Co-GEM ;"
noisily: di "version             = 0     ;"
noisily: di "identifier          = TIME  ;"
noisily: di "verbal description  = Qw. ;"
noisily: di "Solution file = PROPL`idx';"
noisily: di "updated file gtapdata = PROPL`idx'.har;"
noisily: di "extrapolation accuracy file = NO;"
     log close
}
}

****CMF generation for the DIVA_C scenario******
quietly {
forvalues idx=0/`=NO' {
     log using PROPC`idx'.cmf, text replace
     noisily: di "auxiliary files = gtap;"
noisily: di "Method = gragg ;"
noisily: di "steps = 2 4 6;"
noisily: di "check-on-read all = no; ! Never use this."
noisily: di "iz1 = yes;              ! Ignore zeros at step 1."
noisily: di "nds = yes;              ! Do no displays."
noisily: di "nrp = yes;              ! Don't reuse pivots."
noisily: di "CPU = yes ;"
noisily: di "file gtapsets = sets.har;"
noisily: di "file gtapparm = Default.prm;"
noisily: di "file gtapdata = BaseData.har;"
noisily: di "exogenous"
noisily: di " afall"
noisily: di "    afcom"
noisily: di "    afeall"
noisily: di "    afecom"
noisily: di "    afereg"
noisily: di "    afesec"
noisily: di "    afreg"
noisily: di "    afsec"
noisily: di "    ams"
noisily: di "    aoall"
noisily: di "    aoreg"
noisily: di "    aosec"
noisily: di "    atall !changed"
noisily: di "    atd"
noisily: di "    atf"
noisily: di "    atm"
noisily: di "    ats"
noisily: di "    au"
noisily: di "    avareg"
noisily: di "    avasec"
noisily: di "    cgdslack"
noisily: di "    dpgov"
noisily: di "    dppriv"
noisily: di "    dpsave"
noisily: di "    endwslack"
noisily: di "    incomeslack"
noisily: di "    pfactwld"
noisily: di "    pop"
noisily: di "    profitslack"
noisily: di "    psaveslack"
noisily: di "    qo(ENDW_COMM,REG)"
noisily: di "    tm"
noisily: di "    tms"
noisily: di "    to"
noisily: di "    tp"
noisily: di "    tradslack"
noisily: di "    tx"
noisily: di "    txs"
noisily: di ";"
noisily: di "Rest Endogenous ;"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Africa""'") = uniform " AfricaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"China""'") = uniform "   ChinaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"WAsia""'") = uniform "   WAsiaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"CAsia""'") = uniform "   CAsiaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EastAsia""'") = uniform "   EastAsiaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"JaKoSing""'") = uniform "   JaKoSingW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"LatinAmer""'") = uniform "   LatinAmerW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NAmerica""'") = uniform "   NAmericaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NEEurope""'") = uniform "   NEEuropeW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NWEurope""'") = uniform "   NWEuropeW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"SEurope""'") = uniform "   SEuropeW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Oceania""'") = uniform "  OceaniaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EEFSU""'") = uniform "   EEFSUW_Ci[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Africa""'") = uniform "   AfricaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","China""'") = uniform "   ChinaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","WAsia""'") = uniform "   WAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","CAsia""'") = uniform "   CAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EastAsia""'") = uniform "   EastAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","JaKoSing""'") = uniform "   JaKoSingCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","LatinAmer""'") = uniform "   LatinAmerCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NAmerica""'") = uniform "   NAmericaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NEEurope""'") = uniform "   NEEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NWEurope""'") = uniform "   NWEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","SEurope""'") = uniform "   SEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Oceania""'") = uniform "   OceaniaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EEFSU""'") = uniform "   EEFSUCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Africa""'") = uniform "   AfricaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","China""'") = uniform "   ChinaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","WAsia""'") = uniform "   WAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","CAsia""'") = uniform "   CAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EastAsia""'") = uniform "   EastAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","JaKoSing""'") = uniform "   JaKoSingLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","LatinAmer""'") = uniform "   LatinAmerLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NAmerica""'") = uniform "   NAmericaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NEEurope""'") = uniform "   NEEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NWEurope""'") = uniform "   NWEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","SEurope""'") = uniform "   SEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Oceania""'") = uniform "   OceaniaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EEFSU""'") = uniform "   EEFSULi[_n+`idx']  ";"
noisily: di "model               = Co-GEM ;"
noisily: di "version             = 0     ;"
noisily: di "identifier          = TIME  ;"
noisily: di "verbal description  = Qw. ;"
noisily: di "Solution file = PROPC`idx';"
noisily: di "updated file gtapdata = PROPC`idx'.har;"
noisily: di "extrapolation accuracy file = NO;"
     log close
}
}
}
****CMF generation for the DIVA_L scenario for the decomposed MC******
else {
quietly {
foreach x in L C W {
forvalues idx=0/`=NO' {

     log using PROPL_`x'`idx'.cmf, text replace
     noisily: di "auxiliary files = gtap;"
noisily: di "Method = gragg ;"
noisily: di "steps = 2 4 6;"
noisily: di "check-on-read all = no; ! Never use this."
noisily: di "iz1 = yes;              ! Ignore zeros at step 1."
noisily: di "nds = yes;              ! Do no displays."
noisily: di "nrp = yes;              ! Don't reuse pivots."
noisily: di "CPU = yes ;"
noisily: di "file gtapsets = sets.har;"
noisily: di "file gtapparm = Default.prm;"
noisily: di "file gtapdata = BaseData.har;"
noisily: di "exogenous"
noisily: di " afall"
noisily: di "    afcom"
noisily: di "    afeall"
noisily: di "    afecom"
noisily: di "    afereg"
noisily: di "    afesec"
noisily: di "    afreg"
noisily: di "    afsec"
noisily: di "    ams"
noisily: di "    aoall"
noisily: di "    aoreg"
noisily: di "    aosec"
noisily: di "    atall !changed"
noisily: di "    atd"
noisily: di "    atf"
noisily: di "    atm"
noisily: di "    ats"
noisily: di "    au"
noisily: di "    avareg"
noisily: di "    avasec"
noisily: di "    cgdslack"
noisily: di "    dpgov"
noisily: di "    dppriv"
noisily: di "    dpsave"
noisily: di "    endwslack"
noisily: di "    incomeslack"
noisily: di "    pfactwld"
noisily: di "    pop"
noisily: di "    profitslack"
noisily: di "    psaveslack"
noisily: di "    qo(ENDW_COMM,REG)"
noisily: di "    tm"
noisily: di "    tms"
noisily: di "    to"
noisily: di "    tp"
noisily: di "    tradslack"
noisily: di "    tx"
noisily: di "    txs"
noisily: di ";"
noisily: di "Rest Endogenous ;"
if "`x'"=="W" {
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Africa""'") = uniform " AfricaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"China""'") = uniform "   ChinaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"WAsia""'") = uniform "   WAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"CAsia""'") = uniform "   CAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EastAsia""'") = uniform "   EastAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"JaKoSing""'") = uniform "   JaKoSingWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"LatinAmer""'") = uniform "   LatinAmerWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NAmerica""'") = uniform "   NAmericaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NEEurope""'") = uniform "   NEEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NWEurope""'") = uniform "   NWEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"SEurope""'") = uniform "   SEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Oceania""'") = uniform "  OceaniaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EEFSU""'") = uniform "   EEFSUWi[_n+`idx']  ";"
}
else if "`x'"=="C" {
noisily: di "Shock qo("`""Capital","Africa""'") = uniform "   AfricaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","China""'") = uniform "   ChinaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","WAsia""'") = uniform "   WAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","CAsia""'") = uniform "   CAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EastAsia""'") = uniform "   EastAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","JaKoSing""'") = uniform "   JaKoSingCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","LatinAmer""'") = uniform "   LatinAmerCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NAmerica""'") = uniform "   NAmericaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NEEurope""'") = uniform "   NEEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NWEurope""'") = uniform "   NWEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","SEurope""'") = uniform "   SEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Oceania""'") = uniform "   OceaniaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EEFSU""'") = uniform "   EEFSUCi[_n+`idx']  ";"
}
else {
noisily: di "Shock qo("`""Land","Africa""'") = uniform "   AfricaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","China""'") = uniform "   ChinaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","WAsia""'") = uniform "   WAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","CAsia""'") = uniform "   CAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EastAsia""'") = uniform "   EastAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","JaKoSing""'") = uniform "   JaKoSingLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","LatinAmer""'") = uniform "   LatinAmerLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NAmerica""'") = uniform "   NAmericaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NEEurope""'") = uniform "   NEEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NWEurope""'") = uniform "   NWEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","SEurope""'") = uniform "   SEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Oceania""'") = uniform "   OceaniaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EEFSU""'") = uniform "   EEFSULi[_n+`idx']  ";"
}
noisily: di "model               = Co-GEM ;"
noisily: di "version             = 0     ;"
noisily: di "identifier          = TIME  ;"
noisily: di "verbal description  = Qw. ;"
noisily: di "Solution file = PROPL_`x'`idx';"
noisily: di "updated file gtapdata = PROPL_`x'`idx'.har;"
noisily: di "extrapolation accuracy file = NO;"
     log close
}
}
}

****CMF generation for the DIVA_C scenario for the decomposed MC******
quietly {
foreach x in L C W {
forvalues idx=0/`=NO' {
     log using PROPC_`x'`idx'.cmf, text replace
     noisily: di "auxiliary files = gtap;"
noisily: di "Method = gragg ;"
noisily: di "steps = 2 4 6;"
noisily: di "check-on-read all = no; ! Never use this."
noisily: di "iz1 = yes;              ! Ignore zeros at step 1."
noisily: di "nds = yes;              ! Do no displays."
noisily: di "nrp = yes;              ! Don't reuse pivots."
noisily: di "CPU = yes ;"
noisily: di "file gtapsets = sets.har;"
noisily: di "file gtapparm = Default.prm;"
noisily: di "file gtapdata = BaseData.har;"
noisily: di "exogenous"
noisily: di " afall"
noisily: di "    afcom"
noisily: di "    afeall"
noisily: di "    afecom"
noisily: di "    afereg"
noisily: di "    afesec"
noisily: di "    afreg"
noisily: di "    afsec"
noisily: di "    ams"
noisily: di "    aoall"
noisily: di "    aoreg"
noisily: di "    aosec"
noisily: di "    atall !changed"
noisily: di "    atd"
noisily: di "    atf"
noisily: di "    atm"
noisily: di "    ats"
noisily: di "    au"
noisily: di "    avareg"
noisily: di "    avasec"
noisily: di "    cgdslack"
noisily: di "    dpgov"
noisily: di "    dppriv"
noisily: di "    dpsave"
noisily: di "    endwslack"
noisily: di "    incomeslack"
noisily: di "    pfactwld"
noisily: di "    pop"
noisily: di "    profitslack"
noisily: di "    psaveslack"
noisily: di "    qo(ENDW_COMM,REG)"
noisily: di "    tm"
noisily: di "    tms"
noisily: di "    to"
noisily: di "    tp"
noisily: di "    tradslack"
noisily: di "    tx"
noisily: di "    txs"
noisily: di ";"
noisily: di "Rest Endogenous ;"
if "`x'"=="W" {
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Africa""'") = uniform " AfricaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"China""'") = uniform "   ChinaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"WAsia""'") = uniform "   WAsiaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"CAsia""'") = uniform "   CAsiaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EastAsia""'") = uniform "   EastAsiaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"JaKoSing""'") = uniform "   JaKoSingW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"LatinAmer""'") = uniform "   LatinAmerW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NAmerica""'") = uniform "   NAmericaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NEEurope""'") = uniform "   NEEuropeW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NWEurope""'") = uniform "   NWEuropeW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"SEurope""'") = uniform "   SEuropeW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Oceania""'") = uniform "  OceaniaW_Ci[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EEFSU""'") = uniform "   EEFSUW_Ci[_n+`idx']  ";"
}
else if "`x'"=="C" {
noisily: di "Shock qo("`""Capital","Africa""'") = uniform "   AfricaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","China""'") = uniform "   ChinaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","WAsia""'") = uniform "   WAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","CAsia""'") = uniform "   CAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EastAsia""'") = uniform "   EastAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","JaKoSing""'") = uniform "   JaKoSingCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","LatinAmer""'") = uniform "   LatinAmerCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NAmerica""'") = uniform "   NAmericaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NEEurope""'") = uniform "   NEEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NWEurope""'") = uniform "   NWEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","SEurope""'") = uniform "   SEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Oceania""'") = uniform "   OceaniaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EEFSU""'") = uniform "   EEFSUCi[_n+`idx']  ";"
}
else {
noisily: di "Shock qo("`""Land","Africa""'") = uniform "   AfricaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","China""'") = uniform "   ChinaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","WAsia""'") = uniform "   WAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","CAsia""'") = uniform "   CAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EastAsia""'") = uniform "   EastAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","JaKoSing""'") = uniform "   JaKoSingLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","LatinAmer""'") = uniform "   LatinAmerLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NAmerica""'") = uniform "   NAmericaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NEEurope""'") = uniform "   NEEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NWEurope""'") = uniform "   NWEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","SEurope""'") = uniform "   SEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Oceania""'") = uniform "   OceaniaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EEFSU""'") = uniform "   EEFSULi[_n+`idx']  ";"
}
noisily: di "model               = Co-GEM ;"
noisily: di "version             = 0     ;"
noisily: di "identifier          = TIME  ;"
noisily: di "verbal description  = Qw. ;"
noisily: di "Solution file = PROPC_`x'`idx';"
noisily: di "updated file gtapdata = PROPC_`x'`idx'.har;"
noisily: di "extrapolation accuracy file = NO;"
     log close
}
}
}
}
if `=$MCno2'==1{
local Name="Total"
local f=1
}
else {
local Name="Decomposed"
local f=3
}


scalar k=round(`=$MCnoX'*`f'+5)
scalar zz=round(`=$MCnoX'-1)
scalar zz2=round(`=$MCnoX'*`f'/2)
scalar zz3=`zz2'+1
scalar kk=round(`=$MCnoX'/2)
if `=$MCno2'==1{
local Name="Total"
}
else {
local Name="Decomposed"
}

di "`=k' `=zz' `=zz2'"
*****Create the Batch files for the runs*****
if `=$MCno2'==1{
scalar xx=round(`=$MCnoX'*`f'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
quietly {
log using PROPC_RUN_1.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_C_0_`=kk'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=0/`=zz2'{
noisily: di "gemsim -cmf " "PROPC`idx'.cmf" 
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPC*.har"
noisily: di "del PROPC*.slc"
forvalues idx=0/`=zz2'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPC`idx' PROPC`idx'.csv"
}
noisily: di "copy PROPC*.csv ALL_C1.csv"
log close
}
quietly {
log using PROPC_RUN_2.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_C_`=kk'_`=$MCnoX'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=`=zz3'/`=xx'{
noisily: di "gemsim -cmf " "PROPC`idx'.cmf" 
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPC*.har"
noisily: di "del PROPC*.slc"
forvalues idx=`=zz3'/`=xx'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPC`idx' PROPC`idx'.csv"
}
noisily: di "copy PROPC*.csv ALL_C2.csv"
log close
}

****BAT generation for the DIVA_L scenario******
clear
quietly {
log using PROPL_RUN_1.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_L_0_`=kk'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=0/`=zz2'{
noisily: di "gemsim -cmf " "PROPL`idx'.cmf" 
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPL*.har"
noisily: di "del PROPL*.slc"
forvalues idx=0/`=zz2'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPL`idx' PROPL`idx'.csv"
}
noisily: di "copy PROPL*.csv ALL_L1.csv"
log close
}

quietly {
log using PROPL_RUN_2.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_L_`=kk'_`=$MCnoX'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=`=zz3'/`=xx'{
noisily: di "gemsim -cmf " "PROPL`idx'.cmf" 
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPL*.har"
noisily: di "del PROPL*.slc"
forvalues idx=`=zz3'/`=xx'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPL`idx' PROPL`idx'.csv"
}
noisily: di "copy PROPL*.csv ALL_L2.csv"
log close
}
}
****BAT generation for the for the decomposed MC******

else {
scalar xx=round(`=$MCnoX'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
quietly {
log using PROPC_RUN_1.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_C_0_`=kk'""'"
noisily: di "tablo -sti gtap2.sti"
foreach x1 in L C W {
forvalues idx=0/`=zz2'{
noisily: di "gemsim -cmf " "PROPC_`x1'`idx'.cmf" 
}
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPC*.har"
noisily: di "del PROPC*.slc"
foreach x1 in L C W {
forvalues idx=0/`=zz2'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPC_`x1'`idx' PROPC_`x1'`idx'.csv"
}
}
noisily: di "copy PROPC*.csv ALL_C1.csv"
log close
}
quietly {
log using PROPC_RUN_2.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_C_`=kk'_`=$MCnoX'""'"
noisily: di "tablo -sti gtap2.sti"
foreach x1 in L C W {
forvalues idx=`=zz3'/`=xx'{
noisily: di "gemsim -cmf " "PROPC_`x1'`idx'.cmf" 
}
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPC*.har"
noisily: di "del PROPC*.slc"
foreach x1 in L C W {
forvalues idx=`=zz3'/`=xx'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPC_`x1'`idx' PROPC_`x1'`idx'.csv"
}
}
noisily: di "copy PROPC*.csv ALL_C2.csv"
log close
}


clear
quietly {
log using PROPL_RUN_1.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_L_0_`=kk'""'"
noisily: di "tablo -sti gtap2.sti"
foreach x1 in L C W {
forvalues idx=0/`=zz2'{
noisily: di "gemsim -cmf " "PROPL_`x1'`idx'.cmf" 
}
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPL*.har"
noisily: di "del PROPL*.slc"
foreach x1 in L C W {
forvalues idx=0/`=zz2'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPL_`x1'`idx' PROPL_`x1'`idx'.csv"
}
}
noisily: di "copy PROPL*.csv ALL_L1.csv"
log close
}

quietly {
log using PROPL_RUN_2.bat, text replace
noisily: di "cd "`""C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_L_`=kk'_`=$MCnoX'""'"
noisily: di "tablo -sti gtap2.sti"
foreach x1 in L C W {
forvalues idx=`=zz3'/`=xx'{
noisily: di "gemsim -cmf " "PROPL_`x1'`idx'.cmf" 
}
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPL*.har"
noisily: di "del PROPL*.slc"
foreach x1 in L C W {
forvalues idx=`=zz3'/`=xx'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPL_`x1'`idx' PROPL_`x1'`idx'.csv"
}
}
noisily: di "copy PROPL*.csv ALL_L2.csv"
log close
}
}


if `=$MCno2'==1{
local Name="Total"
local f=1
}
else {
local Name="Decomposed"
local f=3
}

if `XX'==1{
log using EV.map, text replace
noisily: di "qgdp : EV"
log close
}
else{
log using EV.map, text replace
noisily: di "`MAP'"
log close
}
noisily: display _newline(200)

noisily: display "Please wait for the GTAP data collection..."
scalar k=round(`=$MCnoX'*`f'+5)
scalar zz=round(`=$MCnoX'-1)
scalar zz2=round(`=$MCnoX'*`f'/2)
scalar zz3=`zz2'+1
scalar kk=round(`=$MCnoX'/2)

*********Moving files to the folders for the simulations *********
if `=$MCno2'==1{
****Moving files for TOTAL MC******
foreach x in L C{
****First half******
scalar xx=round(`=$MCnoX'*`f'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
forvalues idx=0/`=zz2'{
capture copy PROP`x'`idx'.cmf "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/PROP`x'`idx'.cmf", replace
}
copy EV.map "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/EV.map", replace
copy "https://www.dropbox.com/s/0s34plns1vilzos/BaseData.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/BaseData.har", replace
copy "https://www.dropbox.com/s/gssvxlfenwj4m01/Sets.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/Sets.har", replace
copy "https://www.dropbox.com/s/sqgtiyuwjap84yt/Default.prm?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/Default.prm", replace
copy "https://www.dropbox.com/s/m8sqmayvn1jwi1l/gtap2.sti?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/gtap2.sti", replace
copy "https://www.dropbox.com/s/m0f481ml7r0hvx1/gtap.tab?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/gtap.tab", replace
copy PROP`x'_RUN_1.bat "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/PROP`x'_RUN_1.bat", replace
}

foreach x in L C{
****Second half******
scalar xx=round(`=$MCnoX'*`f'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
forvalues idx=`=zz3'/`=xx'{
capture copy PROP`x'`idx'.cmf "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/PROP`x'`idx'.cmf", replace
}
copy EV.map "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/EV.map", replace
copy "https://www.dropbox.com/s/0s34plns1vilzos/BaseData.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/BaseData.har", replace
copy "https://www.dropbox.com/s/gssvxlfenwj4m01/Sets.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/Sets.har", replace
copy "https://www.dropbox.com/s/sqgtiyuwjap84yt/Default.prm?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/Default.prm", replace
copy "https://www.dropbox.com/s/m8sqmayvn1jwi1l/gtap2.sti?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/gtap2.sti", replace
copy "https://www.dropbox.com/s/m0f481ml7r0hvx1/gtap.tab?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/gtap.tab", replace
copy PROP`x'_RUN_2.bat "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/PROP`x'_RUN_2.bat", replace
}
qui{
log using Check.bat, text replace
noisily: display "cd "`""C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_C_0_`=kk'""'"
noisily: display "@echo off"
noisily: display "setlocal enableextensions"
noisily: display ":loop"
noisily: display "set x=0"
noisily: display "set y=`=zz3'+1"
noisily: display "for %%x in (*.sl4) do set /a x+=1"
noisily: display "set /a z=100*x/y"
noisily: display "echo %z% %% is done%"
noisily: display "if %z% gtr 95 ("
noisily: display "        exit /b"
noisily: display "      )"
noisily: display "timeout /t 30"
noisily: display "endlocal"
noisily: display "goto loop"
log close
copy Check.bat "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_C_0_`=kk'/Check.bat", replace
}
}

else {
****Moving files for Decomposed MC******
foreach x in L C{
****First half******
foreach x1 in L C W {
scalar xx=round(`=$MCnoX'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
forvalues idx=0/`=zz2'{
capture copy PROP`x'_`x1'`idx'.cmf "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/PROP`x'_`x1'`idx'.cmf", replace
}
}
copy EV.map "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/EV.map", replace
copy "https://www.dropbox.com/s/0s34plns1vilzos/BaseData.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/BaseData.har", replace
copy "https://www.dropbox.com/s/gssvxlfenwj4m01/Sets.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/Sets.har", replace
copy "https://www.dropbox.com/s/sqgtiyuwjap84yt/Default.prm?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/Default.prm", replace
copy "https://www.dropbox.com/s/m8sqmayvn1jwi1l/gtap2.sti?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/gtap2.sti", replace
copy "https://www.dropbox.com/s/m0f481ml7r0hvx1/gtap.tab?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/gtap.tab", replace
copy PROP`x'_RUN_1.bat "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_0_`=kk'/PROP`x'_RUN_1.bat", replace
}

foreach x in L C{
****Second half******
foreach x1 in L C W {
scalar xx=round(`=$MCnoX'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
forvalues idx=`=zz3'/`=xx'{
capture copy PROP`x'_`x1'`idx'.cmf "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/PROP`x'_`x1'`idx'.cmf", replace
}
}
copy EV.map "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/EV.map", replace
copy "https://www.dropbox.com/s/0s34plns1vilzos/BaseData.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/BaseData.har", replace
copy "https://www.dropbox.com/s/gssvxlfenwj4m01/Sets.har?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/Sets.har", replace
copy "https://www.dropbox.com/s/sqgtiyuwjap84yt/Default.prm?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/Default.prm", replace
copy "https://www.dropbox.com/s/m8sqmayvn1jwi1l/gtap2.sti?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/gtap2.sti", replace
copy "https://www.dropbox.com/s/m0f481ml7r0hvx1/gtap.tab?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/gtap.tab", replace
copy PROP`x'_RUN_2.bat "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_`x'_`=kk'_`=$MCnoX'/PROP`x'_RUN_2.bat", replace
}
qui{
log using Check.bat, text replace
noisily: display "cd "`""C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_C_0_`=kk'""'"
noisily: display "@echo off"
noisily: display "setlocal enableextensions"
noisily: display ":loop"
noisily: display "set x=0"
noisily: display "set y=`=zz3'"
noisily: display "for %%x in (*.sl4) do set /a x+=1"
noisily: display "set /a z=100*x/y"
noisily: display "echo %z% %% is done%"
noisily: display "if %z% gtr 95 ("
noisily: display "        exit /b"
noisily: display "      )"
noisily: display "timeout /t 15"
noisily: display "endlocal"
noisily: display "goto loop"
log close
copy Check.bat "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_C_0_`=kk'/Check.bat", replace
}
}

//delete the cmf files from the total folder since they are moved///
shell del *.cmf 
cd C:\
//Bat that reads cores/nodes and run the simulations accordingly///
copy "https://www.dropbox.com/s/qardmu50gsy0jql/Run.bat?dl=1" "C:/SSA_TD_`Name'_(`Type')/CMF files `Name'/Run.bat", replace
cd "C:\SSA_TD_`Name'_(`Type')\CMF files `Name'"

noisily: display _newline(200)

qui{
noisily: di in yellow "Do you want to run the simulations, y/n: " _request(yval)
di "A is $yval"
if  "$yval"=="y"{
	noisily: di "Running simulations...It might take several hours depending on the number of simulations specified"
	//Timing of the simulations///
	capture timer clear 1
	timer on 1
	shell Run.bat
	timer off 1
	timer list 1
	scalar hours=int(`r(t1)'/3600)
	scalar remainder=int(`r(t1)'-`=hours' *3600)
	scalar mins=int(`=remainder'/60)
	scalar remainder=(`=remainder'-`=mins'*60)
	scalar sec=`=remainder'
    
	noisily: di "Running time was `=hours' hours, `=mins' minutes and `=sec' seconds"
//Collecting data into two files one for DIVA_C and one for DIVA_L///
cd "C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_C_`=kk'_`=$MCnoX'"
shell copy propc*.csv "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_C2.csv"
cd "C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_L_`=kk'_`=$MCnoX'"
shell copy propl*.csv "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_L2.csv"
cd "C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_C_0_`=kk'"
shell copy propc*.csv "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_C1.csv"
cd "C:\SSA_TD_`Name'_(`Type')\CMF files `Name'_L_0_`=kk'"
shell copy propl*.csv "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_L1.csv"
cd "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results"
shell copy ALL_L*.csv "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_L.csv"
shell copy ALL_C*.csv "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_C.csv"
///Clean the data into a readable format for Total///
if `=$MCno2'==1{

import delimited "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_C.csv", clear 
rename v1 Region
rename v2 qGDPa
rename v3 HEV
gen SIM="PROPC"
gen sim_no=qGDPa
drop if Region=="             "
split sim_no, parse(c)
drop sim_no1
destring sim_no2, replace
destring qGDPa, generate(qGDP) ignore(`"propc"')
drop qGDPa sim_no v4
rename sim_no2 sim_no
replace sim_no=sim_no[_n-1] if sim_no==.
drop if HEV==""
destring qGDP HEV, replace
gen Method="TD"
save DIVA_C_`Name'_`Type'_`=$MCnoX'runs.dta, replace

import delimited "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_L.csv", clear 
rename v1 Region
rename v2 qGDPa
rename v3 HEV
gen SIM="PROPL"
gen sim_no=qGDPa
drop if Region=="             "
split sim_no, parse(l)
drop sim_no1
destring sim_no2, replace
destring qGDPa, generate(qGDP) ignore(`"propl"')
drop qGDPa sim_no v4
rename sim_no2 sim_no
replace sim_no=sim_no[_n-1] if sim_no==.
drop if HEV==""
destring qGDP HEV, replace
gen Method="TD"
save DIVA_L_`Name'_`Type'_`=$MCnoX'runs.dta, replace
}
else {
///Clean the data into a readable format for Decomposed///
import delimited "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_C.csv", clear 
rename v1 Region
rename v2 qGDPa
rename v3 HEV
gen SIM="PROPC"
gen sim_no=qGDPa
drop if Region=="             "
split sim_no, parse(_)
drop sim_no1
split sim_no2
destring sim_no21, ignore(`"clw"') replace
gen Parameter = regexs(0) if regexm(sim_no2, "[a-zA-Z]+")
replace Parameter=Parameter[_n-1] if Parameter==""
destring qGDPa, generate(qGDP) ignore(`"propclw_"')
drop qGDPa sim_no v4 sim_no2
rename sim_no21 sim_no
replace sim_no=sim_no[_n-1] if sim_no==.
drop if HEV==""
destring qGDP HEV, replace
gen Method="TD_Decomposed"
save DIVA_C_`Name'_`Type'_`=$MCnoX'runs.dta, replace

import delimited "C:\SSA_TD_`Name'_(`Type')\MC_`Name'_Results\ALL_L.csv", clear 
rename v1 Region
rename v2 qGDPa
rename v3 HEV
gen SIM="PROPL"
gen sim_no=qGDPa
drop if Region=="             "
split sim_no, parse(_)
drop sim_no1
split sim_no2
destring sim_no21, ignore(`"clw"') replace
gen Parameter = regexs(0) if regexm(sim_no2, "[a-zA-Z]+")
replace Parameter=Parameter[_n-1] if Parameter==""
destring qGDPa, generate(qGDP) ignore(`"propclw_"')
drop qGDPa sim_no v4 sim_no2
rename sim_no21 sim_no
replace sim_no=sim_no[_n-1] if sim_no==.
drop if HEV==""
destring qGDP HEV, replace
gen Method="TD_Decomposed"
save DIVA_L_`Name'_`Type'_`=$MCnoX'runs.dta, replace
}
}
}

else{
	noisily: di as error "Simulations based on the Triangular distribution are done!"
}
}
}
else{
noisily: di as error "Analysis based on the Triangular distribution was skipped"
}

qui{
noisily: di in yellow "Do you want to run the simulations based on the Piecewise Linear Probability? y/n" _request(yval2)

if  "$yval2"=="y"{
qui{
noisily: di in yellow "Please enter an identification name for the experiment" _request(MCName) as input r(MM)
local Type="$MCName"
}
qui{
noisily: di in yellow "Please enter a number of sim replications for the LPD MC: " _request(MCnoX) as input r(MM)
di `=$MCnoX'
}
scalar kk=round(`=$MCnoX'/2)
cd C:\
capture noisily mkdir "C:\SSA_LPD_(`Type')"
cd "C:\SSA_LPD_(`Type')"
capture noisily mkdir "CMF files Total_PiecewiseLinear_C_0_`=kk'", public
capture noisily mkdir "CMF files Total_PiecewiseLinear_L_0_`=kk'", public
capture noisily mkdir "CMF files Total_PiecewiseLinear_C_`=kk'_`=$MCnoX'", public
capture noisily mkdir "CMF files Total_PiecewiseLinear_L_`=kk'_`=$MCnoX'", public
capture noisily mkdir "CMF files Total_PiecewiseLinear"
cd "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear"
copy "https://www.dropbox.com/s/t16xck6s9rlijqe/matlab.mat?dl=1" "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear\matlab.mat", replace


///Generate the Matlab code for the LPD sampling based on the number of simulations set by the user///
log using PiecewiseLinear.m, text replace
noisily: di "cd('C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear')"
noisily: di "load matlab"
noisily: di "rng(18050914, 'twister')"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR1(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR1 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR2(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR2 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR3(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR3 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR4(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR4 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR5(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR5 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR6(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR6 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR7(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR7 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR8(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR8 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR9(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR9 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR10(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR10 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR11(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR11 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR12(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR12 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR13(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR13 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR14(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR14 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR15(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR15 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR16(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR16 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR17(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR17 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR18(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR18 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR19(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR19 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR20(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR20 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR21(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR21 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR22(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR22 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR23(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR23 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR24(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR24 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR25(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR25 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR26(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR26 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR27(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR27 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR28(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR28 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR29(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR29 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR30(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR30 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR31(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR31 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR32(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR32 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR33(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR33 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR34(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR34 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR35(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR35 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR36(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR36 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR37(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR37 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR38(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR38 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR39(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR39 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR40(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR40 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR41(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR41 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR42(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR42 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR43(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR43 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR44(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR44 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR45(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR45 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR46(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR46 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR47(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR47 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR48(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR48 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR49(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR49 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR50(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR50 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR51(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR51 = random(pd,`=$MCnoX',1);"
noisily: di "f = f(1:1:end)"
noisily: di "x = VAR52(1:1:end)"
noisily: di "pd = makedist('PiecewiseLinear','x',x,'Fx',f);"
noisily: di "rwVAR52 = random(pd,`=$MCnoX',1);"
noisily: di "save matlab22"
noisily: di "X=[rwVAR1,rwVAR2,rwVAR3,rwVAR4,rwVAR5,rwVAR6,rwVAR7,rwVAR8,rwVAR9,rwVAR10,rwVAR11,rwVAR12,rwVAR13,rwVAR14,rwVAR15, ..."
noisily: di "rwVAR16,rwVAR17,rwVAR18,rwVAR19,rwVAR20,rwVAR21,rwVAR22,rwVAR23,rwVAR24,rwVAR25,rwVAR26,rwVAR27,rwVAR28,rwVAR29, ..."
noisily: di "rwVAR30,rwVAR31,rwVAR32,rwVAR33,rwVAR34,rwVAR35,rwVAR36,rwVAR37,rwVAR38,rwVAR39,rwVAR40,rwVAR41,rwVAR42,rwVAR43,rwVAR44,rwVAR45, ..."
noisily: di "rwVAR46,rwVAR47,rwVAR48,rwVAR49,rwVAR50,rwVAR51,rwVAR52]"
noisily: di "%xlswrite('PieaceLinearAll.xls',X)"
noisily: di "Names={'AfricaW';'CAsiaW';'ChinaW';'EEFSUW';'EastAsiaW';'JaKoSingW';'LatinAmerW'; ..."
noisily: di "'NAmericaW';'NEEuropeW';'NWEuropeW';'OceaniaW';'SEuropeW';'WAsiaW';'AfricaL';'CAsiaL'; ..."
noisily: di "'ChinaL';'EEFSUL';'EastAsiaL';'JaKoSingL';'LatinAmerL';'NAmericaL';'NEEuropeL';'NWEuropeL'; ..."
noisily: di "'OceaniaL';'SEuropeL';'WAsiaL';'AfricaC';'CAsiaC';'ChinaC';'EEFSUC';'EastAsiaC';'JaKoSingC'; ..."
noisily: di "'LatinAmerC';'NAmericaC';'NEEuropeC';'NWEuropeC';'OceaniaC';'SEuropeC';'WAsiaC';'AfricaW_Cx'; ..."
noisily: di "'CAsiaW_Cx';'ChinaW_Cx';'EEFSUW_Cx';'EastAsiaW_Cx';'JaKoSingW_Cx';'LatinAmerW_Cx';'NAmericaW_Cx'; ..."
noisily: di "'NEEuropeW_Cx';'NWEuropeW_Cx';'OceaniaW_Cx';'SEuropeW_Cx';'WAsiaW_Cx'}'"
noisily: di "T=table(rwVAR1,rwVAR2,rwVAR3,rwVAR4,rwVAR5,rwVAR6,rwVAR7,rwVAR8,rwVAR9,rwVAR10, ..."
noisily: di "rwVAR11,rwVAR12,rwVAR13,rwVAR14,rwVAR15,rwVAR16,rwVAR17,rwVAR18,rwVAR19,rwVAR20, ..."
noisily: di "rwVAR21,rwVAR22,rwVAR23,rwVAR24,rwVAR25,rwVAR26,rwVAR27,rwVAR28,rwVAR29,rwVAR30,rwVAR31,rwVAR32, ..."
noisily: di "rwVAR33,rwVAR34,rwVAR35,rwVAR36,rwVAR37,rwVAR38,rwVAR39,rwVAR40,rwVAR41,rwVAR42,rwVAR43,rwVAR44, ..."
noisily: di "rwVAR45,rwVAR46,rwVAR47,rwVAR48,rwVAR49,rwVAR50,rwVAR51,rwVAR52,'VariableNames',Names)"
noisily: di "writetable(T,'PieaceLinearAll.xls')"
noisily: di "exit"
log close

noisily: display _newline(200)
///Run the latlab code///
shell matlab -r PiecewiseLinear 

noisily: di as error "Press ENTER when Matlab calculations are finished to continue" _request(yval2)
///Collect the data generated from Matlab////
import excel PieaceLinearAll.xls, sheet("Sheet1") firstrow clear



noisily: di "****New generated data need to be transforned into string so Gempack can read zeros***"
foreach x in AfricaW ChinaW WAsiaW CAsiaW EastAsiaW JaKoSingW LatinAmerW NAmericaW NEEuropeW NWEuropeW SEuropeW OceaniaW EEFSUW AfricaW_Cx ChinaW_Cx WAsiaW_Cx CAsiaW_Cx EastAsiaW_Cx JaKoSingW_Cx LatinAmerW_Cx NAmericaW_Cx NEEuropeW_Cx NWEuropeW_Cx SEuropeW_Cx OceaniaW_Cx EEFSUW_Cx AfricaL ChinaL WAsiaL CAsiaL EastAsiaL JaKoSingL LatinAmerL NAmericaL NEEuropeL NWEuropeL SEuropeL OceaniaL EEFSUL AfricaC ChinaC WAsiaC CAsiaC EastAsiaC JaKoSingC LatinAmerC NAmericaC NEEuropeC NWEuropeC SEuropeC OceaniaC EEFSUC{
replace `x'=-`x'
format %16.0g `x'
tostring `x', generate(`x'i) force
replace `x'i = "-0." + substr(`x'i, 3, .) if substr(`x'i, 1, 2) == "-."
}


scalar NO=`=$MCnoX'-1
di `=NO'
///Generate CMF files for the LPD MC///
quietly {
forvalues idx=0/`=NO' {

     log using PROPL_LIN`idx'.cmf, text replace
     noisily: di "auxiliary files = gtap;"
noisily: di "Method = gragg ;"
noisily: di "steps = 2 4 6;"
noisily: di "check-on-read all = no; ! Never use this."
noisily: di "iz1 = yes;              ! Ignore zeros at step 1."
noisily: di "nds = yes;              ! Do no displays."
noisily: di "nrp = yes;              ! Don't reuse pivots."
noisily: di "CPU = yes ;"
noisily: di "file gtapsets = sets.har;"
noisily: di "file gtapparm = Default.prm;"
noisily: di "file gtapdata = BaseData.har;"
noisily: di "exogenous"
noisily: di " afall"
noisily: di "    afcom"
noisily: di "    afeall"
noisily: di "    afecom"
noisily: di "    afereg"
noisily: di "    afesec"
noisily: di "    afreg"
noisily: di "    afsec"
noisily: di "    ams"
noisily: di "    aoall"
noisily: di "    aoreg"
noisily: di "    aosec"
noisily: di "    atall !changed"
noisily: di "    atd"
noisily: di "    atf"
noisily: di "    atm"
noisily: di "    ats"
noisily: di "    au"
noisily: di "    avareg"
noisily: di "    avasec"
noisily: di "    cgdslack"
noisily: di "    dpgov"
noisily: di "    dppriv"
noisily: di "    dpsave"
noisily: di "    endwslack"
noisily: di "    incomeslack"
noisily: di "    pfactwld"
noisily: di "    pop"
noisily: di "    profitslack"
noisily: di "    psaveslack"
noisily: di "    qo(ENDW_COMM,REG)"
noisily: di "    tm"
noisily: di "    tms"
noisily: di "    to"
noisily: di "    tp"
noisily: di "    tradslack"
noisily: di "    tx"
noisily: di "    txs"
noisily: di ";"
noisily: di "Rest Endogenous ;"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Africa""'") = uniform " AfricaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"China""'") = uniform "   ChinaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"WAsia""'") = uniform "   WAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"CAsia""'") = uniform "   CAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EastAsia""'") = uniform "   EastAsiaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"JaKoSing""'") = uniform "   JaKoSingWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"LatinAmer""'") = uniform "   LatinAmerWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NAmerica""'") = uniform "   NAmericaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NEEurope""'") = uniform "   NEEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NWEurope""'") = uniform "   NWEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"SEurope""'") = uniform "   SEuropeWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Oceania""'") = uniform "  OceaniaWi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EEFSU""'") = uniform "   EEFSUWi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Africa""'") = uniform "   AfricaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","China""'") = uniform "   ChinaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","WAsia""'") = uniform "   WAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","CAsia""'") = uniform "   CAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EastAsia""'") = uniform "   EastAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","JaKoSing""'") = uniform "   JaKoSingCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","LatinAmer""'") = uniform "   LatinAmerCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NAmerica""'") = uniform "   NAmericaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NEEurope""'") = uniform "   NEEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NWEurope""'") = uniform "   NWEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","SEurope""'") = uniform "   SEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Oceania""'") = uniform "   OceaniaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EEFSU""'") = uniform "   EEFSUCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Africa""'") = uniform "   AfricaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","China""'") = uniform "   ChinaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","WAsia""'") = uniform "   WAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","CAsia""'") = uniform "   CAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EastAsia""'") = uniform "   EastAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","JaKoSing""'") = uniform "   JaKoSingLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","LatinAmer""'") = uniform "   LatinAmerLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NAmerica""'") = uniform "   NAmericaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NEEurope""'") = uniform "   NEEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NWEurope""'") = uniform "   NWEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","SEurope""'") = uniform "   SEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Oceania""'") = uniform "   OceaniaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EEFSU""'") = uniform "   EEFSULi[_n+`idx']  ";"
noisily: di "model               = Co-GEM ;"
noisily: di "version             = 0     ;"
noisily: di "identifier          = TIME  ;"
noisily: di "verbal description  = Qw. ;"
noisily: di "Solution file = PROPL_LIN`idx';"
noisily: di "updated file gtapdata = PROPL_LIN`idx'.har;"
noisily: di "extrapolation accuracy file = NO;"
     log close
}
}

****PROPC******

quietly {
forvalues idx=0/`=NO' {
     log using PROPC_LIN`idx'.cmf, text replace
     noisily: di "auxiliary files = gtap;"
noisily: di "Method = gragg ;"
noisily: di "steps = 2 4 6;"
noisily: di "check-on-read all = no; ! Never use this."
noisily: di "iz1 = yes;              ! Ignore zeros at step 1."
noisily: di "nds = yes;              ! Do no displays."
noisily: di "nrp = yes;              ! Don't reuse pivots."
noisily: di "CPU = yes ;"
noisily: di "file gtapsets = sets.har;"
noisily: di "file gtapparm = Default.prm;"
noisily: di "file gtapdata = BaseData.har;"
noisily: di "exogenous"
noisily: di " afall"
noisily: di "    afcom"
noisily: di "    afeall"
noisily: di "    afecom"
noisily: di "    afereg"
noisily: di "    afesec"
noisily: di "    afreg"
noisily: di "    afsec"
noisily: di "    ams"
noisily: di "    aoall"
noisily: di "    aoreg"
noisily: di "    aosec"
noisily: di "    atall !changed"
noisily: di "    atd"
noisily: di "    atf"
noisily: di "    atm"
noisily: di "    ats"
noisily: di "    au"
noisily: di "    avareg"
noisily: di "    avasec"
noisily: di "    cgdslack"
noisily: di "    dpgov"
noisily: di "    dppriv"
noisily: di "    dpsave"
noisily: di "    endwslack"
noisily: di "    incomeslack"
noisily: di "    pfactwld"
noisily: di "    pop"
noisily: di "    profitslack"
noisily: di "    psaveslack"
noisily: di "    qo(ENDW_COMM,REG)"
noisily: di "    tm"
noisily: di "    tms"
noisily: di "    to"
noisily: di "    tp"
noisily: di "    tradslack"
noisily: di "    tx"
noisily: di "    txs"
noisily: di ";"
noisily: di "Rest Endogenous ;"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Africa""'") = uniform " AfricaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"China""'") = uniform "   ChinaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"WAsia""'") = uniform "   WAsiaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"CAsia""'") = uniform "   CAsiaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EastAsia""'") = uniform "   EastAsiaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"JaKoSing""'") = uniform "   JaKoSingW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"LatinAmer""'") = uniform "   LatinAmerW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NAmerica""'") = uniform "   NAmericaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NEEurope""'") = uniform "   NEEuropeW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"NWEurope""'") = uniform "   NWEuropeW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"SEurope""'") = uniform "   SEuropeW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"Oceania""'") = uniform "  OceaniaW_Cxi[_n+`idx']  ";"
noisily: di "Shock atall("`""Water_Trans",TRAD_COMM,REG,"EEFSU""'") = uniform "   EEFSUW_Cxi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Africa""'") = uniform "   AfricaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","China""'") = uniform "   ChinaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","WAsia""'") = uniform "   WAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","CAsia""'") = uniform "   CAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EastAsia""'") = uniform "   EastAsiaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","JaKoSing""'") = uniform "   JaKoSingCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","LatinAmer""'") = uniform "   LatinAmerCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NAmerica""'") = uniform "   NAmericaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NEEurope""'") = uniform "   NEEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","NWEurope""'") = uniform "   NWEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","SEurope""'") = uniform "   SEuropeCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","Oceania""'") = uniform "   OceaniaCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Capital","EEFSU""'") = uniform "   EEFSUCi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Africa""'") = uniform "   AfricaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","China""'") = uniform "   ChinaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","WAsia""'") = uniform "   WAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","CAsia""'") = uniform "   CAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EastAsia""'") = uniform "   EastAsiaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","JaKoSing""'") = uniform "   JaKoSingLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","LatinAmer""'") = uniform "   LatinAmerLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NAmerica""'") = uniform "   NAmericaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NEEurope""'") = uniform "   NEEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","NWEurope""'") = uniform "   NWEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","SEurope""'") = uniform "   SEuropeLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","Oceania""'") = uniform "   OceaniaLi[_n+`idx']  ";"
noisily: di "Shock qo("`""Land","EEFSU""'") = uniform "   EEFSULi[_n+`idx']  ";"
noisily: di "model               = Co-GEM ;"
noisily: di "version             = 0     ;"
noisily: di "identifier          = TIME  ;"
noisily: di "verbal description  = Qw. ;"
noisily: di "Solution file = PROPC_LIN`idx';"
noisily: di "updated file gtapdata = PROPC_LIN`idx'.har;"
noisily: di "extrapolation accuracy file = NO;"
     log close
}
}

scalar k=round(`=$MCnoX'*+5)
scalar zz=round(`=$MCnoX'-1)
scalar zz3=`zz2'+1
scalar kk=round(`=$MCnoX'/2)

*****Create the Batch files for the runs*****
scalar xx=round(`=$MCnoX')
scalar xx1=round(`=$MCnoX'-1)
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
quietly {
log using PROPC_RUN_1.bat, text replace
noisily: di "cd "`""C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_C_0_`=kk'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=0/`=zz2'{
noisily: di "gemsim -cmf " "PROPC_LIN`idx'.cmf"
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPC*.har"
noisily: di "del PROPC*.slc"
forvalues idx=0/`=zz2'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPC_LIN`idx' PROPC_LIN`idx'.csv"
}
noisily: di "copy PROPC*.csv ALL_C1.csv"
log close
}

quietly {
log using PROPC_RUN_2.bat, text replace
noisily: di "cd "`""C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_C_`=kk'_`=$MCnoX'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=`=zz3'/`=xx1'{
noisily: di "gemsim -cmf " "PROPC_LIN`idx'.cmf"
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPC*.har"
noisily: di "del PROPC*.slc"
forvalues idx=`=zz3'/`=xx1'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPC_LIN`idx' PROPC_LIN`idx'.csv"
}
noisily: di "copy PROPC*.csv ALL_C2.csv"
log close
}


clear
quietly {
log using PROPL_RUN_1.bat, text replace
noisily: di "cd "`""C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_L_0_`=kk'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=0/`=zz2'{
noisily: di "gemsim -cmf " "PROPL_LIN`idx'.cmf"
}
noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPL*.har"
noisily: di "del PROPL*.slc"
forvalues idx=0/`=zz2'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPL_LIN`idx' PROPL_LIN`idx'.csv"
}
noisily: di "copy PROPL*.csv ALL_L1.csv"
log close
}

quietly {
log using PROPL_RUN_2.bat, text replace
noisily: di "cd "`""C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_L_`=kk'_`=$MCnoX'""'"
noisily: di "tablo -sti gtap2.sti"
forvalues idx=`=zz3'/`=xx1'{
noisily: di "gemsim -cmf " "PROPL_LIN`idx'.cmf"
}

noisily: di "del *.log"
noisily: di "del *.gs?"
noisily: di "del *.sol"
noisily: di "del *.xac"
noisily: di "del PROPL*.har"
noisily: di "del PROPL*.slc"
forvalues idx=`=zz3'/`=xx1'{
noisily: di "sltoht -sss -map=EV.MAP " "PROPL_LIN`idx' PROPL_LIN`idx'.csv"
}
noisily: di "copy PROPL*.csv ALL_L2.csv"
log close
}

if `XX'==1{
log using EV.map, text replace
noisily: di "qgdp : EV"
log close
}
else{
log using EV.map, text replace
noisily: di "`MAP'"
log close
}
noisily: display _newline(200)

noisily: display "Please wait for the GTAP data collection..."
*********Moving files *********
foreach x in L C{
scalar xx=`=$MCnoX'
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
forvalues idx=0/`=zz2'{
capture copy PROP`x'_LIN`idx'.cmf "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_`x'_0_`=kk'/PROP`x'_LIN`idx'.cmf", replace
}
copy EV.map "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/EV.map", replace
copy "https://www.dropbox.com/s/0s34plns1vilzos/BaseData.har?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/BaseData.har", replace
copy "https://www.dropbox.com/s/gssvxlfenwj4m01/Sets.har?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/Sets.har", replace
copy "https://www.dropbox.com/s/sqgtiyuwjap84yt/Default.prm?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/Default.prm", replace
copy "https://www.dropbox.com/s/m8sqmayvn1jwi1l/gtap2.sti?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/gtap2.sti", replace
copy "https://www.dropbox.com/s/m0f481ml7r0hvx1/gtap.tab?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/gtap.tab", replace
copy PROP`x'_RUN_1.bat "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/PROP`x'_RUN_1.bat", replace
}

foreach x in L C{
scalar xx=`=$MCnoX'
scalar zz2=round(`=xx'/2)
scalar zz3=`=zz2'+1
forvalues idx=`=zz3'/`=xx'{
local d=`lastvar'[_n+`idx']
capture qui copy PROP`x'_LIN`idx'.cmf "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/PROP`x'_LIN`idx'.cmf", replace
}
copy EV.map "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/EV.map", replace
copy "https://www.dropbox.com/s/0s34plns1vilzos/BaseData.har?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/BaseData.har", replace
copy "https://www.dropbox.com/s/gssvxlfenwj4m01/Sets.har?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/Sets.har", replace
copy "https://www.dropbox.com/s/sqgtiyuwjap84yt/Default.prm?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/Default.prm", replace
copy "https://www.dropbox.com/s/m8sqmayvn1jwi1l/gtap2.sti?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/gtap2.sti", replace
copy "https://www.dropbox.com/s/m0f481ml7r0hvx1/gtap.tab?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/gtap.tab", replace
copy PROP`x'_RUN_2.bat "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_`=kk'_`=$MCnoX'/PROP`x'_RUN_2.bat", replace
}

qui{
log using Check.bat, text replace
noisily: display "cd "`""C:/SSA_TD_`Name'_(`Type')/CMF files `Name'_C_0_`=kk'""'"
noisily: display "@echo off"
noisily: display "setlocal enableextensions"
noisily: display ":loop"
noisily: display "set x=0"
noisily: display "set y=`=zz3'"
noisily: display "for %%x in (*.sl4) do set /a x+=1"
noisily: display "set /a z=100*x/y"
noisily: display "echo %z% %% is done%"
noisily: display "if %z% gtr 95 ("
noisily: display "        exit /b"
noisily: display "      )"
noisily: display "timeout /t 15"
noisily: display "endlocal"
noisily: display "goto loop"
log close
copy Check.bat "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear_`x'_0_`=kk'/Check.bat", replace
}

shell del *.cmf
cd C:\
copy "https://www.dropbox.com/s/qardmu50gsy0jql/Run.bat?dl=1" "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear/Run.bat", replace
cd "C:/SSA_LPD_(`Type')/CMF files Total_PiecewiseLinear"
}
}
qui{
noisily: display _newline(200)
noisily: di in yellow "Do you want to run the simulations, y/n: " _request(yval)
di "A is $yval"
if  "$yval"=="y"{
	noisily: di "Running simulations...It will take several hours depending on the number of simulations specified"
	capture timer clear 1
	timer on 1
	shell Run.bat
	timer off 1
	timer list 1
	scalar hours=int(`r(t1)'/3600)
	scalar remainder=int(`r(t1)'-`=hours' *3600)
	scalar mins=int(`=remainder'/60)
	scalar remainder=(`=remainder'-`=mins'*60)
	scalar sec=`=remainder'
    
	noisily: di "Running time was `=hours' hours, `=mins' minutes and `=sec' seconds"

cd "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_C_`=kk'_`=$MCnoX'"
shell copy propc*.csv "C:\SSA_LPD_(`Type')\ALL_C2.csv"
cd "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_L_`=kk'_`=$MCnoX'"
shell copy propl*.csv "C:\SSA_LPD_(`Type')\ALL_L2.csv"
cd "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_C_0_`=kk'"
shell copy propc*.csv "C:\SSA_LPD_(`Type')\ALL_C1.csv"
cd "C:\SSA_LPD_(`Type')\CMF files Total_PiecewiseLinear_L_0_`=kk'"
shell copy propl*.csv "C:\SSA_LPD_(`Type')\ALL_L1.csv"
cd "C:\SSA_LPD_(`Type')"
shell copy ALL_L*.csv "C:\SSA_LPD_(`Type')\ALL_L.csv"
shell copy ALL_C*.csv "C:\SSA_LPD_(`Type')\ALL_C.csv"	


import delimited "C:\SSA_LPD_(`Type')\ALL_C.csv", clear 
rename v1 Region
rename v2 qGDPa
rename v3 HEV
gen SIM="PROPC"
gen sim_no=qGDPa
drop if Region=="             "
split sim_no, parse(c_lin)
drop sim_no1
destring sim_no2, replace
destring qGDPa, generate(qGDP) ignore(`"propc_lin"')
drop qGDPa sim_no v4
rename sim_no2 sim_no
replace sim_no=sim_no[_n-1] if sim_no==.
drop if HEV==""
destring qGDP HEV, replace
gen Method="LPD"
save DIVA_C_LPD_`Type'_`=$MCnoX'runs.dta, replace

import delimited "C:\SSA_LPD_(`Type')\ALL_L.csv", clear 
rename v1 Region
rename v2 qGDPa
rename v3 HEV
gen SIM="PROPL"
gen sim_no=qGDPa
drop if Region=="             "
split sim_no, parse(l_lin)
drop sim_no1
destring sim_no2, replace
destring qGDPa, generate(qGDP) ignore(`"propl_lin"')
drop qGDPa sim_no v4
rename sim_no2 sim_no
replace sim_no=sim_no[_n-1] if sim_no==.
drop if HEV==""
destring qGDP HEV, replace
gen Method="LPD"
save DIVA_L_LPD_`Type'_`=$MCnoX'runs.dta, replace
}
else{
set more on
noisily: di as error "Analysis based on the Piecewise Linear Probability distribution skipped" 
}
}
}
