xtest<- read.table("X_test.txt")
xtrain<- read.table("X_train.txt")
subjecttrain<- read.table("subject_train.txt")
subjecttest<- read.table("subject_test.txt") 
ytest<- read.table("y_test.txt")
ytrain<- read.table("y_train.txt")
features<- read.table("features.txt")

xtest_train<- rbind(xtest,xtrain)
names(xtest_train)<- features[,2]
subjecttest_train<- rbind(subjecttest,subjecttrain)
names(subjecttest_train)<- "Subject"
ytest_train<- rbind(ytest,ytrain)
names(ytest_train)<- "Activity"
y_subjecttest_train<- cbind(subjecttest_train,ytest_train)
data<- cbind(xtest_train,y_subjecttest_train)

valid_column_names<- make.names(names=names(data), unique=TRUE)
names(data)<- valid_column_names

library(dplyr)
selected_data<-select(data,Subject,Activity,contains("mean"),contains("std"))

selected_meanstd_data<-select(selected_data, -contains("angle"), -contains("meanFreq"))
selected_meanstd_data[,2]<- as.character(factor(selected_meanstd_data[ ,2], labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")))

aggregatedata<- aggregate(selected_meanstd_data[,3:68],by=list(selected_meanstd_data$Subject,selected_meanstd_data$Activity), FUN=mean)

tidydata<-rename(aggregatedata,Subject=Group.1,Activity=Group.2)
dim(tidydata)
