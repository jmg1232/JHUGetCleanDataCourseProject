#####################################################################################################################################
# Last update:  2012 June 18
#####################################################################################################################################
# Program name:  run_analysis.R
#####################################################################################################################################
# General Purpose: 
# (1) Merge the training and the test sets to create one analytic data set.
# (2) Feature descriptions for the x_test and x_training data sets are contained in the features.txt data file
# (3) Retain only the "features" containing either "mean()" or "std()" in the names
# (3) Apply descriptive activity names to name the features (based on names in features data set)
# (4) Appropriately labels the data set with descriptive variable names. 
# (5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject
#####################################################################################################################################
# Specifics: data for the 30 subjects is broken into 2 sets of files:  test & training to be combined
#####################################################################################################################################
# The features.txt file contains feature descriptions for the x_train.txt and x_test.txt files.  Each feature name has 7 parts:
# 1. domain: Time, Frequency
# 2. source: Body, Gravity
# 3. sensor: Accelerometer, Gyroscopic
# 4. jerk: Yes, No
# 5. magnitude: Yes, No
# 6. statistics: mean, standard deviation (std), mean absolute deviation (mad), minimum, maximum, etc.  We only want variables containing mean() or std().
# 7. axis: X, Y, Z
#####################################################################################################################################
#   Training data is broken into  3 files:
#   x_train.txt - the features for each record
#   y_train.txt - he activity codes for each record (Activity codes 1-6)
#  subject_train.txt - Id codes for each record of x_train.txt
#  Note training data contains records for ID's:  1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29  30 
#####################################################################################################################################
#   Test data is broken into  3 files:
#   x_test.txt - the features for each record
#   y_test.txt - the activity codes for each record (Activity codes 1-6)
#   subject_test.txt - Id codes for each record of x_test.txt
#  Note: test contains data on subjects 2   4   9  10  12  13  18  20  24 
#####################################################################################################################################
# (y_test, y_train) contain the Activity codes:  1= WALKING, 2= WALKING_UPSTAIRS, 3= WALKING_DOWNSTAIRS, 4= SITTING, 5= STANDING, 6= LAYING
#####################################################################################################################################
# Combined subjectTrain & subjectTest - have ID codes for the 30 subjects
# set working directory.  All file directories will be relative to this
#####################################################################################################################################

setwd("C:/Users/jeff/Desktop/jhu_getcleandata/projectfiles/UCI HAR Dataset/")

#####################################################################################################################################
# Read features.txt data.  will use this data to determine which columns to keep in test/training data
# File is space delimited.  Contains 2 columns - a variable index (1:561) and a variable label
#####################################################################################################################################

features <- read.table("features.txt")
# display top 3 rows of features
head(features, n=3)
# V1                V2
# 1  1 tBodyAcc-mean()-X
# 2  2 tBodyAcc-mean()-Y
# 3  3 tBodyAcc-mean()-Z

# display structure of features data.frame
str(features)
# 'data.frame':      561 obs. of  2 variables:
#       $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
# $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 244 245 250 251 252 237 238 239 240 ...
#####################################################################################################################################
# Create an indicator variable "meanstd" that tells whether the second column V2 contains the text strings "mean()" or "std()".  
# meanstd is an indicator for whether variable name contains mean() or std()
#####################################################################################################################################
features$meanstd <-grepl(pattern='mean\\(\\)|std\\(\\)',x=features[,"V2"])
#####################################################################################################################################
# Use table function to calculate how many variable names contain "mean()" or "std()".  
table(features$meanstd)
# FALSE  TRUE 
# 495    66 

features$vname  <- gsub(pattern='\\(\\)', replacement="", x=features$V2 )

# Modify variable names.  Remove the "()" after the function name, then convert "-" to ""
features$vname3 <- gsub(pattern='-', replacement='', x=features$vname )



