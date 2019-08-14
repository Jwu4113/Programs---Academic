libname mydata "/folders/myfolders/sasuser.v94/PQHS515/Project/Data";
options nofmterr;

/* Importing the STC file 
filename nsduh "/folders/myfolders/sasuser.v94/PQHS515/Project/Data/NSDUH_2016-data-sas.stc";

proc cimport
	infile= nsduh
	library= mydata
	isfileutf8= true;
run;
*/

/* Obtain only variables that are needed */
/* Data mydata.NSDUHTest; */
/* 	Set mydata.NSDUH2016; */
/* 		KEEP FENTPDAPYU FENTPDPYMU AGE2 IRSEX IREDUHIGHST2 COUTYP4 NEWRACE2;  */
/* Run; */
/*  */
/* Remove any observations without Complete Cases. All Cases should already be complete However */
/* Data Mydata.NSDUHTest; */
/* 	Set Mydata.NSDUHTEST; */
/* 		If cmiss (of _all_ ) then delete; */
/* Run; */

/* Data was clearned already, no more cleaning necessary */

/* Creating Formats so the Data is easier to Read */

Proc Format;
	Value Sex
		1 = "Male"
		2 = "Female";
	Value FentY
		1 = "Yes"
		0 = "No";
	Value FentM
		1 = "Yes"
		0 = "No";	
	Value Race
		1 = "NonHisp White"
		2 = "NonHisp Black/Afr Am"
		3 = "NonHisp Other"
		4 = "Hispanic";

Run;

Data Mydata.NSDUHTest;
	Set mydata.nsduhtest;
		Format IRSEX Sex. FENTPDAPYU FentY. FENTPDPYMU FentM. NEWRACE2 Race.;
Run;

/* Recategorizing Race */

Data Mydata.NSDUHtest;
	Set Mydata.nsduhtest;
		If Newrace2 = 1 then Race = 1;
		If Newrace2 = 2 then Race = 2;
		If Newrace2 = 3 then Race = 3;
		If Newrace2 = 4 then Race = 3;
		If Newrace2 = 5 then Race = 3;
		If Newrace2 = 6 then Race = 3;
		If Newrace2 = 7 then Race = 4;
		
		Format Race Race.;
Run;

/* Recategorizing Age */
Proc Format;
	Value NewAge
			1 = "< 18"
			2 = "18-25"
			3 = "26-34"
			4 = "35-49"
			5 = "50-64"
			6 = "65+";
Run;


Data Mydata.NSDUHTest;
	Set Mydata.NSDUHTest;
		If Age2 < 7 then NewAge = 1;
		If Age2 >= 7 and Age2 <= 12 then NewAge = 2;
		If Age2 >= 13 and Age2 <= 14 then NewAge = 3;
		If Age2 = 15 then NewAge = 4;
		If Age2  = 16 then NewAge = 5;
		If Age2 >= 17 then NewAge = 6;
		
	Format NewAge NewAge.;
Run;

/* Recategorizing Education */

Proc Format;
	Value Edu
		1 = "Did not Complete High School"
		2 = "High School Diploma"
		3 = "Some College, No Degree"
		4 = "Associate's Degree"
		5 = "Bachelor's or Higher";
Run;

Data Mydata.NSDUHTest;
	Set mydata.NSDUHTest;
		If IREDUHIGHST2 <= 7 then Edu = 1;
		If IREDUHIGHST2 = 8 then Edu = 2;
		If IREDUHIGHST2 = 9 then Edu = 3;
		If IREDUHIGHST2 = 10 then Edu = 4;
		If IREDUHIGHST2 = 11 then Edu = 5;
	
	Format Edu Edu.;
Run;

/* Recategorizing Metropolitan Status */

Proc Format;
	Value Metro
		1 = "Metropolitan"
		0 = "Non-Metropolitan";
Run;

Data Mydata.NSDUHTest;
	Set Mydata.nsduhtest;
		If COUTYP4 = 1 or COUTYP4 = 2 then Metro = 1;
		Else Metro = 0;
		
		Format Metro Metro.;
Run;

/* Running Format Section */

