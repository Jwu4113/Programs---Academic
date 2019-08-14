/* Culminating Project Statistical Analysis */

Libname Mydata "F:\School\G3D\Culminating Project\Stat Analysis";
Run;

/* Copy from work to Mydata after importing csv*/
Proc copy out=Mydata in=work;
Run;

/* Delete Missing observations*/
Data Mydata.news;
	Set Mydata.news;
		if Num = . then delete;
Run;

/* Delete non needed variables */
Data Mydata.news;
	Set Mydata.news;
		Drop _ Var29 Var30 Var31 Var32 Var33;
Run;


/* Table 1 Demographic Table */
Proc Contents data = mydata.news;
Run;

/*Type of Article, Region, Time frame */
Proc Freq Data = mydata.news;
	Tables Type Region BefAftDem;
Run;

/* Table 2 */
Proc Sort data = mydata.news;
	by Region;
Run;

Proc Freq Data = mydata.news; /*Needs to sort */
	Tables HFEcig ArtFrame HFFedReg FDAFrame;
	by Region;
Run;

/*Table 3 */

Proc Sort data = mydata.news;
	by Term;
Run;

Proc Freq Data = mydata.news; /*Needs to sort */
	Tables HFEcig ArtFrame HFFedReg FDAFrame;
	by Term;
Run;

/*Table 4 */

Proc Sort data = mydata.news;
	by BefAftDem;
Run;

Proc Freq Data = mydata.news; /*Needs to sort */
	Tables HFEcig ArtFrame HFFedReg FDAFrame;
	by BefAftDem;
Run;

Proc Freq Data = mydata.news;
	Tables Term;
Run;

/* Table 5 */
Proc Sort data = mydata.news;
	by type;
Run;

Proc Freq Data = mydata.news;
	Tables Top1 Top2 Top3 Top4 Top5 Top6 Top7 Top8;
	By Type;
Run;

/* Table 6 */
/* Split dataset to opinion vs news */
Data mydata.opinion;
	Set mydata.news;
		if type = 2;
Run;

Proc Sort data = mydata.opinion;
	by ArtFrame;
Run;

Proc Freq Data = mydata.opinion;
	Tables Top1 Top2 Top3 Top4 Top5 Top6 Top7 Top8;
	By ArtFrame;
Run;

/* Table 7 */

Proc Sort Data = mydata.news;
	by Type;
Run;
Proc Freq Data = mydata.news;
	Tables HFFedReg;
		by Type;
Run;

/* Table 8 */
Proc Sort Data = mydata.news;
	by Type;
Run;
Proc Freq Data = mydata.news;
	Tables FDAFrame;
		by Type;
Run;

/* Table 9 */
/* Create new dataset that does not include 4's for FDA Frame */
Data Mydata.FDAFrameNo4;
	Set Mydata.news;
		If FDAFrame ne 4;
Run;


Proc Sort Data = mydata.FDAFrameNo4;
	by Type;
Run;
Proc Freq Data = mydata.FDAFrameNo4;
	Tables FDAFrame*(FDA1 FDA2 FDA3 FDA4 FDA5);
		by Type;
Run;

/* Region vs Article Framing of E-cigarettes */
/*Sort by ArtFrame first */
Proc Sort Data = mydata.news;
	by ArtFrame;
Run;

Proc Freq Data = mydata.news;
	Tables Region*ArtFrame;
Run;


/*********************************************************************************************************************/
/* Attempt to use Chi2 and possibly Anova to compare proportions of Positive by Region */
/* Creation of a Article Frame Positive Variable (1 if positive, 0 everything else (negative and neutral))*/

Data mydata.news;
	Set mydata.news;
		If ArtFrame = 1 then ArtPos = 1;
		else Artpos = 0;
Run;


/* Attempt to do Chi2 with ArtPos by Region*/
Proc Freq Data = mydata.news;
	Tables ArtPos*Region / chisq;
Run;

/* Creation of a Article Frame Negative Variable (1 if negative, 0 everything else (positive and neutral))*/

Data mydata.news;
	Set mydata.news;
		If ArtFrame = 2 then ArtNeg = 1;
		else ArtNeg = 0;
