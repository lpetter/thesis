**	IMPORT DATASET	**
cd "C:\Users\dell\Documents\MPP Courses\1. Semester I\9. Maser Thesis\2. Datasets\1. LAIS"
import delimited "C:\Users\dell\Documents\MPP Courses\1. Semester I\9. Maser Thesis\2. Datasets\1. LAIS\LAIS_public.csv"

********************************************************************************
**				 				DATA MANAGEMENT								  **
********************************************************************************

encode countryc, gen(ncountry) // Country identification
keep if ncountry==5 // keep only Ecuadorian firms
keep if isic4_3d>=100 & isic4_3d<120 // keep only manufacture of food (100 to 108) and beverage (110)

gen dfin_public_0 = dfin_public // MV: 308
gen dfin_bank_0 = dfin_bank // MV: 308
gen dfin_own_0 = dfin_own // MV: 308
gen dfin_other_0 = dfin_other // MV: 308

replace dfin_public_0 = 0 if dfin_public_0==. 
replace dfin_bank_0 = 0 if dfin_bank_0==.
replace dfin_own_0 = 0 if dfin_own_0==.
replace dfin_other_0 = 0 if dfin_other_0==.


drop otherexp_us_y1 otherexp_us_y2 otherexp_us_y3 // used after to sum all innovation expenses, generating missing values
drop if empl_y1==0 // drop if no employees in year 1
drop if empl_y2==0 // drop if no employees in year 2
drop if empl_y3==0 // drop if no employees in year 3

// Count: 693 Obsservations



*------------------------------------------------------------------------------*
*							Dependent variables								   *	*------------------------------------------------------------------------------*

*********************		Innovation expenditure		************************
gen I_exp_us_y1 = rdintexp_us_y1+rdextexp_us_y1+hardwexp_us_y1+softwexp_us_y1+ictexp_us_y1+machexp_us_y1+ict_mach_us_y1+trainexp_us_y1+ttexp_us_y1+conexp_us_y1+ipexp_us_y1+idexp_us_y1+mktexp_us_y1 // create sum of all innovation expenses for year 1
gen I_exp_peremp_y1 = I_exp_us_y1/empl_y1 // Innovation expenditure per employee in year 1
// MV: 0

gen I_exp_us_y2 = rdintexp_us_y2+rdextexp_us_y2+hardwexp_us_y2+softwexp_us_y2+ictexp_us_y2+machexp_us_y2+ict_mach_us_y2+trainexp_us_y2+ttexp_us_y2+conexp_us_y2+ipexp_us_y2+idexp_us_y2+mktexp_us_y2 // create sum of all innovation expenses for year 2
gen I_exp_peremp_y2 = I_exp_us_y2/empl_y2 // Innovation expenditure per employee in year 2
// MV: 0

gen I_exp_us_y3 = rdintexp_us_y3+rdextexp_us_y3+hardwexp_us_y3+softwexp_us_y3+ictexp_us_y3+machexp_us_y3+ict_mach_us_y3+trainexp_us_y3+ttexp_us_y3+conexp_us_y3+ipexp_us_y3+idexp_us_y3+mktexp_us_y3 // create sum of all innovation expenses for year 3
gen I_exp_peremp_y3 = I_exp_us_y3/empl_y3 // Innovation expenditure per employee in year 3
// MV: 0


gen I_exp_us_total = (I_exp_us_y1+I_exp_us_y2+I_exp_us_y3) // sum of three years of innovation expenses
// MV: 0

gen Iexp_avg = I_exp_us_total/3
gen len_iexptotal = ln(I_exp_us_total) // log of total innovation expenditure
gen len_iexptotal_avg = ln((I_exp_us_total/3)) // log of total innovation expenditure


gen I_exp_peremp_total = I_exp_peremp_y1+I_exp_peremp_y2+I_exp_peremp_y3 // sum of three year of innovation expenses per employee
// MV: 0

gen lnI_exp = ln(I_exp_peremp_total) // log of total expenditure per employee
// MV: 294

gen lnI_exp_0 = lnI_exp
replace lnI_exp_0 = 0 if lnI_exp_0==.
// MV: 0
// Assumption: firms that do not report innovation expenditure indeed did not expent on in

