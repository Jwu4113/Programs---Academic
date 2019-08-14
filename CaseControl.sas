/* Case Control Assignment */

Libname Mydata "F:\School\G3D\Epi III\CaseControl Final Project";

/* Creation of Variables */

/* PNC5 */
Data Mydata.caco20141;
	Set Mydata.caco20141;

	if (prenatal <= 5 and prenatal > 0) then pnc5 = 1;
	if (prenatal >= 6 or prenatal = 0) then pnc5 = 0;
	if prenatal = 99 then pnc5 = .;
	if prenatal = . then pnc5 = .;

	/* if (prenatal = 0) then pnc5 = .; */
Run;

/* raceth2 */
Data Mydata.caco20141;
	Set Mydata.caco20141;
		if (race = 1 and hispmom = 'N') then raceth2 = 0;
		if (race = 1 and hispmom = 'Y') then raceth2 = 1;
		if (race = 2) then raceth2 = 2;
		if (race = 0 or race = 3 or race = 4 or race = 5 or race = 6 or race = 7 or race = 8) then raceth2 = 3;
Run;

/* race2 */
Data Mydata.caco20141;
	Set Mydata.caco20141;
		if (race = 1 and hispmom = 'N') then race2 = 0;
		else race2 = 1;
Run;

/* smoker */

Data Mydata.caco20141;
	Set Mydata.caco20141;
		if cigdur = 'N' then smoker = 0;
		if cigdur = 'Y' then smoker = 1;
		if cigdur = 'U' then smoker = .;
Run;

/*                                     */

/* Age 40 over combined into one category. Age 17 and less combined into one category, everything else same (New Variable) */

/* Creation of the 17 and less */
Data Mydata.caco20141;
	Set Mydata.caco20141;
	
	if mage <= 17 then mage17 = mage;
	else mage17 = .;
Run;

/* Creation of the 40 and more */
Data Mydata.caco20141;
	Set Mydata.caco20141;
	
	if mage >= 40 then mage40 = mage;
	else mage40 = .;
Run;

Proc Means Data = Mydata.caco20141 mean;
	Var mage17 mage40;
Run;

/* mage2 */
Data Mydata.caco20141;
	Set Mydata.caco20141;
		if mage <= 17 then mage2 = 16.1;
		if mage >= 40 then mage2 = 41.3;
		if mage > 17 and mage < 40 then mage2 = mage;
Run;

/* magecat */
Data Mydata.caco20141;
	Set Mydata.caco20141;
		if mage < 20 then magecat = 0;
		if mage >= 20 and mage <= 24 then magecat = 1;
		if mage >= 25 and mage <= 29 then magecat = 2;
		if mage >= 30 and mage <= 34 then magecat = 3;
		if mage >= 35 and mage <= 39 then magecat = 4;
		if mage >= 40 then magecat = 5;
Run;

/* mage2sp */
Data mydata.caco20141;
	Set mydata.caco20141;
	magesq = mage2*mage2;
Run;

Data mydata.caco20141;
	Set mydata.caco20141;

	If mage>18 Then mageqs18=(mage2-18)*(mage2-18);
		else mageqs18 = 0;
	If mage>20 Then mageqs20=(mage2-20)*(mage2-20);
		else mageqs20 = 0;
	If mage>35 Then mageqs35=(mage2-35)*(mage2-35);
		else mageqs35 = 0;
	If mage>39 Then mageqs39=(mage2-39)*(mage2-39);
		else mageqs39 = 0;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model preterm = mage2 magesq mageqs18 mageqs20 mageqs35 mageqs39 / link=log dist = binomial;
	Output out=mydata.cc_1 p=pred l=l95m u=u95m;
	Title "Quadratic Spline";
Run;

/* Gravidity */
/* totalp -> grav3*/

Data mydata.caco20141;
	Set mydata.caco20141;
		if totalp = 1 then grav3 = 1;
		if totalp = 2 then grav3 = 2;
		if totalp > 2 then grav3 = 3;
		if totalp = 99 then grav3 = .;
Run;

/* A1 */
/* Create a table  Counts and Proportions */

/* Split dataset into two by case vs control */
Data Mydata.case;
	Set mydata.caco20141;
		if case = 1 then output;
Run;
Data Mydata.control;
	Set mydata.caco20141;
		if case = 0 then output;
Run;

/* Control */
Proc Freq Data = mydata.control;
	Tables pnc5 smoker raceth2 grav3 magecat;
Run;

