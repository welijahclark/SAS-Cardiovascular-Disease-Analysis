/*William-Elijah Clark Project B Code*/

/*I hereby certify that the following SAS code is my own original work*/

/*Problem 1*/

/*Here's a snippet for my csv file*/

/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/home/u49665201/sasuser.v94/STA3064/heart.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=Heart
		    DBMS=CSV
		    REPLACE;
RUN;


/****************************************/
/*Some Scatterplots by Physiological Sex*/
/****************************************/

/*Oooh, this is interesting! I'm not sure how to interpret those outliers that are closer to zero cholesterol just lined up at the
bottom of the scatterplot, but seeing male cholesterol decrease with age and female cholesterol increase with age was NOT something I
expected!*/
proc sgplot data=heart;
 reg x=age y=cholesterol
 /group=sex
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Cholesterol as a Function of Age and Sex';
run;

/*This one is not a good correlation*/
proc sgplot data=heart;
 reg x=age y=RestingBP
 /group=sex
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Resting Blood Pressure as a Function of Age and Sex';
run;

/*This looks like a good correlation of decreased maximum heart rates as a person ages*/
proc sgplot data=heart;
 reg x=age y=MaxHR
 /group=sex
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Maximum Heart Rate as a Function of Age and Sex';
run;

/************************************/
/*Some Scatterplots by Heart Disease*/
/************************************/

/*This scatterplot isn't very useful*/
proc sgplot data=heart;
 reg x=age y=cholesterol
 /group=HeartDisease
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Cholesterol as a Function of Age and Sex';
run;

/*This scatterplot shows another correlation that's mediocre at best.*/
proc sgplot data=heart;
 reg x=age y=RestingBP
 /group=HeartDisease
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Resting Blood Pressure as a Function of Age and Sex';
run;

/*This model is more promising*/
proc sgplot data=heart;
 reg x=age y=MaxHR
 /group=HeartDisease
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Maximum Heart Rate as a Function of Age and Sex';
run;

/*I think the above are nifty, but let's do a bit more dabbling.*/

/*Some scatterplots by ChestPain*/

/*This one isn't very useful*/
proc sgplot data=heart;
 reg x=age y=cholesterol
 /group=ChestPainType
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Cholesterol as a Function of Age and Chest Pain Type';
run;

/*This model looks like a dead end*/
proc sgplot data=heart;
 reg x=sex y=cholesterol
 /group=ChestPainType
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Cholesterol as a Function of Sex and Chest Pain Type';
run;


/*There is a correlation, but there's not much of a difference between groups*/
proc sgplot data=heart;
 reg x=age y=RestingBP
 /group=ExerciseAngina
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Resting Blood Pressure as a Function of Exercise Induced Angina and Sex';
run;

/*This seems to be correlated by a decent amount*/
proc sgplot data=heart;
 reg x=age y=MaxHR
 /group=ExerciseAngina
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Maximum Heart Rate as a Function of Age and Exercise Induced Angina';
run;

/*This one doesn't seem to show a very strong correlation*/
proc sgplot data=heart;
 reg x=age y=cholesterol
 /group=ExerciseAngina
 CLM alpha=0.05;
 xaxis grid;
 yaxis grid;
 title 'Regression Fit Scatterplot of Cholesterol as a Function of Age and Exercised Induced Angina';
run;

/*I would do more if I understood the importance of Oldpeak and STSlope, and I don't know what to expect with fasting blood sugar.
This seems to call for medical knowledge that I simply don't have.*/


/*ANOVA*/

/*This one is OK*/
proc glm data=Heart;
class HeartDisease;
model cholesterol = HeartDisease/ss3;
means HeartDisease/hovtest;
run;

/*Meh*/
proc glm data=Heart;
class HeartDisease;
model RestingBP = HeartDisease/ss3;
means HeartDisease/hovtest;
run;

/*This one has a decent amount of statistical significance*/
proc glm data=Heart;
class HeartDisease;
model MaxHR = HeartDisease/ss3;
means HeartDisease/hovtest;
run;

/*This one seems to show the strongest statistical significance!*/
proc glm data=Heart;
class HeartDisease;
model MaxHR = HeartDisease/ss3;
means HeartDisease/tukey;
run;

/*There's also a statistical correlation here*/
proc glm data=Heart;
class Sex;
model cholesterol = Sex/ss3;
means HeartDisease/hovtest;
run;

/*This one is not a very strong correlation*/
proc glm data=Heart;
class Sex;
model cholesterol = Sex/ss3;
means HeartDisease/tukey;
run;

/*This one has very little correlation*/
proc glm data=Heart;
class Sex;
model RestingBP = Sex/ss3;
means HeartDisease/hovtest;
run;

/*There's some use for this model, but the F-test statistic could be better*/
proc glm data=Heart;
class Sex;
model MaxHR = Sex/ss3;
means HeartDisease/hovtest;
run;

/*This model doesn't work very well.*/
proc glm data=Heart;
class Sex;
model MaxHR = Sex/ss3;
means HeartDisease/tukey;
run;


/*The model residuals look terrible! Sure, there's a correlation, but it's not worth it with those residuals!*/
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model cholesterol = HeartDisease Sex/solution ss3;
means HeartDisease/tukey;
run;

/*Well, the residuals are OK, but the correlation just isn't there*/
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model RestingBP = HeartDisease Sex/solution ss3;
run;

/*Ahh, this looks better! I think I'll go with this model.*/
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model MaxHR = HeartDisease Sex/solution ss3;
means HeartDisease/tukey;
run;

proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model MaxHR = HeartDisease Sex/solution ss3;
means Sex/tukey;
run;


/*This model doesn't work very well.*/
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model cholesterol = HeartDisease|Sex/solution ss3;
run;

/*This model also doesn't work very well.*/
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model RestingBP = HeartDisease|Sex/solution ss3;
run;

/*The below two models are OK.*/
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model MaxHR = HeartDisease|Sex/solution ss3;
means HeartDisease/tukey;
run;

proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model MaxHR = HeartDisease|Sex/solution ss3;
means HeartDisease/tukey;
run;

/*Unsuprisingly, predicting age based on heart disease and sex doesn't work very well*/ 
proc glm data=Heart plots=diagnostics;
class HeartDisease(ref='0') Sex(ref='M');
model Age = HeartDisease Sex/solution ss3;
run;



/*ANCOVA*/

/*Age seems to be the odd variable that doesn't show much of a difference here, but the rest show statistically significant differences.*/
proc glm data=heart plots=diagnostics;
	class sex (ref='M') HeartDisease(ref='0');
	model Cholesterol = Age Sex HeartDisease/solution ss3;
run;

/*Once again, RestingBP is tricky to pin down. However, we can say that it's specifically physiological sex that doesn't show any difference.*/
proc glm data=heart plots=diagnostics;
	class sex (ref='M') HeartDisease(ref='0');
	model RestingBP = Age Sex HeartDisease/solution ss3;
run;

/*There seems to be a decent amount of statistical difference here.*/
proc glm data=heart plots=diagnostics;
	class sex (ref='M') HeartDisease(ref='0');
	model MaxHR = Age Sex HeartDisease/solution ss3;
run;