Proc Format;
		Value Metro
		1 = "Metropolitan"
		0 = "Non-Metropolitan";
		Value Edu
		1 = "Did not Complete High School"
		2 = "High School Diploma"
		3 = "Some College, No Degree"
		4 = "Associates Degree"
		5 = "Bachelors or Higher";
		Value NewAge
			1 = "< 18"
			2 = "18-25"
			3 = "26-34"
			4 = "35-49"
			5 = "50-64"
			6 = "65+";
		Value Sex
		1 = "Male"
		2 = "Female";
	Value FentY
		1 = "Yes"
		0 = "No";
	Value FentM
		1 = "Yes"
		0 = "No";	
	Value Race
		1 = "NonHisp White"
		2 = "NonHisp Black/Afr Am"
		3 = "NonHisp Other"
		4 = "Hispanic";
Run;

Data Mydata.NSDUHTest;
	Set mydata.nsduhtest;
		Format IRSEX Sex. FENTPDAPYU FentY. FENTPDPYMU FentM. Race Race. Edu Edu. Metro Metro.;
Run;

/* Chi-Square Analysis (No Adjusting, just against one Variable)*/

/* Taking Legal Fentanyl vs Age Groups */

Proc Freq Data = Mydata.NSDUHTest;
	Table FENTPDAPYU*NewAge / chisq;  /* p-value <0.0001 Have to go furthur into the data */
Run;

/* Taking Legal Fentanyl vs Sex */

Proc Freq Data = Mydata.NSDUHTest;
	Table FENTPDAPYU*IRSEX / chisq;  /* p-value 0.0005 Significant Difference, Females Higher Proportion */
Run;

/* Taking Legal Fentanyl vs Education */

Proc Freq Data = Mydata.NSDUHTest;
	Table FENTPDAPYU*Edu / chisq;  /* p-value <0.0001 Have to go furthur into the data */
Run;

/* Taking Legal Fentanyl vs Metropolitan Status */

Proc Freq Data = Mydata.NSDUHTest;
	Table FENTPDAPYU*Metro / chisq;  /* p-value 0.0105 Significant Difference, NonMetro Higher Proportion */
Run;

/* Taking Legal Fentanyl vs Race */ /* CAUTION, LOW COUNTS IN SOME CATEGORIES */

Proc Freq Data = Mydata.NSDUHTest;
	Table FENTPDAPYU*Race / chisq;  /* p-value <0.0001 Have to go furthur into the data */
Run;

/* Pairwise Analysis - Age Group */

DATA mydata.AgePair; 
   INFILE DATALINES DSD; 
   INPUT FENTP $ AGEP	$ N; 
   
datalines;
Yes,<18,31
Yes,18-25,83
Yes,26-34,74
Yes,35-49,107
Yes,50-64,42
Yes,65+,30
No,<18,14241
No,18-25,13577
No,26-34,8677
No,35-49,11254
No,50-64,5199
No,65+,3562
;

proc freq data=mydata.AgePair order=data;
   weight N;
   tables FENTP*AGEP / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.AgePair;	/* <0.0001 */
         where AGEP in ("<18", "18-25"); 
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;	/* <0.0001 */
         where AGEP in ("<18", "26-34");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;	/* <0.0001 */
         where AGEP in ("<18", "35-49");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;	/* <0.0001 */
         where AGEP in ("<18", "50-64");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;	/* <0.0001 */
         where AGEP in ("<18", "65+");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("18-25", "26-34");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;	/* 0.0364 */
         where AGEP in ("18-25", "35-49");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("18-25", "50-64");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("18-25", "65+");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;	/* No significant Difference between 26-34 and all other groups, except for <18 */
         where AGEP in ("26-34", "35-49");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("26-34", "50-64");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("26-34", "65+");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("35-49", "50-64");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("35-49", "65+");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.AgePair;
         where AGEP in ("50-64", "65+");
         weight N;
         tables FENTP*AGEP / chisq cellchi2 nopercent;
      run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Pairwise Analysis  - Education */

DATA mydata.EduPair; 
   INFILE DATALINES DSD; 
   INPUT FENTP $ EDUP	$ N; 
   
