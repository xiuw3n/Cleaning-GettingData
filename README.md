Run_Analysis
================

`{r setup, include=FALSE} knitr::opts_chunk$set(echo = TRUE)`

## GitHub Documents

This is an R Markdown format used for publishing markdown documents to
GitHub. When you click the **Knit** button all R code chunks are run and
a markdown file (.md) suitable for publishing to GitHub is generated.

Code starts here!

Get the library of dplyr 
```{r}
library(dplyr) 
```
Read the test set, label and subjects 
```{r}
test <- read.table(“UCI HAR Dataset/test/X_test.txt”,sep="“,header=FALSE) testlabel 
read.table(”UCI HAR Dataset/test/y_test.txt“,sep=”“,header=FALSE)
subjecttest <- read.table(”UCI HAR Dataset/test/subject_test.txt“,sep=”",header=FALSE)
```

Merge the test set, label and subjects into a variable “fulltest”
```{r}
fulltest <- mutate(test, Label = testlabel, .before=1) 
fulltest <- mutate(fulltest,Subject = subjecttest,.before=1)
```
Read the training set, label and subjects 
```{r}
train <- read.table(“UCI HAR Dataset/train/X_train.txt”,sep="“,header=FALSE)
trainlabel <- read.table(”UCI HAR Dataset/train/y_train.txt“,sep=”“,header=FALSE) 
subjecttrain <- read.table(”UCI HAR Dataset/train/subject\_train.txt“,sep=”",header=FALSE)
```

Merge training set, label and subjects into a variable “fulltrain”
```{r}
fulltrain <- mutate(train,“Label” = trainlabel,.before=1) 
fulltrain <- mutate(fulltrain,“Subject” = subjecttrain,.before=1)
```

Merge fulltrain and fulltest set into variable “mergedata” 
```{r}
mergedata <- full_join(fulltest,fulltrain)
```

Label the variables using the featurs.txt 
```{r}
features <- read.table(“UCI HAR Dataset/features.txt”,sep="“,header=FALSE) 
features <- features[,2] 
names(mergedata) <- c(”Subject“,”Label",features)
```

Find all features/variables with mean and std 
```{r}
index <- grep(“.mean\\(\\).|.std\\(\\).”,names(mergedata))
```

Extract relevant data that match the index 
```{r}
dataextract <- mergedata[,c(1,2,index)]
dataextract$Label <- as.integer(unlist(dataextract$Label))
dataextract$Subject <- as.integer(unlist(dataextract$Subject))
```

Extract activity label
```{r}
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
names(activity_labels) <-c("Label","Activity")
```

Merge activity labels with dataextract 
```{r}
dataextract2 <- merge(dataextract, activity_labels,by="Label",all.x=TRUE)
```

Create a second dataset
```{r}
library(data.table)
DT <- as.data.table(dataextract2)
DT2 <- DT[, lapply(.SD,mean), by = "Subject,Activity,Label"]
write.table(DT2,file="dataset.txt",row.name=FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
names(activity_labels) <-c("Label","Activity")

##merge activity labels with dataextract 
dataextract2 <- merge(dataextract, activity_labels,by="Label",all.x=TRUE)

##create a second dataset
library(data.table)
DT <- as.data.table(dataextract2)
DT2 <- DT[, lapply(.SD,mean), by = "Subject,Activity,Label"]
write.table(DT2,file="dataset.txt",row.name=FALSE)
```