Run;


/* Attempt to do Chi2 with ArtNeg by Region*/
Proc Freq Data = mydata.news;
	Tables ArtNeg*Region / chisq;
Run;

/* Creation of a Article Frame Neutral Variable*/

Data mydata.news;
	Set mydata.news;
		If ArtFrame = 3 then ArtNeu = 1;
		else ArtNeu = 0;
Run;


/* Attempt to do Chi2 with ArtPos by Region*/
Proc Freq Data = mydata.news;
	Tables ArtNeu*Region / chisq;
Run;

/***********************************************************************************************************************/

/* E-cig and FDA Reg comparison by before and after Dem rule */
/* Change Before and After Deeming rule to 1 and 0 instead of 1 and 2 (1 will be after, 0 will be before) */

Proc Freq Data = Mydata.news;
	Tables Befaftdem;
Run;

Data mydata.news;
	Set Mydata.news;
		If BefAftDem = 1 then BefAftDem = 0;
		If BefAftDem = 2 then BefAftDem = 1;
Run;

/* Frame towards E-cigs by Article Frame */
Proc Freq Data = mydata.news;
	Tables BefAftDem*ArtFrame;
Run;

/* Frame towards FDA Regulations by Article Frame */
/* Creation of variable for FDA Frame with out 4 */
Data mydata.news;
	Set mydata.news;
		If FDAFrame = 1 then FDAFrameNo4 = 1;
		If FDAFrame = 2 then FDAFrameNo4 = 2;
		If FDAFrame = 3 then FDAFrameNo4 = 3;
		If FDAFrame = 4 then FDAFrameNo4 = .;
Run;

Proc Freq Data = mydata.news;
	Tables BefAftDem*FDAFrameNo4;
Run;

/* Chi2 test for before and after dem for the Article */

/*Positive Frame */
Proc Freq Data = mydata.news;
	Tables ArtPos*BefAftDem / chisq;
Run;	

/*Negative Frame */
Proc Freq Data = mydata.news;
	Tables ArtNeg*BefAftDem / chisq;
Run;	

/*Neutral Frame */
Proc Freq Data = mydata.news;
	Tables ArtNeu*BefAftDem / chisq;
Run;

/* Chi2 test for before and after dem for the Fed Reg */	

/* Creation of binary positive, negative, and neutral Fed Reg */

Data mydata.news;
	Set mydata.news;
		If FDAFrame = 1 then FDAPos = 1;
		else FDAPos = 0;

		If FDAFrame = 4 then FDAPos = .;
Run;

Data mydata.news;
	Set mydata.news;
		If FDAFrame = 2 then FDANeg = 1;
		else FDANeg = 0;

		If FDAFrame = 4 then FDANeg = .;
Run;

Data mydata.news;
	Set mydata.news;
		If FDAFrame = 3 then FDANeu = 1;
		else FDANeu = 0;

		If FDAFrame = 4 then FDANeu = .;
Run;



/*Positive Frame */
Proc Freq Data = mydata.news;
	Tables FDAPos*BefAftDem / chisq;
Run;	

/*Negative Frame */
Proc Freq Data = mydata.news;
	Tables FDANeg*BefAftDem / chisq;
Run;	

/*Neutral Frame */
Proc Freq Data = mydata.news;
	Tables FDANeu*BefAftDem / chisq;
Run;

/***********************************************************************************************************************/

/*Positive vs Negative vs Neutral Frame by Term used*/
Proc Freq Data = mydata.news;
	Tables Term*ArtFrame;
Run;

/* Creating of Term dummy variables to run chi2 */
Data mydata.news;
	Set mydata.news;
		If Term = 1 then Vape = 1;
		else Vape = 0;

		If Term = 2 then Ecig = 1;
		else Ecig = 0;

		If Term = 3 then Ecigtte = 1;
		else Ecigtte = 0;

		If Term = 2 then EcigCombo = 1;
		If Term = 3 then EcigCombo = 1;
		If Term = 1 then EcigCombo = 0;
Run;

/* Chi2 */