datalines;
Yes,NoHS,87
Yes,HS,93
Yes,SCND,92
Yes,AD,33
Yes,BDAU,62
No,NoHS,19538
No,HS,11327
No,SCND,10467
No,AD,3860
No,BDAU,11338
;

proc freq data=mydata.EduPair order=data;
   weight N;
   tables FENTP*EDUP / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.EduPair;	/* 0.0003*/ /* NoHS almost significant against all groups */
         where EduP in ("NoHS", "HS"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	/* <0.0001 */
         where EduP in ("NoHS", "SCND"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("NoHS", "AD"); /* 0.0122 */
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("NoHS", "BDAU"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("HS", "SCND"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("HS", "AD"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("HS", "BDAU"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("SCND", "AD"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	/* 0.0367 */
         where EduP in ("SCND", "BDAU"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.EduPair;	
         where EduP in ("AD", "BDAU"); 
         weight N;
         tables FENTP*EduP / chisq cellchi2 nopercent;
      run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Pairwise Analysis - Race */

DATA mydata.RacePair; 
   INFILE DATALINES DSD; 
   INPUT FENTP $ RaceP	$ N; 
   
datalines;
Yes,W,267
Yes,AA,34
Yes,O,32
Yes,Hisp,34
No,W,33412
No,AA,7284
No,O,5701
No,Hisp,10153
;

proc freq data=mydata.RacePair order=data;
   weight N;
   tables FENTP*RaceP / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.RacePair;	/* No clear Difference bewteen Whites and Others */
         where RaceP in ("W", "AA"); 
         weight N;
         tables FENTP*RaceP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.RacePair;	
         where RaceP in ("W", "O"); 
         weight N;
         tables FENTP*RaceP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.RacePair;	
         where RaceP in ("W", "Hisp"); 
         weight N;
         tables FENTP*RaceP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.RacePair;	
         where RaceP in ("AA", "O"); 
         weight N;
         tables FENTP*RaceP / chisq cellchi2 nopercent;
      run;     
      proc freq data=mydata.RacePair;	
         where RaceP in ("AA", "Hisp"); 
         weight N;
         tables FENTP*RaceP / chisq cellchi2 nopercent;
      run;
      proc freq data=mydata.RacePair;	
         where RaceP in ("O", "Hisp"); 
         weight N;
         tables FENTP*RaceP / chisq cellchi2 nopercent;
      run;
        ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;
         
/* Perhaps Run Logistic Model Using all Covariates */ /* Run Formatting Before Running This*/

proc logistic data=mydata.nsduhtest;
  class IRSEX (Ref = 'Male') Race (Ref = 'NonHisp White') NEWAGE (Ref = '26-34') EDU (Ref = 'Did not Complete High School') METRO (Ref = 'Metropolitan');
  model FENTPDAPYU (event = "Yes") = IRSEX Race NEWAGE EDU METRO ;
run;

/* Testing Various Age */
proc logistic data=mydata.nsduhtest;
  class IRSEX (Ref = 'Female') Race (Ref = 'NonHisp White') NEWAGE (Ref = '< 18') EDU (Ref = 'Did not Complete High School') METRO (Ref = 'Metropolitan');
  model FENTPDAPYU (event = "Yes") = IRSEX Race NEWAGE EDU METRO ;
run;

/* Testing Various Education */
proc logistic data=mydata.nsduhtest;
  class IRSEX (Ref = 'Male') Race (Ref = 'NonHisp White') NEWAGE (Ref = '26-34') EDU (Ref = 'Bachelors or Higher') METRO (Ref = 'Metropolitan');
  model FENTPDAPYU (event = "Yes") = IRSEX Race NEWAGE EDU METRO ;
run;

/* Testing Race */

proc logistic data=mydata.nsduhtest;
  class IRSEX (Ref = 'Male') Race (Ref = 'Hispanic') NEWAGE (Ref = '26-34') EDU (Ref = 'Did not Complete High School') METRO (Ref = 'Metropolitan');
  model FENTPDAPYU (event = "Yes") = IRSEX Race NEWAGE EDU METRO ;
run;