/*************************************************/
/* Copyright 2008-2010 SAS Institute Inc.        */
/* Top N report for data across categories       */
/* Use macro variables to customize the data     */
/* source.                                       */
/* DATA - SAS library.member for input data      */
/* REPORT - column to report on                  */
/* MEASURE - column to measure for the report    */
/* MEASUREFORMAT - specify to preserve measure   */
/*  format in the report (currency, for example) */
/* STAT - SUM or MEAN                            */
/* N - The "N" in Top N - how many to show       */ 
/* CATEGORY - across which category?             */ 
/*************************************************/
/* jenner-check: SASHELP.CARS (428 rows) exceeds the hosted API's
   unlicensed 100-obs input cap and truncates before the category x
   report cross-tabulation can populate, so this bundle substitutes a
   small inline sample (20 rows / 5 vehicle types) via &data= as the
   script's own header comment says it's designed to be repointed --
   the summarize/rank/report logic below is untouched. */
data work.mycars;
  length Type $8 Model $20;
  input Type $ Model $ MPG_City;
  datalines;
SUV Explorer 15
SUV Explorer 16
SUV Highlander 22
SUV Highlander 21
SUV Pilot 17
Sedan Accord 24
Sedan Accord 25
Sedan Camry 26
Sedan Camry 27
Sedan Civic 30
Truck F150 14
Truck F150 15
Truck Silverado 13
Truck Ram 14
Truck Tacoma 19
Sports Corvette 15
Sports Mustang 17
Sports Camaro 16
Wagon Outback 23
Wagon Outback 24
;
run;

%let data=work.mycars;
%let report=Model;
%let measure=MPG_City;
%let measureformat=%str(format=BEST6.);
%let stat=MEAN;
%let n=3;
%let category=Type;
title "Top Models by MPG_City for each region of Type";
footnote;

/* summarize the data across a category and store */
/* the output in an output data set */
proc means data=&data &stat noprint;
	var &measure;
	class &category &report;
	output out=summary &stat=&measure &category /levels;
run;

/* store the value of the measure for ALL rows and 
/* the row count into a macro variable for use  */
/* later in the report */
proc sql noprint;
select &measure,_FREQ_ into :overall,:numobs
from summary where _TYPE_=0;
select count(distinct &category) into :categorycount from summary;
quit;

/* sort the results so that we get the TOP values */
/* rising to the top of the data set */
proc sort data=work.summary out=work.topn;
  where _type_>2;
  by &category descending &measure;
run;

/* Pass through the data and output the first N */
/* values for each category */
data topn;
  length rank 8;
  label rank="Rank";
  set topn;
  by &category descending &measure;
  if first.&category then rank=0;
  rank+1;
  if rank le &n then output;
run;

/* Create a report listing for the top values in each category */
footnote2 "&stat of &measure for ALL values of &report: &overall (&numobs total rows)";
proc report data=topn;
	column &category rank &report &measure;
	define &category /group;
	define rank /display;
	define &measure / analysis &measureformat;	
run;
quit; 
