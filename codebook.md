# Codebook for Getting and Cleaning Data Project
Hello,

This codebook provide additional information about the variables, data and transformations used in the course project from course 3 in Data Science Speciaization

The end result of whole analysis is cleandata.txt that was generated at the end of this assignment.
Please read the [readme.md](https://github.com/anzy9/Getting-and-Cleaning-Data-Course-Project-/blob/master/README.md) for more background
information on the  objective of the assignment

## Source Data
A full description of the data used in this project can be found at [The UCI Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Dataset information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

I purposely not provided the the description about the variables in the UCI dataset, The features_info.txt provied the description about the varaibles.

## TidyData Set 

The [`cleandata.txt`](https://github.com/anzy9/Getting-and-Cleaning-Data-Course-Project-/blob/master/cleandata.txt) data file is a text file, containing space-separated values.The data set contains mean scores for different measurement for each subject and activity performed by them

## Transformations conducted in [run_analysis.R](https://github.com/anzy9/Getting-and-Cleaning-Data-Course-Project-/blob/master/run_analysis.R)
### Section 0: Preprocessing
1. The code first get the current directory and then create a directory 'course3assignment and set it as the current working directory, 
2. It then downloads, unzips the dataset from the [URL](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Section 1 : Merges the training and the test sets to create one data set.
The Data folder contains following files
features.txt
activity_labels.txt
subject_train.txt
x_train.txt
y_train.txt
subject_test.txt
x_test.txt
y_test.txt

Following steps were followed to combine the train and test data

1. Create the activity data from activity.txt
2. Create features dataset from features.txt
3. Rename the subjectTrainingData columns to SubjectID
4. Rename the activity coumns to ActivityID and Activity
5. Read the data from Train folder and create three dataset.Rename the columns in Ytrainindata to ActivtyID
6. Rename the columns in XTrainingdata using the feature data we just created.
7. Combine the XTrainingData, YTrainingData, subjectTrainingData using cbind
8. Repeat the same for Test Data
9. Combine TrainData and TestData using Rbind

### Section 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
Get the columns names in character variable and then a create logical vector that contains TRUE values for the AcivityID, SubjectID, mean and stdev columns and ignore other columns
filteredActivityData was  created by subsetting the dataset created in section 1 with logical vector.

### Section 3: Uses descriptive activity names to name the activities in the data set
Merge the filteredActivityData with activity dataset using ActivityID as key.

### Section 4: Appropriately label the data set with descriptive activity names.
Use gsub function for pattern replacement to clean up the labels
Replaced
1. t to Time_
2. f to Freq_
3. - to " "
4. BodyBody to Body
5. Gravity to Gravity_
6. " " to -
7. () to ""

### Section 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
[cleandata.txt](https://github.com/anzy9/Getting-and-Cleaning-Data-Course-Project-/blob/master/cleandata.txt) was created using write command