/* Case */
Proc Freq Data = mydata.case;
	Tables pnc5 smoker raceth2 grav3 magecat;
Run;

/* B */ /* FIND OUT FROM OTHER PEOPLE HOW TO DO THIS. I HAVE NOT FIGURED IT OUT */
/* Creating a restricted quadratic spline variables upper and lower tail based on mage2sp with knots at 18, 20, 35, and 39*/

Data mydata.caco20141;
	Set mydata.caco20141;

	If mage GT 18 THEN magers18 = (mageqs18)-(mageqs39);
		Else magers18=0;
	If mage GT 20 THEN magers20 = (mageqs20)-(mageqs39);
		Else magers20=0;
	If mage GT 35 THEN magers35 = (mageqs35)-(mageqs39);
		Else magers35=0;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = mage2 magers18 magers20 magers35/ link=log dist = binomial;
	*Estimate 'RR 18 vs 28' mage2 -10 magers18 -100 magers29 0 /e;
	*Estimate 'RR 39 vs 28' mage2 11 magers18 325 magers29 84 /e;
	Output out=mydata.b1 p=pred l=l95m u=u95m xbeta = lnodds stdxbeta = stdlodds;
	Title "Upper and Lower Tail Restricted Quadratic Spline";
Run;

Goptions reset=all rotate=landscape ftitle=swiss ftext=swiss gunit=pct htitle=3 htext=3;
	symbol1 v=dot /*i=j*/ l=1 w=1 height=2;
	symbol2 v=dot /*i=j*/ l=33 w=1 height=2;
	axis1 label=('Maternal age (years)') w=3 order=(10 to 50 by 10);
	axis2 label=(a=90 'Estimated Risk (95% CI) of Preterm Birth') w=3 order=(0.00 to 1.00 by 0.10);

Proc Gplot data = mydata.b1;
	Plot pred*mage2=1 l95m*mage2=2 u95m*mage2=2 / overlay frame vaxis=axis2 haxis=axis1;

	Title1 'Risk (95% CI) of Preterm Birth by Maternal Age(Years)';
	Title2 'Maternal Age with Upper and Lower Tail Restricted Quadratic Spline Coding';
Run;

/* C2 */
/* Exploratory Analysis of Mage2 Magecat Mage2sp */

Proc Genmod data = mydata.caco20141 descending;
	Model case = mage2 / link=logit dist = binomial;
	Output out=mydata.c21 p=pred l=l95m u=u95m;
	Title "Linear Risk Model for Linear Age";
Run;

Goptions reset=all rotate=landscape ftitle=swiss ftext=swiss gunit=pct htitle=3 htext=3;
	symbol1 v=dot /*i=j*/ l=1 w=1 height=2;
	symbol2 v=dot /*i=j*/ l=33 w=1 height=2;
	axis1 label=('Maternal age (years)') w=3 order=(10 to 50 by 10);
	axis2 label=(a=90 'Estimated Risk (95% CI) of Preterm Birth') w=3 order=(0.00 to 1.00 by 0.10);

Proc Gplot data = mydata.c21;
	Plot pred*mage2=1 l95m*mage2=2 u95m*mage2=2 / overlay frame vaxis=axis2 haxis=axis1;

	Title1 'Risk (95% CI) of Preterm Birth by Maternal Age(Years)';
	Title2 'Maternal Age with Linear Continuous';
Run;

/* Creation of disjoint magecat*/
Data mydata.caco20141;
	Set mydata.caco20141;
	if magecat = 0 then magecat0 = 1;
		else magecat0 = 0;
	if magecat = 1 then magecat1 = 1;
		else magecat1 = 0;
	if magecat = 2 then magecat2 = 1;
		else magecat2 = 0;
	if magecat = 3 then magecat3 = 1;
		else magecat3 = 0;
	if magecat = 4 then magecat4 = 1;
		else magecat4 = 0;
	if magecat = 5 then magecat5 = 1;
		else magecat5 = 0;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = magecat1 magecat2 magecat3 magecat4 magecat5 / link=logit dist = binomial;
	Output out=mydata.c22 p=pred l=l95m u=u95m;
	Title "Linear Risk Model for Categorical Age";
Run;

Goptions reset=all rotate=landscape ftitle=swiss ftext=swiss gunit=pct htitle=3 htext=3;
	symbol1 v=dot /*i=j*/ l=1 w=1 height=2;
	symbol2 v=dot /*i=j*/ l=33 w=1 height=2;
	axis1 label=('Maternal age (years)') w=3 order=(10 to 50 by 10);
	axis2 label=(a=90 'Estimated Risk (95% CI) of Preterm Birth') w=3 order=(0.00 to 1.00 by 0.10);