********************************************************************************

*********************	Dummy for firms that innovate	************************
gen I_inv = 0 // create dummy variable for innovative firms
replace I_inv = 1 if I_exp_us_total>0 // replace with 1 if firm has more than 0 USD expendenditure in innovation
// MV: 0

********************************************************************************




*------------------------------------------------------------------------------*
*						Independent variables								   *	*------------------------------------------------------------------------------*


************************			Firm's Age			************************
gen Age = year-yr_firm // years in operation since the foundation until the year of the innovation survey
// MV: 0

gen ln_age = ln(Age) // log of Age
// MV: 0

********************************************************************************


****************	Cooperation for financing variables 	********************
gen coop_otherfirms_fin = (coop_gp_fin+coop_relf_fin+coop_comp_fin)/3 // firm's group, other related firms and competitors
//replace coop_otherfirms_fin = 0 if coop_otherfirms_fin==. // replace missing
// MV: 295

gen coop_cs_fin = (coop_cl_fin+coop_suppl_fin)/2 // Clients and Suppliers
//replace coop_cs_fin = 0 if coop_cs_fin==. // replace missing
// MV: 294

gen coop_ipsti_fin = (coop_ip_fin+coop_pubsti_fin)/2 // IP office and STI public institutions
//replace coop_ipsti_fin = 0 if coop_ipsti_fin==. // replace missing
// MV:295

//replace coop_consres_fin = 0 if coop_consres_fin==. // replace missing
// MV: 295

gen coop_total_fin = (coop_otherfirms_fin+coop_cs_fin+coop_consres_fin+coop_ipsti_fin) // total number of cooperations
// MV: 295
gen coop_total_fin_0 = coop_total_fin
replace coop_total_fin_0 = 0 if coop_total_fin_0==.

/*gen check_coop = . // checking if there are missing values because of different observations being missing in the construct of the above variable
replace check_coop = 0 if coop_total_fin!=.
replace check_coop = 1 if (coop_otherfirms_fin+coop_cs_fin)==. & coop_ipsti_fin!=.
replace check_coop = 1 if (coop_otherfirms_fin+coop_ipsti_fin)==. & coop_cs_fin!=.
replace check_coop = 1 if (coop_otherfirms_fin)==. & coop_cs_fin!=. & coop_ipsti_fin!=.
replace check_coop = 1 if (coop_cs_fin)==. & coop_otherfirms_fin!=. & coop_ipsti_fin!=.
replace check_coop = 1 if (coop_ipsti_fin)==. & coop_otherfirms_fin!=. & coop_cs_fin!=.
*/


********************************************************************************


****************	Fixed Capital Investment (cap_inv) 		********************
gen capinv_peremp_y1 = k_us_y1/empl_y1
gen capinv_peremp_y2 = k_us_y2/empl_y2
gen capinv_peremp_y3 = k_us_y3/empl_y3

gen lncapinv = ln(capinv_peremp_y1+capinv_peremp_y2+capinv_peremp_y3) // average of fixed capital investment
// MV: 186

gen lncapinv_0 = lncapinv
replace lncapinv_0 = 0 if lncapinv_0==.
// MV: 0

gen lncapinv_avg = ln((capinv_peremp_y1+capinv_peremp_y2+capinv_peremp_y3)/3) // average of fixed capital investment
gen capinvperemp_avg = (capinv_peremp_y1+capinv_peremp_y2+capinv_peremp_y3)/3
gen capinv_avg = (k_us_y1+k_us_y2+k_us_y3)/3

********************************************************************************


********************************************************************************

****************			Foreign Ownership (FO) 			********************
gen FO = 1 if foreign_y1>0 & foreign_y2>0 & foreign_y3>0
// MV: 604

replace FO = 0 if foreign_y3<10 // to do not count firms with less than 10% foreign ownership
replace FO = 0 if FO==.
// MV: 0
// Assumption: firms that did not report foreign capital do not have it

********************************************************************************


