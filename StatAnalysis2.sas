Libname Mydata "F:\School\G3D\Culminating Project\Stat Analysis";
Run;


/* Table 2 3x2 Chi collective FDA then E-cig */

Proc Freq Data = mydata.news;						/* p-value = 0.5388 */
	Tables BefAftDem*FDAFrameNo4 / chisq;
Run;

Proc Freq Data = mydata.news;						/* p-value = 0.1579 */
	Tables BefAftDem*ArtFrame / chisq;
Run;

/* Table 3 Region total chisq Art Frame*/

Proc Freq Data = mydata.news;						/*P-value = 0.0964*/
	Tables RegionNo5*ArtFrame / chisq;
Run;

/* Make National = missing */

Data mydata.news;
	Set mydata.news;
		If Region = 1 then RegionNo5 = 1;
		If Region = 2 then RegionNo5 = 2;
		If Region = 3 then RegionNo5 = 3;
		If Region = 4 then RegionNo5 = 4;
		If Region = 5 then RegionNo5 = .;
Run;

data mydata.RegionPair;
length Group $12 Region $12;
input Group Region N;

datalines;

Pos	NE	24
Pos	MW	16
Pos	S	12
Pos	W	16
Neg	NE	62
Neg	MW	62
Neg	S	62
Neg	W	78

;

proc freq data=mydata.RegionPair order=data;
   weight N;
   tables Group*Region / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "MW");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "S");
         weight N;
        tables Region*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "S");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("S", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Table 4 */

Proc Freq Data = mydata.news;						/*P-value = <0.0001*/
	Tables RegionNo5*FDAFrameNo4 / chisq;
Run; 

/*Paiwise Positive */
data mydata.RegionPair;
length Group $12 Region $12;
input Group Region N;

datalines;

Pos	NE	25
Pos	MW	12
Pos	S	8
Pos	W	11
NoPos	NE	66
NoPos	MW	102
NoPos	S	106
NoPos	W	79

;
 
proc freq data=mydata.RegionPair order=data;
   weight N;
   tables Group*Region / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "MW");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "S");
         weight N;
        tables Region*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "S");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("S", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;
/* Pairwise Negative */
data mydata.RegionPair;
length Group $12 Region $12;
input Group Region N;

datalines;

Neg	NE	10
Neg	MW	9
Neg	S	27
Neg	W	7
NoNeg	NE	81
NoNeg	MW	105
NoNeg	S	87
NoNeg	W	83

;
 
proc freq data=mydata.RegionPair order=data;
   weight N;
   tables Group*Region / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "MW");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "S");
         weight N;
        tables Region*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "S");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("S", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;
		
proc multtest pdata=chisq bon;
         run;

/* Pairwise Neutral */

data mydata.RegionPair;
length Group $12 Region $12;
input Group Region N;

datalines;

Neg	NE	56
Neg	MW	93
Neg	S	79
Neg	W	72
NoNeg	NE	35
NoNeg	MW	21
NoNeg	S	35
NoNeg	W	18

;
 
proc freq data=mydata.RegionPair order=data;
   weight N;
   tables Group*Region / chisq;
run;

      ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "MW");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "S");
         weight N;
        tables Region*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.RegionPair;
         where Region in ("NE", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "S");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("MW", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.RegionPair;
         where Region in ("S", "W");
         weight N;
         tables Region*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;
/* Table 5 health risks and benefits, no opinion */

/* Creation of combined health risk benefit variable*/
Data mydata.news;
	Set mydata.news;
		If HealthOnlyRisk = 1 then HRB = 0;
		If HealthOnlyBenefit = 1 then HRB = 1;
		If HealthBoth = 1 then HRB = 2;
		If HealthNeither = 1 then HRB = 2;
Run;

Proc Freq Data = mydata.news;
	Tables Type1*HRB / chisq;
Run;

Proc Freq Data = mydata.news;
	Tables Type1*ArtFrame / chisq;
Run;

Data mydata.news;
	Set mydata.news;
		If Type = 1 then Type1 = 1;
		else Type1 = 0;
Run;

Data mydata.newsarticles;
	Set mydata.news;
		If Type1 = 1;
Run;

Proc Freq Data = mydata.newsarticles;
	Tables ArtFrame*HRB;
Run;

/* Check whether there are significantly more risks than both/neither */
data mydata.check;
length Group $12 Topic $12;
input Group Topic N;

datalines;

HR	Y	398
BN	Y	358
HR	N	441
BN	N	481
HB	Y	83
HB	N	756
;
 
proc freq data=mydata.check order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.check;
         where Group in ("HR", "BN");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.check;
         where Group in ("HR", "HB");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.check;
         where Group in ("BN", "HB");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Check neutrality of Both and Neutral */
data mydata.Neutral;
length Group $12 Topic $12;
input Group Topic N;

datalines;

N	Neu	145
N Neg	20
N Pos	5
NN	Neu	25
NN	Neg	150
NN	Pos	165

;
 
proc freq data=mydata.Neutral order=data;
   weight N;
   tables Group*Topic / chisq;
run;
/* Health Topic Chi2 over all and pairwise */

data mydata.HealthTopic;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	NB	358
Yes OR	398
Yes OB	83
No	NB	481
No	OR	441
No	OB	756

;
 
proc freq data=mydata.HealthTopic order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OR");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OB");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("OR", "OB");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Positive Frame */
data mydata.HealthTopic;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	NB	8
Yes OR	0
Yes OB	43
No	NB	51
No	OR	8
No	OB	43