Proc Gplot data = mydata.c22;
	Plot pred*mage2=1 l95m*mage2=2 u95m*mage2=2 / overlay frame vaxis=axis2 haxis=axis1;

	Title1 'Risk (95% CI) of Preterm Birth by Maternal Age(Years)';
	Title2 'Maternal Age with Categorical';
Run;


Proc Genmod data = mydata.caco20141 descending;
	Model case = mage2 magers18 magers20 magers35 / link=logit dist = binomial;
	Output out=mydata.c23 p=pred l=l95m u=u95m;
	Title "Linear Risk Model for quadratic spline Age";
Run;

Goptions reset=all rotate=landscape ftitle=swiss ftext=swiss gunit=pct htitle=3 htext=3;
	symbol1 v=dot /*i=j*/ l=1 w=1 height=2;
	symbol2 v=dot /*i=j*/ l=33 w=1 height=2;
	axis1 label=('Maternal age (years)') w=3 order=(10 to 50 by 10);
	axis2 label=(a=90 'Estimated Risk (95% CI) of Preterm Birth') w=3 order=(0.00 to 1.00 by 0.10);

Proc Gplot data = mydata.c23;
	Plot pred*mage2=1 l95m*mage2=2 u95m*mage2=2 / overlay frame vaxis=axis2 haxis=axis1;

	Title1 'Risk (95% CI) of Preterm Birth by Maternal Age(Years)';
	Title2 'Maternal Age with Categorical';
Run;


/* C3 */
/* Redo totalp so that 99 = missing*/
Data Mydata.caco20141;
	Set Mydata.caco20141;
	if totalp = 99 then totalp = .;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = totalp / link=logit dist = binomial;
	Output out=mydata.c31 p=pred l=l95m u=u95m;
	Title "Linear Risk Model for continous total preg";
Run;

Goptions reset=all rotate=landscape ftitle=swiss ftext=swiss gunit=pct htitle=3 htext=3;
	symbol1 v=dot /*i=j*/ l=1 w=1 height=2;
	symbol2 v=dot /*i=j*/ l=33 w=1 height=2;
	axis1 label=('Total Pregnancies') w=3 order=(0 to 20 by 2);
	axis2 label=(a=90 'Estimated Risk (95% CI) of Preterm Birth') w=3 order=(0.00 to 1.00 by 0.10);

Proc Gplot data = mydata.c31;
	Plot pred*totalp=1 l95m*totalp=2 u95m*totalp=2 / overlay frame vaxis=axis2 haxis=axis1;

	Title1 'Risk (95% CI) of Preterm Birth by Maternal Age(Years)';
	Title2 'Total Pregnancy';
Run;


/* Creating disjoint for gravidity */
Data Mydata.caco20141;
	Set Mydata.caco20141;
	if grav3 = 0 then grac30 = 1;
		else grave30 = 0;
	if grav3 = 1 then grav31 = 1;
		else grav31 = 0;
	if grav3 = 2 then grav32 = 1;
		else grav32 = 0;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case =  grav31 grav32 / link=identity dist = binomial;
	Output out=mydata.c32 p=pred l=l95m u=u95m;
	Title "Linear Risk Model for quadratic spline Age";
Run;

Goptions reset=all rotate=landscape ftitle=swiss ftext=swiss gunit=pct htitle=3 htext=3;
	symbol1 v=dot /*i=j*/ l=1 w=1 height=2;
	symbol2 v=dot /*i=j*/ l=33 w=1 height=2;
	axis1 label=('Gravidity') w=3 order=(0 to 20 by 2);
	axis2 label=(a=90 'Estimated Risk (95% CI) of Preterm Birth') w=3 order=(0.00 to 1.00 by 0.10);

Proc Gplot data = mydata.c32;
	Plot pred*grav3=1 l95m*grav3=2 u95m*grav3=2 / overlay frame vaxis=axis2 haxis=axis1;

	Title1 'Risk (95% CI) of Preterm Birth by Maternal Age(Years)';
	Title2 'Gravidity';
Run;

/* C4 */
/* Constancy or Homogeneity */

/* testing smoking */
Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 smoker pnc5*smoker / link=logit dist = binomial;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 smoker/ link=logit dist = binomial;
Run;