/* Article Positive vs Term (Vape vs everything else)*/
Proc Freq Data = mydata.news;
	Tables ArtPos*Vape / Chisq;
Run;

/* Article Negative vs Term */

Proc Freq Data = mydata.news;
	Tables ArtNeg*Vape / Chisq;
Run;

/* Article Neutral vs Term */

Proc Freq Data = mydata.news;
	Tables ArtNeu*Vape / Chisq;
Run;

data mydata.artframevterm;
length Group $12 Response $12;
input Group Response N;

datalines;

Vape	ArtNeu	188
Vape	NoNeu	81
NoVape	ArtNeu	395
NoVape	NoNeu	253


;
 
proc freq data=mydata.artframevterm order=data;
   weight N;
   tables Group*Response / chisq;
run;





/************************************************************************************************************************/
/* Headline Frame E-cig by Term */
Proc Freq Data = mydata.news;
	Tables Term*HFEcig;
Run;

/* Headline Frame E-cig and FDA Reg dummy variables */
Data Mydata.news;
	Set Mydata.news;
	/*Ecig dummy*/
		If HFEcig = 1 then PosHFEcig = 1;
		else PosHFEcig = 0;

		If HFEcig = 2 then NegHFEcig = 1;
		else NegHFEcig = 0;

		If HFEcig = 3 then NeuHFEcig = 1;
		else NeuHFEcig = 0;
Run;
	/*Fed Reg dummy*/
Data Mydata.news;
	Set Mydata.news;
		If HFFedReg = 1 then PosHFFedReg = 1;
		else PosHFFedReg = 0;

		If HFFedReg = 4 then PosHFFedReg = .;

		If HFFedReg = 2 then NegHFFedReg = 1;
		else NegHFFedReg = 0;

		If HFFedReg = 4 then NegHFFedReg = .;

		If HFFedReg = 3 then NeuHFFedReg = 1;
		else NeuHFFedReg = 0;

		If HFFedReg = 4 then NeuHFFedReg = .;
Run;

Proc Freq Data = mydata.news;
	Tables HFEcig PosHFEcig NegHFEcig NeuHFecig;
Run;

Proc Freq Data = mydata.news;
	Tables HFFedReg PosHFFedReg NegHFFedReg NeuHFFedReg;
Run;

Data mydata.news;
	Set mydata.news;
		Drop PosHFFedReg NegHFFedReg NeuHFFedReg /*PosHFEcig NegHFEcig NeuHFEcig*/;
Run;

/* Negative HFecig by Vape*/
Proc Freq Data = mydata.news;
	Tables NegHFecig*Vape / chisq;
Run;

/* Neutral HFecig by Vape */
Proc Freq Data = mydata.news;
	Tables NeuHFecig*Vape / chisq;
Run;

/**********************************************************************************************************************/

/* Headline Frame Fed Reg vs Vape */
Proc Freq Data = mydata.news;
	Tables HFFedReg*ArtFrame;
Run;

/* Neutral HFFedReg by Vape */
Proc Freq Data = mydata.news;
	Tables NeuHFFedReg*Vape / chisq;
Run;

/**************************************************************************************************************************/
/* Fed Reg Frame vs Term */
Data Mydata.news;
	Set Mydata.news;
	If FDAFrame = 4 then FDAFrame = .;
Run;

Proc Freq Data = mydata.news;
	Tables FDAFrame*Term;
Run;

/* FDA Frame vs Vape */
Proc Freq Data = mydata.news;
	tables Vape*(FDAPos FDANeg FDANeu) / chisq;
Run;

/**********************************************************************************************************************/

/* Health Risks and Benefits */
Data mydata.news;
	Set mydata.news;
		If Top1 = 1 or Top3 = 1 or Top7 = 1 then HealthRisk = 1;
		else HealthRisk = 0;

		IF Top2 = 1 or Top4 = 1 then HealthBenefit = 1;
		else HealthBenefit = 0;

		If HealthRisk = 1 and HealthBenefit = 1 then HealthBoth = 1;
		else HealthBoth = 0;

		If HealthRisk = 0 and HealthBenefit = 0 then HealthNeither = 1;
		else HealthNeither = 0;

		If HealthRisk = 1 and HealthBenefit = 0 then HealthOnlyRisk = 1;
		else HealthOnlyRisk = 0;

		If HealthRisk = 0 and HealthBenefit = 1 then HealthOnlyBenefit = 1;
		else HealthOnlyBenefit = 0;

