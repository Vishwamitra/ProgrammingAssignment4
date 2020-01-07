---
title: "Code Book - Peer-graded Assignment: Getting and Cleaning Data Course Project"
---

### Download Data set
Downloaded the data set in local directory

### Read each files and store the data in a variable to perform the data tidying operations

#read the activity table and store the data frame with a given column names

```{r}
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
```

#read feature table and store the data frame in a variable with a given column names
```{r}
features <- read.table("features.txt", col.names = c("seq_no","feature"))
```

#read the Subject Test file and store in a data frame with a column named subject.
```{r}
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
```
#read the test data and sort them with the column names mentioned in features dataframe
```{r}
x_test <- read.table("test/X_test.txt", col.names = features$feature)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
```
#read the training data and sort them with the column names mentioned in features dataframe
```{r}
x_train <- read.table("train/X_train.txt", col.names = features$feature)
y_train <- read.table("train/y_train.txt", col.names = "code")
```
#Combine the training and test sets x-to-x,  y-to-y and subject to subject
```{r}
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
```
#now merge the subject and X and Y data
```{r}
Merged_Data <- cbind(Subject, Y, X)
```

#Extracts only the measurements on the mean and standard deviation for each measurement
```{r}
CleanData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
CleanData$code <- activities[CleanData$code, 2]
```
#set the correct label names with appropriate descriptive variable names
```{r}
names(CleanData)[2] = "activity"
names(CleanData)<-gsub("Acc", "Accelerometer", names(CleanData))
names(CleanData)<-gsub("Gyro", "Gyroscope", names(CleanData))
names(CleanData)<-gsub("BodyBody", "Body", names(CleanData))
names(CleanData)<-gsub("Mag", "Magnitude", names(CleanData))
names(CleanData)<-gsub("^t", "Time", names(CleanData))
names(CleanData)<-gsub("^f", "Frequency", names(CleanData))
names(CleanData)<-gsub("tBody", "TimeBody", names(CleanData))
names(CleanData)<-gsub("-mean()", "Mean", names(CleanData), ignore.case = TRUE)
names(CleanData)<-gsub("-std()", "STD", names(CleanData), ignore.case = TRUE)
names(CleanData)<-gsub("-freq()", "Frequency", names(CleanData), ignore.case = TRUE)
names(CleanData)<-gsub("angle", "Angle", names(CleanData))
names(CleanData)<-gsub("gravity", "Gravity", names(CleanData))
```
#summarize the clean data by using mean function group them by each activity and subject
```{r}
FinalData <- CleanData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
```