/* testing raceth2 */
Data mydata.caco20141;
	Set mydata.caco20141;
	if raceth2 = 0 then racewnh = 1;
		else racewnh = 0;
	if raceth2 = 1 then racewh = 1;
		else racewh = 0;
	if raceth2 = 2 then raceaa = 1;
		else raceaa = 0;
	if raceth2 = 3 then raceo = 1;
		else raceo = 0;
Run;


Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 racewh raceaa raceo racewh*pnc5 raceaa*pnc5 raceo*pnc5 / link=logit dist = binomial;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 racewh raceaa raceo/ link=logit dist = binomial;
Run;

/* magecat evaluation */
Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 magecat1 magecat2 magecat3 magecat4 magecat5 magecat1*pnc5 magecat2*pnc5 magecat3*pnc5 magecat4*pnc5 magecat5*pnc5 / link=logit dist = binomial;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 magecat1 magecat2 magecat3 magecat4 magecat5/ link=logit dist = binomial;
Run;

/* Testing grav3 */
Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 grav31 grav32 grav31*pnc5 grav32*pnc5 / link=logit dist = binomial;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 grav31 grav32/ link=logit dist = binomial;
Run;

/* C5 */

/* Model Selection Backwards Selection */
Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 smoker racewh raceaa raceo magecat1 magecat2 magecat3 magecat4 magecat5 grav31 grav32/ link=logit dist = binomial;
Run;

/* Removing first variable */
Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 racewh raceaa raceo magecat1 magecat2 magecat3 magecat4 magecat5 grav31 grav32/ link=logit dist = binomial;
Run;

Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 smoker magecat1 magecat2 magecat3 magecat4 magecat5 grav31 grav32/ link=logit dist = binomial;
Run;

Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 smoker racewh raceaa raceo grav31 grav32/ link=logit dist = binomial;
Run;

Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 smoker racewh raceaa raceo magecat1 magecat2 magecat3 magecat4 magecat5/ link=logit dist = binomial;
Run;

/* All significant Do not remove */

/* Produce OR and 95% CI for association between prenatal care and preterm birth */

Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 smoker racewh raceaa raceo magecat1 magecat2 magecat3 magecat4 magecat5 grav31 grav32/ link=logit dist = binomial;
	estimate "OR" pnc5 1 / exp;
	ods select estimates;
Run;

/* D */

/* Creation of the Combination Variable between race2 and pnc5 */
Data Mydata.caco20141;
	Set Mydata.caco20141;
		If pnc5 = 0 and race2 = 0 then pncrace00 = 1;
			else pncrace00 = 0;
		If pnc5 = 1 and race2 = 0 then pncrace10 = 1;
			else pncrace10 = 0;
		If pnc5 = 0 and race2 = 1 then pncrace01 = 1;
			else pncrace01 = 0;
		If pnc5 = 1 and race2 = 1 then pncrace11 = 1;
			else pncrace11 = 0;
Run;

/* Finding the OR bewteen all and the reference category */ /* PNC5 vs RACETH2*/


Proc Genmod data = mydata.caco20141 descending;
	Model case = pncrace10 pncrace01 pncrace11 / link=logit dist = binomial;
	estimate 'OR 10 vs 00' pncrace10 1 pncrace01 0 pncrace11 0 / exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncrace10 pncrace01 pncrace11 / link=logit dist = binomial;
	estimate 'OR 01 vs 00' pncrace10 0 pncrace01 1 pncrace11 0 / exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncrace10 pncrace01 pncrace11 / link=logit dist = binomial;
	estimate 'OR 11 vs 00' pncrace10 0 pncrace01 0 pncrace11 1 / exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncrace10 pncrace01 pncrace11 / link=logit dist = binomial covb;
Run;
/* Creation of the Combination Variable between smoke and pnc5 */
Data Mydata.caco20141;
	Set Mydata.caco20141;
		If pnc5 = 0 and smoker = 0 then pncs00 = 1;
			else pncs00 = 0;
		If pnc5 = 1 and smoker = 0 then pncs10 = 1;
			else pncs10 = 0;
		If pnc5 = 0 and smoker = 1 then pncs01 = 1;
			else pncs01 = 0;
		If pnc5 = 1 and smoker = 1 then pncs11 = 1;
			else pncs11 = 0;