;
 
proc freq data=mydata.HealthTopic order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OR");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OB");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("OR", "OB");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;


/* Negative Frame */
data mydata.HealthTopic;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	NB	32
Yes OR	205
Yes OB	0
No	NB	205
No	OR	32
No	OB	237

;
 
proc freq data=mydata.HealthTopic order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OR");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OB");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("OR", "OB");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;


/* Neutral Frame */

data mydata.HealthTopic;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	NB	318
Yes OR	193
Yes OB	40
No	NB	233
No	OR	358
No	OB	511

;
 
proc freq data=mydata.HealthTopic order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OR");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("NB", "OB");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.HealthTopic;
         where Topic in ("OR", "OB");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;
/* Table 5 Framing Chi2 */

data mydata.T5Frame;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Pos	51
Yes Neg	237
Yes Neu	551
No	Pos	788
No	Neg	602
No	Neu	228

;
 
proc freq data=mydata.T5frame order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T5frame;
         where Topic in ("Pos", "Neg");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.T5frame;
         where Topic in ("Pos", "Neu");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.T5frame;
         where Topic in ("Neu", "Neg");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Table 6 */


/* Check whether there are significantly more risks than both/neither */
data mydata.check;
length Group $12 Topic $12;
input Group Topic N;

datalines;

HR	Y	33
BN	Y	39
HR	N	291
BN	N	330
HB	Y	324
HB	N	72
;
 
proc freq data=mydata.check order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.check;
         where Group in ("HR", "BN");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.check;
         where Group in ("HR", "HB");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.check;
         where Group in ("BN", "HB");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Percent of news articles discussing deeming rule */
Proc Freq Data = mydata.newsarticles;
	Where FDAFrame ne .;
	Tables FDA5;
Run;


/* FDA framing chi2 yes/no */
Proc Freq Data = mydata.newsarticles;
	Tables FDAFrameNo4;
Run;

data mydata.T6Frame;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Pos	33
Yes Neg	39
Yes Neu	291
No	Pos	330
No	Neg	324
No	Neu	72

;
 
proc freq data=mydata.T6frame order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T6frame;
         where Topic in ("Pos", "Neg");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.T6frame;
         where Topic in ("Pos", "Neu");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.T6frame;
         where Topic in ("Neu", "Neg");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

Proc Sort Data = mydata.newsarticles;
	by FDAFrameNo4;
Run;

Proc Freq Data = mydata.newsarticles;
	Where FDAFrameNo4 ne .;
	Tables FDA1 FDA2 FDA4;
		by FDAFrameNo4;
Run;

data mydata.T6top;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Ban	195
Yes Fla	19
Yes Mar	140
No	Ban	644
No	Fla	820
No	Mar	699

;
 
proc freq data=mydata.T6top order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Fla");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Mar");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.T6top;
         where Topic in ("Fla", "Mar");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;



/* Positive Frame towards FDA */
data mydata.T6top;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Ban	14
Yes Fla	3
Yes Mar	10
No	Ban	19
No	Fla	30
No	Mar	23

;
 
proc freq data=mydata.T6top order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Fla");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Mar");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.T6top;
         where Topic in ("Fla", "Mar");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;
