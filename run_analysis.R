activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("features.txt", col.names = c("seq_no","feature"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")

x_test <- read.table("test/X_test.txt", col.names = features$feature)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")

x_train <- read.table("train/X_train.txt", col.names = features$feature)
y_train <- read.table("train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

CleanData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
CleanData$code <- activities[CleanData$code, 2]

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

FinalData <- CleanData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
print