Run;

Proc Freq Data = mydata.news;
	Tables HealthBoth HealthNeither HealthOnlyRisk HealthOnlyBenefit;
Run;

data mydata.riskbenefit;
length Group $12 Response $12;
input Group Response N;
/*datalines;
OnlyRisk   Yes  434
OnlyRisk	No   483
OnlyBenefit	Yes  102
OnlyBenefit	No   815
Both	Yes		189
Both	No		728
Neither	Yes		192
Neither	No		725*/
datalines;

Yes	OnlyRisk	434
Yes	OnlyBenefit	102
Yes	Both	189
Yes Neither	192
No	OnlyRisk	483
No	OnlyBenefit	815
No	Both	728
No	Neither	725

;
 
proc freq data=mydata.riskbenefit order=data;
   weight N;
   tables Group*Response / chisq;
run;


Proc Freq Data = mydata.news;
	Tables HealthRisk HealthBenefit;
Run;

/* Let's hope this works */

data mydata.riskbenefit;
length Group $12 Response $3;
input Group Response N;
datalines;
Risk          Yes  623
Risk          No   294
Benefit       Yes  291
Benefit       No   626
;
 
proc freq data=mydata.riskbenefit order=data;
   weight N;
   tables Group*Response / chisq;
run;

/***********************************************************************************************************************/

/* Create a type term with only Informative and Opnion pieces and create a Health risk or benefit binary variable*/
Data Mydata.news;
	Set Mydata.news;
		If Type = 1 then Type2 = 1;
		If Type = 2 then Type2 = 2;
		If Type = 3 then Type2 = .;
		If Type = 4 then Type2 = .;
		If Type = 5 then Type2 = .;
Run;

Data mydata.news;
	Set Mydata.news;
		If Top1 = 1 or Top3 = 1 or Top7 = 1 then Health = 0;
		IF Top2 = 1 or Top4 = 1 then Health = 1;
Run;

/* Health Risk and Benefit by Informative or Opinion Article*/

Proc Freq Data = mydata.news;
	Tables HealthRisk*Type2 HealthBenefit*Type2;
Run;
/* Table 10 */
data mydata.table10combo;
length Group $12 Response $12;
input Group Response N;
datalines;
Risk          News  	568
Risk          Opinion   53
Benefit       News		253
Benefit       Opinion   37
;

proc freq data=mydata.table10combo order=data;
   weight N;
   tables Group*Response / chisq;
run;

/* Creating a dataset for only before deeming and after deeming */

Data mydata.befdem;
	Set mydata.news;
		If BefAftDem = 0;
Run;

Data mydata.aftdem;
	Set mydata.news;
		If BefAftDem = 1;
Run;

/* Health Risk and Benefit by Informative and Opinion for BEFORE DEEMING */
Proc Freq Data = mydata.befdem;
	Tables HealthRisk*Type2 HealthBenefit*Type2;
Run;

data mydata.table10bef;
length Group $12 Response $12;
input Group Response N;
datalines;
Risk          News  	353
Risk          Opinion   154
Benefit       News		44
Benefit       Opinion   31
;

proc freq data=mydata.table10bef order=data;
   weight N;
   tables Group*Response / chisq;
run;

/* Health Risk and Benefit by Informative and Opinion for AFTER DEEMING */
Proc Freq Data = mydata.aftdem;
	Tables HealthRisk*Type2 HealthBenefit*Type2;
Run;

data mydata.table10aft;
length Group $12 Response $12;
input Group Response N;
datalines;
Risk          News  	215
Risk          Opinion   9
Benefit       News		99
Benefit       Opinion   6
;

proc freq data=mydata.table10aft order=data;
   weight N;
   tables Group*Response / chisq;
run;

/**********************************************************************************************************************/
/* Concern for youth or mentioning scientific research increase from before to after */