/* Negative */
data mydata.T6top;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Ban	17
Yes Fla	0
Yes Mar	15
No	Ban	22
No	Fla	39
No	Mar	24

;
 
proc freq data=mydata.T6top order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Fla");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Mar");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.T6top;
         where Topic in ("Fla", "Mar");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;



/* Neutral */
data mydata.T6top;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Ban	164
Yes Fla	16
Yes Mar	114
No	Ban	127
No	Fla	275
No	Mar	177

;
 
proc freq data=mydata.T6top order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Fla");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      proc freq data=mydata.T6top;
         where Topic in ("Ban", "Mar");
         weight N;
        tables Topic*Group / chisq cellchi2 nopercent;
		run;
      proc freq data=mydata.T6top;
         where Topic in ("Fla", "Mar");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;



/* Table 7 */
Proc Freq Data = mydata.news;			/* 44.6% for vape 26.4% for else p-value = <0.0001 */
	Tables Term*HealthBenefit / chisq;
Run;

Proc Freq Data = mydata.news;			/* 40.15% for vape 79.5% for else p-value = <0.0001 */
	Tables Term*HealthRisk / chisq;
Run;

data mydata.T7;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	108
Yes Else	515
No Vape	161
No Else	133

;
 
proc freq data=mydata.T7 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T7;
         where Topic in ("Vape", "Else");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

Proc Freq Data = mydata.news;
	Tables Term*ArtFrame / chisq;
Run;

/* Positive Frame */
data mydata.T7;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	44
Yes Else	24
No Vape	225
No Else	624

;
 
proc freq data=mydata.T7 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T7;
         where Topic in ("Vape", "Else");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Negative Frame */
data mydata.T7;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	37
Yes Else	229
No Vape	232
No Else	419

;
 
proc freq data=mydata.T7 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T7;
         where Topic in ("Vape", "Else");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Neutral Frame */
data mydata.T7;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	188
Yes Else	395
No Vape	81
No Else	217

;
 
proc freq data=mydata.T7 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

/* Table 8 */
Proc Freq Data = mydata.news;
	Tables Term*FDAFrameNo4 / chisq;
Run;

/* Positive Frame */
data mydata.T8;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	4
Yes E-cig	53
No Vape	89
No E-cig	267


;
 
proc freq data=mydata.T8 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T8;
         where Topic in ("Vape", "E-cig");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Negative Frame */
data mydata.T8;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	28
Yes E-cig	25
No Vape	65
No E-cig	295

;
 
proc freq data=mydata.T8 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T8;
         where Topic in ("Vape", "E-cig");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;

/* Neutral Frame */
data mydata.T8;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	Vape	61
Yes E-cig	242
No Vape	32
No E-cig	81

;
 
proc freq data=mydata.T8 order=data;
   weight N;
   tables Group*Topic / chisq;
run;

     ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
      proc freq data=mydata.T8;
         where Topic in ("Vape", "E-cig");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;
      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;
/* New Table 5 */

Proc Freq Data = mydata.news;
	Table HRB*Type2 / chisq;
Run;

Proc Freq Data = mydata.news;
	Table ArtFrame*Type2 / chisq;
Run;


/* Health Risks only */
ods output chisq(persist)=chisq(where=(statistic="Chi-Square")
                                      rename=(Prob=Raw_P));
data mydata.newT5;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	News	398
No	News	441
Yes	Opinion	34
No	Opinion	40

;
 



      proc freq data=mydata.newT5;
         where Topic in ("News", "Opinion");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;

/* Health Benefits */
data mydata.newT5;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	News	83
No	News	756
Yes	Opinion	18
No	Opinion	56

;
 



      proc freq data=mydata.newT5;
         where Topic in ("News", "Opinion");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;

/* Neutral */
data mydata.newT5;
length Group $12 Topic $12;
input Group Topic N;

datalines;

Yes	News	358
No	News	481
Yes	Opinion	22
No	Opinion	52

;
 



      proc freq data=mydata.newT5;
         where Topic in ("News", "Opinion");
         weight N;
         tables Topic*Group / chisq cellchi2 nopercent;
         run;

      ods output clear;

      proc print noobs;
         var value raw_p;
         run;

proc multtest pdata=chisq bon;
         run;


/* Determining % concern for youth overall and concern for youth in neutral frame articles */

Proc Freq data = mydata.news;
	Tables Top7;
Run;

Proc Freq data = mydata.news;
	Tables Top7*Artframe;
Run;