Run;
/* PNC5 vs Smoker */

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncs10 pncs01 pncs11 / link=logit dist = binomial;
	estimate 'OR 10 vs 00' pncs10 1 pncs01 0 pncs11 0 / exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncs10 pncs01 pncs11 / link=logit dist = binomial;
	estimate 'OR 01 vs 00' pncs10 0 pncs01 1 pncs11 0 / exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncs10 pncs01 pncs11 / link=logit dist = binomial;
	estimate 'OR 11 vs 00' pncs10 0 pncs01 0 pncs11 1 / exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pncs10 pncs01 pncs11 / link=logit dist = binomial covb;
Run;

/* Crude OR */

Proc Genmod data = mydata.caco20141 descending;
	Model case = pnc5 / link=logit dist = binomial covb;
	estimate 'OR' pnc5 1 / exp;
	ods select estimates;
Run;

/* Adjusted OR */
Proc Genmod Data = mydata.caco20141 descending;
	Model case = pnc5 smoker racewh raceaa raceo magecat1 magecat2 magecat3 magecat4 magecat5/ link=logit dist = binomial;
	estimate "OR" pnc5 1 / exp;
Run;


/* Stratum specific Analysis, first Strata by race */
/* Create the Indicator Variables */
Data mydata.caco20141;
	Set mydata.caco20141;
	
		if pnc5 = 0 and raceth2 = 0 then pre0 = 1;
		else pre0 = 0;
		if pnc5 = 1 and raceth2 = 0 then pre1 = 1;
		else pre1 = 0;
		if pnc5 = 0 and raceth2 = 1 then pre2 = 1;
		else pre2 = 0;
		if pnc5 = 1 and raceth2 = 1 then pre3 = 1;
		else pre3 = 0;
		if pnc5 = 0 and raceth2 = 2 then pre4 = 1;
		else pre4 = 0;
		if pnc5 = 1 and raceth2 = 2 then pre5 = 1;
		else pre5 = 0;
		if pnc5 = 0 and raceth2 = 3 then pre6 = 1;
		else pre6 = 0;
		if pnc5 = 1 and raceth2 = 3 then pre7 = 1;
		else pre7 = 0;
Run;

/* Use Proc Genmod to create the OR between each race with or without prenatal care */
Proc Genmod data = mydata.caco20141 descending;
	Model case = pre1 pre2 pre3 pre4 pre5 pre6 pre7 / link = logit dist=binomial;
	estimate 'OR WNH pnc vs no pnc'	pre1 1 pre2 0 pre3 0 pre4 0 pre5 0 pre6 0 pre7 0 /exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = pre1 pre2 pre3 pre4 pre5 pre6 pre7 / link = logit dist=binomial;
	estimate 'OR WH pnc vs no pnc'	pre1 0 pre2 -1 pre3 1 pre4 0 pre5 0 pre6 0 pre7 0 /exp;
	ods select estimates;
Run;
Proc Genmod data = mydata.caco20141 descending;
	Model case = pre1 pre2 pre3 pre4 pre5 pre6 pre7 / link = logit dist=binomial;
	estimate 'OR AA pnc vs no pnc'	pre1 0 pre2 0 pre3 0 pre4 -1 pre5 1 pre6 0 pre7 0 /exp;
	ods select estimates;
Run;
Proc Genmod data = mydata.caco20141 descending;
	Model case = pre1 pre2 pre3 pre4 pre5 pre6 pre7 / link = logit dist=binomial;
	estimate 'OR O pnc vs no pnc'	pre1 0 pre2 0 pre3 0 pre4 0 pre5 0 pre6 -1 pre7 1 /exp;
	ods select estimates;
Run;

/* Use Proc Genmod to create the OR between SMoking status with or without prenatal care */
Data mydata.caco20141;
	Set mydata.caco20141;
		if pnc5 = 0 and smoker = 0 then ps0 = 1;
		else ps0 = 0;
		if pnc5 = 1 and smoker = 0 then ps1 = 1;
		else ps1 = 0;
		if pnc5 = 0 and smoker = 1 then ps2 = 1;
		else ps2 = 0;
		if pnc5 = 1 and smoker = 1 then ps3 = 1;
		else ps3 = 0;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = ps1 ps2 ps3 / link = logit dist=binomial;
	estimate 'OR S pnc vs no pnc' ps1 1 ps2 0 ps3 0 /exp;
	ods select estimates;
Run;

Proc Genmod data = mydata.caco20141 descending;
	Model case = ps1 ps2 ps3 / link = logit dist=binomial;
	estimate 'OR NS pnc vs no pnc' ps1 0 ps2 -1 ps3 1 /exp;
	ods select estimates;
Run;
