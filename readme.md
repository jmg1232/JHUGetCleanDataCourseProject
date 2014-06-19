Getting and Cleaning Data class project, June 18, 2014
========================================================

The purpose of this project is to construct a tidy analytic data set for later analysis. 
This project includes:
1:  a tidy comma delimited file named:  tidyxy.csv
2.  a codebook named:  codebook.md
3.  this README.md file
4.  An R script named run-analysis.R

summary
=====================================================================================================================================
the tidy data set tidyxy.csv contains observational feature data for 30 subjects ("subjectId") participating in 6 activities
("activity"). There were 66 features to summarize each activity.  Each of the features summarized in the tidy data set represents an 
average over the observed/calculated measures for each subject and activity.  

r Program script name:  run_analysis.R
=====================================================================================================================================
Overview of run_analysis.R
1. the source data for the 30 subjects was broken up into 2 pieces:  training and test.  The training and the test sets were combined to create one 
   analytic data set.
2. Feature descriptions for the x-test and x-training data sets were contained in the features.txt data file
   Retained only the "features" containing either "mean()" or "std()" in the names.
   After combining the test and training data sets and eliminating features not of interest, there were 10,299 rows and 68 variables 
   (subjectId, activity, and 66 features) in the combined analytic data set.
3. The combined analytic data set was collapsed by averaging each feature by subjectId and activity, resulting in a tidy data set
   containing 180 rows (30 subjects X 6 activities) and 68 variables (subjectId, activity, and 66 average features).  
4. Each feature was provided with a descriptive name (see codebook for details)
5. the final tidy data set was saved as xytidy.csv for easy import into R and other statistical software.
   
-------------------------------------------------------------------------------------------------------------------------------------

The Original data contained experimental data on 30 subjects participating in 6 activities.  Detailed descriptions of the data
may be found at the original source (see below).

-------------------------------------------------------------------------------------------------------------------------------------

The original features.txt file contained feature descriptions for items in the x-train.txt and x-test.txt files.  
Each feature description has 7 parts (not all are applicable to each variable): 
1. domain: Time, Frequency
2. source: Body, Gravity
3. sensor: Accelerometer, Gyroscopic
4. jerk: Yes, No
5. magnitude: Yes, No
6. statistics: mean, standard deviation (std).  Note: We only kept variables containing mean() or std().
7. axis: X, Y, Z

-------------------------------------------------------------------------------------------------------------------------------------

Original Training data was broken into  3 files: 
1. x-train.txt - the features for each record
2. y-train.txt - he activity codes for each record (Activity codes 1-6)
3. subject-train.txt - Id codes for each record of x-train.txt
4. Note training data contains records for ID's:  1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29  30 

-------------------------------------------------------------------------------------------------------------------------------------

Similarly, the original Test data was broken into  3 files: 
1.   x-test.txt - the features for each record
2.   y-test.txt - the activity codes for each record (Activity codes 1-6)
3.   subject-test.txt - Id codes for each record of x-test.txt
  Note:  original test data contained data on 9 subjects:  Id's 2   4   9  10  12  13  18  20  24 
  
-------------------------------------------------------------------------------------------------------------------------------------

(y-test, y-train) contained the Activity codes:  
1= WALKING, 2= WALKING-UPSTAIRS, 3= WALKING-DOWNSTAIRS, 4= SITTING, 5= STANDING, 6= LAYING
 
-------------------------------------------------------------------------------------------------------------------------------------

Combined subjectTrain & subjectTest - have ID codes for the 30 subjects

Original Data source and license
=======================================================
The source data are described at: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The source data for the project were obtained from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass HardwareFriendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

 set working directory and read data files.  the raw data files were downloaded from: 
 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
 The resulting text files were unzipped.  The test data is in the "test" folder and the training data is in the
 in the "train" folder. Both the "train" and "test" directories are subdirectories of the working directory.
 The labels for the x-train.txt and the x-test.txt files are contained in the "features.txt" file which is
 stored in the working directory.  