# use dput to create vector of names
# dput(features$vname3[features$meanstd])
# c("tBodyAccmeanX", "tBodyAccmeanY", "tBodyAccmeanZ", "tBodyAccstdX", 
# "tBodyAccstdY", "tBodyAccstdZ", "tGravityAccmeanX", "tGravityAccmeanY", 
# "tGravityAccmeanZ", "tGravityAccstdX", "tGravityAccstdY", "tGravityAccstdZ", 
# "tBodyAccJerkmeanX", "tBodyAccJerkmeanY", "tBodyAccJerkmeanZ", 
# "tBodyAccJerkstdX", "tBodyAccJerkstdY", "tBodyAccJerkstdZ", "tBodyGyromeanX", 
# "tBodyGyromeanY", "tBodyGyromeanZ", "tBodyGyrostdX", "tBodyGyrostdY", 
# "tBodyGyrostdZ", "tBodyGyroJerkmeanX", "tBodyGyroJerkmeanY", 
# "tBodyGyroJerkmeanZ", "tBodyGyroJerkstdX", "tBodyGyroJerkstdY", 
# "tBodyGyroJerkstdZ", "tBodyAccMagmean", "tBodyAccMagstd", "tGravityAccMagmean", 
# "tGravityAccMagstd", "tBodyAccJerkMagmean", "tBodyAccJerkMagstd", 
# "tBodyGyroMagmean", "tBodyGyroMagstd", "tBodyGyroJerkMagmean", 
# "tBodyGyroJerkMagstd", "fBodyAccmeanX", "fBodyAccmeanY", "fBodyAccmeanZ", 
# "fBodyAccstdX", "fBodyAccstdY", "fBodyAccstdZ", "fBodyAccJerkmeanX", 
# "fBodyAccJerkmeanY", "fBodyAccJerkmeanZ", "fBodyAccJerkstdX", 
# "fBodyAccJerkstdY", "fBodyAccJerkstdZ", "fBodyGyromeanX", "fBodyGyromeanY", 
# "fBodyGyromeanZ", "fBodyGyrostdX", "fBodyGyrostdY", "fBodyGyrostdZ", 
# "fBodyAccMagmean", "fBodyAccMagstd", "fBodyBodyAccJerkMagmean", 
# "fBodyBodyAccJerkMagstd", "fBodyBodyGyroMagmean", "fBodyBodyGyroMagstd", 
# "fBodyBodyGyroJerkMagmean", "fBodyBodyGyroJerkMagstd")


#########################################################################################
vnames <- features$vname2
# create vector of column numbers for the variable names containing mean() or std()
keep <- features$V1[features$meanstd]
keep.vars <- features[features$meanstd,]
#
# keep - index of variables from x.test & x.train to keep
# [1]   1   2   3   4   5   6  41  42  43  44  45  46  81  82  83  84  85
# [18]  86 121 122 123 124 125 126 161 162 163 164 165 166 201 202 214 215
# [35] 227 228 240 241 253 254 266 267 268 269 270 271 345 346 347 348 349
# [52] 350 424 425 426 427 428 429 503 504 516 517 529 530 542 543

xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/Y_test.txt")
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/Y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")
subjectTest <- read.table("./test/subject_test.txt")

# ytrain & ytest - have codes for 6 activities
# subjectTrain & subjectTest - have codes for the 30 subjects

names(subjectTrain)[1] <- "subjectId"
names(subjectTest)[1] <- "subjectId"

names(ytrain)[1] <- "activity"
names(ytest)[1] <-  "activity"




str(subjectTrain)
str(subjectTest)
# > str(subjectTrain)
# 'data.frame':      7352 obs. of  1 variable:
#       $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
# > str(subjectTest)
# 'data.frame':	2947 obs. of  1 variable:
#       $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
# 
# > table(subjectTrain$V1)
# 
# 1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29  30 
# 347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 382 344 383 
# > table(subjectTest$V1)
# 
# 2   4   9  10  12  13  18  20  24 
# 302 317 288 294 320 327 364 354 381 

# Note: different subject ids in test and training data

dim(xtest)
dim(ytest)
dim(xtrain)
dim(ytrain)

# > dim(xtest)
# [1] 2947  561
# > dim(ytest)
# [1] 2947    1
# > dim(xtrain)
# [1] 7352  561
# > dim(ytrain)
# [1] 7352    1

# subset the columns that contain means/std
xtest <- xtest[,keep]
xtrain <- xtrain[,keep]

# the names are identical for xtrain & ytrain

names(xtrain) <- c("tBodyAccmeanX", "tBodyAccmeanY", "tBodyAccmeanZ", "tBodyAccstdX", 
"tBodyAccstdY", "tBodyAccstdZ", "tGravityAccmeanX", "tGravityAccmeanY", 
"tGravityAccmeanZ", "tGravityAccstdX", "tGravityAccstdY", "tGravityAccstdZ", 
"tBodyAccJerkmeanX", "tBodyAccJerkmeanY", "tBodyAccJerkmeanZ", 
"tBodyAccJerkstdX", "tBodyAccJerkstdY", "tBodyAccJerkstdZ", "tBodyGyromeanX", 
"tBodyGyromeanY", "tBodyGyromeanZ", "tBodyGyrostdX", "tBodyGyrostdY", 
"tBodyGyrostdZ", "tBodyGyroJerkmeanX", "tBodyGyroJerkmeanY", 
"tBodyGyroJerkmeanZ", "tBodyGyroJerkstdX", "tBodyGyroJerkstdY", 
"tBodyGyroJerkstdZ", "tBodyAccMagmean", "tBodyAccMagstd", "tGravityAccMagmean", 
"tGravityAccMagstd", "tBodyAccJerkMagmean", "tBodyAccJerkMagstd", 
"tBodyGyroMagmean", "tBodyGyroMagstd", "tBodyGyroJerkMagmean", 
"tBodyGyroJerkMagstd", "fBodyAccmeanX", "fBodyAccmeanY", "fBodyAccmeanZ", 
"fBodyAccstdX", "fBodyAccstdY", "fBodyAccstdZ", "fBodyAccJerkmeanX", 
"fBodyAccJerkmeanY", "fBodyAccJerkmeanZ", "fBodyAccJerkstdX", 
"fBodyAccJerkstdY", "fBodyAccJerkstdZ", "fBodyGyromeanX", "fBodyGyromeanY", 
"fBodyGyromeanZ", "fBodyGyrostdX", "fBodyGyrostdY", "fBodyGyrostdZ", 
"fBodyAccMagmean", "fBodyAccMagstd", "fBodyBodyAccJerkMagmean", 
"fBodyBodyAccJerkMagstd", "fBodyBodyGyroMagmean", "fBodyBodyGyroMagstd", 
"fBodyBodyGyroJerkMagmean", "fBodyBodyGyroJerkMagstd")

