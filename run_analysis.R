

library(dplyr)
##read the test set, label and subjects
test <- read.table("UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
testlabel <- read.table("UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE)
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt",sep="",header=FALSE)

##merge the test set, label and subjects 
fulltest <- mutate(test, Label = testlabel, .before=1)
fulltest <- mutate(fulltest,Subject = subjecttest,.before=1)

##read the training set, label and subjects
train <- read.table("UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)
trainlabel <- read.table("UCI HAR Dataset/train/y_train.txt",sep="",header=FALSE)
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE)

##merge training set, label and subjects
fulltrain <- mutate(train,"Label" = trainlabel,.before=1)
fulltrain <- mutate(fulltrain,"Subject" = subjecttrain,.before=1)

##merge train and test set
mergedata <- full_join(fulltest,fulltrain)

##label the variables
features <- read.table("UCI HAR Dataset/features.txt",sep="",header=FALSE)
features <- features[,2]
names(mergedata) <- c("Subject","Label",features)

##find all features with mean and std
index <- grep(".mean\\(\\).|.std\\(\\).",names(mergedata))

##extract relevant data that match the index
dataextract <- mergedata[,c(1,2,index)]
dataextract$Label <- as.integer(unlist(dataextract$Label))
dataextract$Subject <- as.integer(unlist(dataextract$Subject))


##extract activity label
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
names(activity_labels) <-c("Label","Activity")

##merge activity labels with dataextract 
dataextract2 <- merge(dataextract, activity_labels,by="Label",all.x=TRUE)

##create a second dataset
library(data.table)
DT <- as.data.table(dataextract2)
DT2 <- DT[, lapply(.SD,mean), by = "Subject,Activity,Label"]
write.table(DT2,file="dataset.txt",row.name=FALSE)