/*Original data File_1*/
Filename F1'C:\Users\mk2101\OneDrive - Rutgers University\SAS\Projects\Project3\Initial_Study_Project_N.txt';
Data test;
infile F1 dsd missover;
input Patient_ID Age State$ Length_of_Stay Total_Charge;
run;

proc print data=test;
title 'Original Data_1';
run;

/*To find any descrepencies in the data in the file and delete the outliers*/
proc freq data=test;
tables Patient_ID Age State Length_of_Stay Total_Charge/nocum nopercent;
run;

proc means data=test  mean min max;
run;

/* Copy of Original Data File_1 and delete missing data row*/
data test1;
set test;
if   Age=. or Total_Charge=. or Length_of_Stay=. then delete;
if   Length_of_Stay>70 then delete;
run;

proc print data=test1;
title'Copy of Original Data_1 &'
	 ' Cleared Discrepencies';
run;

/* Sorted by Patient_ID*/
proc sort data=test1;
by Patient_ID;
run;

proc print data=test1;
title'Sorted Data_1';
run;

/*Original data File_2*/
Filename F2'C:\Users\mk2101\OneDrive - Rutgers University\SAS\Projects\Project3\Second_Study_Project3_N.txt';
data trail;
infile F2 dsd missover;
input Patient_ID Site$ Group$ Test_Score;
run;

proc print data=trail;
title'Original Data_2';
run;

/*To find any descrepencies in the data in the file*/
proc freq data=trail;
tables Patient_ID Site Group Test_Score/nocum nopercent;
run;
proc means data=trail min max;
run;

/*Copy of Original Data_2 and deleted junk value row
and deleted obs with test score>700 and <25*/
data trail1 (rename=(Test_Score=FBS_Reading));
set trail;
if Group='n/a'or Site='N/a' then delete;
if Test_Score > 700 or Test_Score<25 then delete;
run;

proc print data=trail1;
title 'Copy of Original Data_2&'
	  ' Cleared Discrepencies';
run;
/* Sorted by Patient_ID*/
proc sort data=trail1;
by Patient_ID;
run;

proc print data=trail1;
title 'Sorted Data_2';
run;

/* Merging both the files and dropped Total_Charge*/
data merged;
merge test1 (in=a)
	  trail1 (in=b);
by Patient_ID;
if a=1 and b=1 ;
drop Total_Charge;
run;

proc print data=merged;
title'Merged Data';
run;

/* Simple Random Sampling*/
Libname L1'C:\Users\mk2101\OneDrive - Rutgers University\SAS';
proc surveyselect
data= merged
method=srs
sampsize =1000
out=L1.sampling;
Id _all_;
run;

proc print data=L1.sampling;
title'Simple Random Sampling';
run;

proc means data=sampling;
run;

/* Contents*/
proc contents data=sampling;
title'Contents';
run;

/* Descriptive Statastics*/
/*Frequency procedure*/
proc freq data=sampling;
run;

/*Research Question 1*/
/*Is there any difference between mean test scores among three groups across all three sites? 

/*To check whether the data is normally distributed*/
proc univariate data=sampling;
var FBS_Redaing;
histogram/normal;
run;

/*To check whether the data is balanced or unbalanced*/
proc freq data=sampling;
tables Group Site/nocum nopercent;
title 'Bal or Unbal';
run;

/*Two Way ANOVA*/
proc glm data=sampling;
class Group Site;
model FBS_Reading=Group Site
 	  Group * Site;
means Group Site;
title'Two way ANOVA';
run;

/*Research Question 2*/
/*Is there any difference between mean test scores among three age groups*/

/*Conditional Processing*/
data sampling1;
set sampling;
if Age>8 and Age<30 then Age_Group="Young Age";
else if Age>31 and Age<60 then Age_Group="Middle Age";
else Age_Group="Old Age";
run;
proc print data=sampling1;
title'Conditional Processing';
run;

/* Contents*/
proc contents data=sampling1;
run;
/*To check whether the data is normally distributed*/
proc univariate data=sampling1;
histogram/normal;
run;

/*To check whether the data is balanced or unbalanced*/
proc freq data=sampling1;
tables Age_Group /nocum nopercent;
title 'Bal or Unbal';
run;

/*One Way ANOVA*/
proc anova data=sampling1;
class Age_Group;
model FBS_Reading=Age_Group;
means Age_Group/snk;
title 'One way ANOVA';
run;

/*Research Question 3*/
/*Is there any difference between mean test scores among two states*/


/*To check whether the data is normally distributed*/
proc univariate data=sampling1;
histogram /normal;
run;

/*Two sample ttest*/
proc ttest data=sampling1;
class State;
var FBS_Reading;
title 'Two sample T-Test';
run;

/*Research Question 4*/
/*Goodness of fit*/

/*Conditional Processing*/
data sampling2;
set sampling1;
if FBS_Reading>126 then Level="High Sugar";
else if FBS_Reading>100 and FBS_Reading<125 then Level="Prediabetic";
else if FBS_Reading<70 then Level="Low sugar";
else Level="Normal";
run;

proc print data=sampling2;
title'New Variable';
run;

proc freq data=sampling2;
tables Level;
run;

proc univariate data=sampling2;
histogram/normal;
run;
/*Goodness of fit test*/
data sampling2;
input Level$ FBS_Reading;
datalines;

High_Sugar 181
Low_Sugar 461
Normal_Sugar 255
Prediabetic 103
;
run;
proc freq order=data;
weight FBS_Reading;
title"Goodness of fit testing";
tables Level/nocum testp= (0.2,0.3,0.4,0.1);
run;


/*Research Question 5*/
/*Is there any correlation between Age and Test_Scores*/

proc corr data= sampling1;
var Age FBS_Reading;
title'Correlation b/w Age and FBS level'
run;





