/**********	Intellectual Property Rights Aplication (IPR_app)	***************/
gen IPR_app = dpatentappl+dtdmarkappl+dumodelappl+didesignappl+dcopyrappl+dgeoindappl
replace IPR_app = 0 if IPR_app==.
gen lnIPR_app = ln(1 + IPR_app)

gen IPR_app2 = 0
replace IPR_app2 = 1 if (dpatentappl+dtdmarkappl+dumodelappl+didesignappl+dcopyrappl+dgeoindappl)>0
// MV: 0

// Proxy to measure the importance of IPRs. The bigger variety of different IPRs, the more important IPRs are, relatively speaking. Firms that did not report IPR app are assummed to not have any. I consider this variable more relevant than the well-known 'importance' questions because there is a tangible factor to assume that firms have more knowledge about the costs and benefits spurred from IPRs, and thus can have better informed decisions on future investments on innovation.

********************************************************************************


/***********						Size						***************/
gen empl_avg = (empl_y1+empl_y2+empl_y3)/3 // Average employees in three years
gen lem = ln(empl_avg) // log of average employees
// MV: 0


gen firm_size = .
replace firm_size = 1 if empl_avg<10
replace firm_size = 2 if empl_avg>=10 & empl_avg<50
replace firm_size = 3 if empl_avg>=50 & empl_avg<200
replace firm_size = 4 if empl_avg>=200



********************************************************************************