Proc Freq Data = mydata.news;
	Tables BefAftDem*(Top1 Top7 Top8) / chisq;
Run;

/**********************************************************************************************************************/
/* Framing of FDA by region */

Proc freq data = mydata.news;

	Tables Region*FDAFrameNo4;
	
Run;

/*Chi2 for the various FDA frames */

Proc Freq data = mydata.news;
	Tables FDAPos*Region / chisq;
Run;

Proc Freq data = mydata.news;
	Tables FDANeg*Region / chisq;
Run;

Proc Freq data = mydata.news;
	Tables FDANeu*Region / chisq;
Run;

/*********************TABLE 5 NEW********************************************************************/ 
Proc Sort Data = mydata.news;
	by Type2;
Run;

Proc Freq Data = mydata.news;
	Tables HealthOnlyRisk HealthOnlyBenefit HealthBoth HealthNeither / chisq;
	by Type2;
Run;

data mydata.riskbenefit;
length Group $12 Response $12;
input Group Response N;
/*datalines;
OnlyRisk   Yes  434
OnlyRisk	No   483
OnlyBenefit	Yes  102
OnlyBenefit	No   815
Both	Yes		189
Both	No		728
Neither	Yes		192
Neither	No		725*/
/*datalines;

Yes	OnlyRisk	434
Yes	OnlyBenefit	102
Yes	Both	189
Yes Neither	192
No	OnlyRisk	483
No	OnlyBenefit	815
No	Both	728
No	Neither	725 */
datalines;

News	OHR	398
News	OHB	83
News	Both	170
News	Neither	188
Opinion	OHR	34
Opinion	OHB	18
Opinion	Both	19
Opinion	Neither	3
;
 
proc freq data=mydata.riskbenefit order=data;
   weight N;
   tables Group*Response / chisq;
run;

/* Table 6 NEW*/


data mydata.riskbenefit;
length Group $12 Response $12;
input Group Response N;

datalines;

Ban		News	164
Flavor	News	16
Marketing	News	114
Ban	Opinion	8
Flavor Opinion	0
Marketing Opinion	2


;
 
proc freq data=mydata.riskbenefit order=data;
   weight N;
   tables Group*Response / chisq;
run;

/* Table 6 Neutral Frame FDA oversight vs everything else */

Proc Freq Data = mydata.news;
	Tables FDAFrameNo4;
	by Type2;
Run;

/* Conduct Chi2 */

data mydata.FDAFrame;
length Group $12 Response $12;
input Group Response N;

datalines;

News	Positive	33
News	Negative	39
News	Neutral		291
Opinion Positive	24
Opinion Negative	14
Opinion	Neutral		11

;

/*News	Positive	33
News	Negative	39
News	Neutral		291
Opinion Positive	24
Opinion Negative	14
Opinion	Neutral		11*/
 
proc freq data=mydata.FDAFrame order=data;
   weight N;
   tables Group*Response / chisq;
run;


/* Distribution of e-cig frame among News vs Opinion */

Proc Freq dadta = mydata.news;
	Tables type2*ArtFrame / chisq;
Run;

/* Newspapers */
data mydata.ArtFramebyType;
length Group $12 Response $12;
input Group Response N;

datalines;

News	Positive	51
News	Negative	237
News	Neutral		551
Non Positive	778
Non Negative	602
Non	Neutral		228

;
 
proc freq data=mydata.ArtFramebyType order=data;
   weight N;
   tables Group*Response / chisq;
run;

/* Opinion */
data mydata.ArtFramebyType;
length Group $12 Response $12;
input Group Response N;

datalines;

Opinion	Positive	17
Opinion	Negative	29
Opinion	Neutral		28
Non Positive	57
Non Negative	45
Non	Neutral		46

;
 
proc freq data=mydata.ArtFramebyType order=data;
   weight N;
   tables Group*Response / chisq;
run;

/* Combo new Table 5 */
Proc Sort Data = mydata.news;
	by ArtFrame;
Run;

Proc Freq Data = mydata.news;
	Tables Type2*(HealthOnlyRisk HealthOnlyBenefit HealthBoth HealthNeither);
	by ArtFrame;
Run;