names(xtest) <- c("tBodyAccmeanX", "tBodyAccmeanY", "tBodyAccmeanZ", "tBodyAccstdX", 
"tBodyAccstdY", "tBodyAccstdZ", "tGravityAccmeanX", "tGravityAccmeanY", 
"tGravityAccmeanZ", "tGravityAccstdX", "tGravityAccstdY", "tGravityAccstdZ", 
"tBodyAccJerkmeanX", "tBodyAccJerkmeanY", "tBodyAccJerkmeanZ", 
"tBodyAccJerkstdX", "tBodyAccJerkstdY", "tBodyAccJerkstdZ", "tBodyGyromeanX", 
"tBodyGyromeanY", "tBodyGyromeanZ", "tBodyGyrostdX", "tBodyGyrostdY", 
"tBodyGyrostdZ", "tBodyGyroJerkmeanX", "tBodyGyroJerkmeanY", 
"tBodyGyroJerkmeanZ", "tBodyGyroJerkstdX", "tBodyGyroJerkstdY", 
"tBodyGyroJerkstdZ", "tBodyAccMagmean", "tBodyAccMagstd", "tGravityAccMagmean", 
"tGravityAccMagstd", "tBodyAccJerkMagmean", "tBodyAccJerkMagstd", 
"tBodyGyroMagmean", "tBodyGyroMagstd", "tBodyGyroJerkMagmean", 
"tBodyGyroJerkMagstd", "fBodyAccmeanX", "fBodyAccmeanY", "fBodyAccmeanZ", 
"fBodyAccstdX", "fBodyAccstdY", "fBodyAccstdZ", "fBodyAccJerkmeanX", 
"fBodyAccJerkmeanY", "fBodyAccJerkmeanZ", "fBodyAccJerkstdX", 
"fBodyAccJerkstdY", "fBodyAccJerkstdZ", "fBodyGyromeanX", "fBodyGyromeanY", 
"fBodyGyromeanZ", "fBodyGyrostdX", "fBodyGyrostdY", "fBodyGyrostdZ", 
"fBodyAccMagmean", "fBodyAccMagstd", "fBodyBodyAccJerkMagmean", 
"fBodyBodyAccJerkMagstd", "fBodyBodyGyroMagmean", "fBodyBodyGyroMagstd", 
"fBodyBodyGyroJerkMagmean", "fBodyBodyGyroJerkMagstd")





# dim(xtest)
# [1] 2947   66
#  dim(xtrain)
# [1] 7352   66

# need to apply names to data set

xytrain <- cbind(subjectTrain, ytrain, xtrain)

#xytrain$train1test2 <- 1
xytest <- cbind(subjectTest, ytest, xtest)
#xytest$train1test2 <- 2
xy <- rbind(xytrain, xytest)

head(xy, n=2)

require(reshape2)
xymelt <- melt(xy, id.vars=c("subjectId", "activity"))
str(xymelt)

xytidy <- dcast(xymelt, subjectId + activity ~ variable, mean)
xytidy$activity <- factor(xytidy$activity, levels=c(1:6), labels=c("WALKING", "WALKING UPSTAIRS", "WALKING DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
head(xyfinal, n=2)


write.table(xytidy, "tidyxy.txt", sep=" ")

# Note:  do this after melting and dcasting
# use str to help with code book

str(xytidy)

# Where: 
#       'mean()|std()' - seacrhing query
# features[,"V2"] - second column ([,"V2"]) of the features data.frame.
# 0votes received.· flag
# 
# Scott von KleeckCOMMUNITY TA· 2 days ago 
# remember that "(" and ")" have special meaning in regular expressions.  To escape them you need to use something like "\\(" and "\\)"