/***********				Information sources					***************/
// Market Sources
recode info_cl (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_comp (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_suppl (1 = 4) (2 = 3) (3 = 2) (4 = 1)

gen info_cl_0 = info_cl
gen info_comp_0 = info_comp
gen info_suppl_0 = info_suppl

replace info_cl_0 = 0 if info_cl_0==.
replace info_comp_0 = 0 if info_comp_0==.
replace info_suppl_0 = 0 if info_suppl_0==.

gen info_market = (info_cl+info_comp+info_suppl)/(4+4+4)
// MV: 273

gen info_market_0 = (info_cl_0+info_comp_0+info_suppl_0)/(4+4+4)
// MV: 0


// Scientific Sources
recode info_lab (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_pusti (1 = 4) (2 = 3) (3 = 2) (4 = 1)

gen info_lab_0 = info_lab // info_lab's MV: 273
gen info_pusti_0 = info_pusti // info_pusti's MV: 494

replace info_lab_0 = 0 if info_lab_0==.
replace info_pusti_0 = 0 if info_pusti_0==.

gen info_scien = (info_lab+info_pusti)/(4+4)
// MV: 494

gen info_scien_0 = (info_lab_0+info_pusti_0)/(4+4)
// MV: 0


// Other Sources
recode info_ip (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_art (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_conf (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_cons (1 = 4) (2 = 3) (3 = 2) (4 = 1)
recode info_net (1 = 4) (2 = 3) (3 = 2) (4 = 1)

gen info_ip_0 = info_ip
gen info_art_0 = info_art
gen info_conf_0 = info_conf
gen info_cons_0 = info_cons
gen info_net_0 = info_net

replace info_ip_0 = 0 if info_ip_0==.
replace info_art_0 = 0 if info_art_0==.
replace info_conf_0 = 0 if info_conf_0==.
replace info_cons_0 = 0 if info_cons_0==.
replace info_net_0 = 0 if info_net_0==.

gen info_others = (info_ip+info_art+info_conf+info_cons+info_net)/(4+4+4+4+4)
// MV: 273

gen info_others_0 = (info_ip_0+info_art_0+info_conf_0+info_cons_0+info_net_0)/(4+4+4+4+4)
// MV: 0


/*********************			Obstacles in financing		*******************/

gen dobst_finext_0 = dobst_finext // MV: 188
gen dobst_finint_0 = dobst_finint // MV: 188

replace dobst_finext_0 = 0	 if dobst_finext_0==.
// MV: 0
replace dobst_finint_0 = 0 if dobst_finint_0==.
// MV: 0

recode obst_finext (1 = 4) (2 = 3) (3 = 2) (4 = 1)
// MV: 188
recode obst_finint (1 = 4) (2 = 3) (3 = 2) (4 = 1)
// MV: 188

gen obst_finext_0 = obst_finext
gen obst_finint_0 = obst_finint

replace obst_finext_0 = 0 if obst_finext_0==.
// MV: 0
replace obst_finint_0 = 0 if obst_finint_0==.
// MV: 0

/*********************			Exports			*******************/
gen exp_avg = (export_us_y1+export_us_y2+export_us_y3)/3 // Average employees in three years
gen lexp = ln(exp_avg) // log of average employees
replace lexp = 0 if lexp==.
// MV: 0


********************************************************************************
**					 		DESCRIPTIVE STATISTICS							  **
********************************************************************************

**	Charts	**
graph drop public bank own other
hist fin_public if isic4_3d>=100 & isic4_3d<120 & ncountry==5, addl name(public)
hist fin_bank if isic4_3d>=100 & isic4_3d<120 & ncountry==5, addl name(bank)
hist fin_own if isic4_3d>=100 & isic4_3d<120 & ncountry==5, addl name(own)
hist fin_other if isic4_3d>=100 & isic4_3d<120 & ncountry==5, addl name(other)
graph combine public bank own other

hist empl_avg
hist lem
hist Age
hist ln_age

**	Tables	**
//Size
egen total_pop = total(exp_f)

// Descriptive table
summarize I_inv Iexp_avg dfin_bank dfin_public dfin_own dfin_other dexport IPR_app empl_avg Age capinv_avg FO group 




********************************************************************************
**					 		MODEL AND REGRESSIONS							  **
********************************************************************************

* (1) Knowledge investment

//*** TOBIT ***// 
/*// INCLUDING MISSING VALUES************************


* (i) Investing decision
// Model 1 - All variables included
tobit I_inv obst_finext obst_finint dexport FO group IPR_app lncapinv lem c.ln_age##c.ln_age info_market info_scien info_others
eststo ID1
// Obs. Incl: 184 / 27%


// Model 2 - Without considering Information sources relevant
tobit I_inv obst_finext obst_finint dexport FO group IPR_app lncapinv lem c.ln_age##c.ln_age 
eststo ID2
// Obs. Incl: 417 / 60%


// Model 3 - Foreign Owenership not relevant
tobit I_inv obst_finext obst_finint dexport group IPR_app lncapinv lem c.ln_age##c.ln_age 
eststo ID3
// Obs. Incl: 417 / 60%


// Model 4 - Fixed capital investment per employee not relevant
tobit I_inv obst_finext obst_finint dexport group IPR_app lem c.ln_age##c.ln_age 
eststo ID4
// Obs. Incl: 505 / 73%


// Model 5 - Importance of obstacles not relevant
tobit I_inv dexport group IPR_app lem c.ln_age##c.ln_age
eststo ID5
// Obs. Incl: 693 / 100%


// Model 6 - Build around this model ***
tobit I_inv dexport group IPR_app lem c.ln_age##c.ln_age info_market info_others
eststo ID6
// Obs. Incl: 420 / 61%


/* FINAL REMARKS: FO does not seem relevant at all
Information from scientific sources reduce the observations count to 27%, do not use.
Log from fixed capital investment makes exports, group and IPR app negative, making no sense, do not use.
*/

//cor obst_finext obst_finint dexport FO group IPR_app lem Age
//margins, dydx(Age) at(Age=(-2(0.1)2)) 
//marginsplot

esttab ID1 ID2 ID3 ID4 ID5 ID6 using ID.csv, star(* 0.10 ** 0.05 *** 0.01) replace

*/

//*** TOBIT ***//
/// MISSING VALUES REPLACED BY 0 *******************
// variables that did not required replacement: group, IPR_app, dexport

* (i) Investing decision
// Model 1 - all variables
tobit I_inv dexport lem c.ln_age##c.ln_age obst_finext_0 obst_finint_0 
eststo ID1_0

// Model 2
tobit I_inv dexport lem c.ln_age##c.ln_age obst_finext_0 obst_finint_0 FO group 
eststo ID2_0eststo ID2_0

// Model 3
tobit I_inv dexport lem c.ln_age##c.ln_age obst_finext_0 obst_finint_0 info_market_0 info_others_0
eststo ID3_0

// Model 4
tobit I_inv dexport lem c.ln_age##c.ln_age obst_finext_0 obst_finint_0  FO group  info_market_0 info_others_0
eststo ID4_0

//cor obst_finext obst_finint dexport FO group IPR_app lem Age
//margins, dydx(Age) at(Age=(-2(0.1)2)) 
//marginsplot

esttab ID1_0 ID2_0 ID3_0 ID4_0 using ID_0.csv, star(* 0.10 ** 0.05 *** 0.01) replace
*/

/* EXPLANATION
Obstacles to finance internally and externally is a perception and can trigger the decision because, as investing in innovation implies taking risks, the manager's perception of leveraging these investment either with own recources or external, can potentially affect the decision.
Beign an exporting firm implies exposure to international markets, where regulations and product demands are different, diverse, as well as a greater chance of finding new niches and pull-behaviour pressures towards innovation
Foreign ownership plays a similar role as exporting. Beign owned by foreign investors and/or firms can steer the future investments because of exposure, a more globalized vision, access to new markets, compliance with international regulations, but most of all, in the case of corporations and foreign firm's capital, business models from abroad can influence the local decisions.
Group refers as beign part of a local coorporate group. It can push the decision to innovate, but depends on many factors related to the level of influence and managerial vision from the corporate office to the firm.
IPR_app refers if there are inovation applications. Firms that has formal IPR tools tend to continue innovating as they have already taken the leap towards investing in an uncerain activity.
lem (log of employees) bigger companies tend might tend to be more innovative.
Age: older companies might tend to innovate to secure their share of the market.
*/

// coop_otherfirms_fin coop_cs_fin coop_consres_fin coop_ipsti_fin 



/* (2) Innovation Intensity using dummy of financial types ********************

//*** TOBIT ***// 
// INCLUDING MISSING VALUES************************

// Model 1
tobit lnI_exp dfin_bank dfin_public dfin_own dfin_other coop_total_fin lncapinv group 
eststo II1

// Model 2
tobit lnI_exp dfin_bank dfin_public dfin_own dfin_other coop_total_fin lncapinv group dexport FO 
eststo II2

// Model 3
tobit lnI_exp dfin_bank dfin_public dfin_own dfin_other coop_total_fin lncapinv group info_market info_others
eststo II3

// Model 4
tobit lnI_exp dfin_bank dfin_public dfin_own dfin_other coop_total_fin lncapinv group dexport FO info_market info_others
eststo II4


// Table
esttab II1 II2 II3 II4 using II.csv, star(* 0.10 ** 0.05 *** 0.01) replace
*/	
	
	/* Discarded variables
	coop_total_fin 
	
*/


/*Variables than once the investment decision is made, they do not affect the ammount
dexport FO IPR_app info_market info_scien info_others
*/

//*** HECKMAN ***// 
** Model 1: bank financing - what are the variables that increase innovation expenditure when there is financing from banks
//heckman len_iexptotal dfin_bank lncapinv group lem FO dexport, select(obst_finext obst_finint IPR_app lem FO dexport) // <-------- This is it! change for each type of financial source and then try to add or take variables according to theory, specially for own and other types of resources.
// Comment: when information from others used with information from markets, the latter becomes non-significant. Maybe firms have access to different informations sources, cancelling each other.



heckman len_iexptotal dfin_bank lem lncapinv_avg lnIPR_app group FO ln_age, select(dexport lem lncapinv_avg lnIPR_app c.ln_age##c.ln_age FO)

eststo bank

heckman len_iexptotal dfin_public lem lncapinv_avg lnIPR_app group FO ln_age, select(dexport lem lncapinv_avg lnIPR_app c.ln_age##c.ln_age FO)

eststo public

heckman len_iexptotal dfin_own lem lncapinv_avg lnIPR_app group FO ln_age, select(dexport lem lncapinv_avg lnIPR_app c.ln_age##c.ln_age FO)

eststo own

heckman len_iexptotal dfin_other lem lncapinv_avg lnIPR_app group FO ln_age, select(dexport lem lncapinv_avg lnIPR_app c.ln_age##c.ln_age FO)

eststo other

esttab bank public own other using Heckman.csv, star(* 0.10 ** 0.05 *** 0.01) replace


 

