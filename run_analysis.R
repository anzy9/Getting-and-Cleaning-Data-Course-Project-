#Load the libraries used for analysis
library(data.table)
library(dplyr)
#Get the current directory and change the current directory to your working directory
getwd()
mainDir<-getwd()
subDir<-"Course3Assignment"
if (file.exists(subDir)){
  setwd(file.path(mainDir, subDir))
} else {
  dir.create(file.path(mainDir, subDir))
  setwd(file.path(mainDir, subDir))
  
}
#download the file and unzip into created folder

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir=getwd())
#Following is the code as requested for the assignment
#1. Merges the training and the test sets to create one data set.
#Get the featuresand activity data
features<-read.table("./UCI HAR Dataset/features.txt",header = FALSE)
activity<-read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)
#Training Set
xTrainingData<-read.table("./UCI HAR Dataset/train/X_train.txt",header = FALSE)
YTrainingData<-read.table("./UCI HAR Dataset/train/Y_train.txt",header = FALSE)
subjectTrainingData<-read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE)


#renaming the column to readable names
colnames(subjectTrainingData)<-c("SubjectID")
colnames(activity)<-c("ActivityID","Activity")
colnames(YTrainingData)<-c("ActivityID")

#Before we combine everything into one lets Rename the colums in XTraining data with features columns
colnames(xTrainingData)=features[,2]

#Combining the training data together, XTrainingData, yTrainingData, subjectTrainingData
trainingData<-cbind(xTrainingData,YTrainingData,subjectTrainingData)


#Test Set
xTestData<-read.table("./UCI HAR Dataset/test/X_test.txt",header = FALSE)
YTestData<-read.table("./UCI HAR Dataset/test/Y_test.txt",header = FALSE)
subjectTestData<-read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE)

#renaming the column of subject data to readable names
colnames(subjectTestData)<-c("SubjectID")
colnames(YTestData)<-c("ActivityID")

#Before we combine everything into one lets Rename the colums in XTraining data with features columns
colnames(xTestData)=features[,2]

#Combining the testing data together, XTrainingData, yTrainingData, subjectTrainingData
testData<-cbind(xTestData,YTestData,subjectTestData)

#Combining Test and Trainin data  together to create one data table
activityData<-rbind(trainingData,testData)


#2. Extracts only the measurements on the mean and standard deviation for each measurement.
cnames<-colnames(activityData)
filterflag = (grepl("ActivityID",cnames) | grepl("SubjectID",cnames) | grepl("-mean..",cnames) | grepl("-std..",cnames))

filteredActivityData<-activityData[filterflag==TRUE]


#3 .Uses descriptive activity names to name the activities in the data set
#Using ActivityID as key , we will be naming the labels i.e.Using ActivityID in Activity Table and ProcessActivityData
# to get the FinaActivityData table with descriptive activities
filteredActivityData<-merge(filteredActivityData,activity,by='ActivityID',all.x = TRUE)
colnames(activityData)


#4. Appropriately labels the data set with descriptive variable names

LabelledColumns<-colnames(filteredActivityData)
LabelledColumns<-gsub("^t","Time_",LabelledColumns)
LabelledColumns<-gsub("^f", "Freq_",LabelledColumns) #Only replace f at the start of the character with Freq
LabelledColumns<-gsub("-", " ",LabelledColumns)
LabelledColumns<-gsub("BodyBody","Body",LabelledColumns)#Replace BodyBody with Body
LabelledColumns<-gsub("Body","Body_",LabelledColumns)#Replace [Body] with [Body ]
LabelledColumns<-gsub("Gravity","Gravity_",LabelledColumns) #Replace with[Gravity] with [Gravity ]
LabelledColumns<-gsub(" ","_",LabelledColumns)
LabelledColumns<-gsub("\\(\\)","",LabelledColumns)

                      
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject., LabelledColumns) #remove any punctuation from the columns names and replace with ""

colnames(filteredActivityData)<-LabelledColumns


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyData<-tbl_df(filteredActivityData)

#str(tidyData)
#?group_by
#group the data along subject and activity
groupedTidyData<-group_by(tidyData,SubjectID,ActivityID)
#identical(tidyData,groupedTidyData)
#?summarize_each
#?summarize_all
AverageTidyData<-summarise_each(groupedTidyData,funs(mean))
#Getting the Actity Type for easy viewing
cleandata<-merge(AverageTidyData,activity,by='ActivityID',all.x = TRUE)
write.table(cleandata, './cleandata.txt',row.names=FALSE,sep='\t');

