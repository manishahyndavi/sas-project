Filename F1'C:\Users\mk2101\OneDrive - Rutgers University\SAS\Projects\Project3\Initial_Study_Project_N.txt';
Data test;
infile F1 dsd missover;
input Patient_ID Age State$ Length_of_Stay Total_Charge;
run;
proc print data=test;
title 'Original Data';
run;


