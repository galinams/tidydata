# tidydata function reads  and merges the test and training sets to create one data set, extracts only the measurements of #mean and standard deviation for each measurement, uses descriptive activity names to names activties in the data set, and #appropriately labels dataset with descriptive variable names. Finally creates second independet tidy dataset with the #average of each variable fo reach activity and each subject.
##read seven raw data files into R
xtest<- read.table("X_test.txt") 
xtrain<- read.table("X_train.txt")
subjecttrain<- read.table("subject_train.txt")
subjecttest<- read.table("subject_test.txt") 
ytest<- read.table("y_test.txt")
ytrain<- read.table("y_train.txt")
features<- read.table("features.txt")

##after looking at each file dimentions 
##attach data files like bricks to each other
xtest_train<- rbind(xtest,xtrain) ##merge measurements from test and train data files
names(xtest_train)<- features[,2] ##pass names from features file as column titles
subjecttest_train<- rbind(subjecttest,subjecttrain) ##merge subject ids from test and train data sets 
names(subjecttest_train)<- "Subject" ##name the column as Subject
ytest_train<- rbind(ytest,ytrain)  ##merge activities from test and train data sets, create data file one column wide
names(ytest_train)<- "Activity" ##name the column as Activity 
y_subjecttest_train<- cbind(subjecttest_train,ytest_train) ##merge activity and subject data files
data<- cbind(xtest_train,y_subjecttest_train) ##merge measurements, activities, and subject ids of test and train datasets

valid_column_names<- make.names(names=names(data), unique=TRUE) ##generate column names that are syntatically valid and ##distinct in order to be able to read column names and select certain columns
names(data)<- valid_column_names ##pass valid column names to the complete raw dataset

library(dplyr) ##load dplyr package to use for further analysis
selected_data<-select(data,Subject,Activity,contains("mean"),contains("std") ##select Subject, Activity columns and columns that potentially contain mean and standard deviation measurements

selected_meanstd_data<-select(selected_data, -contains("angle"), -contains("meanFreq")) ##drop columns which contain 
##mean frequency and angles between two vectors as they are not true mean and standard deviation measurements

selected_meanstd_data[,2]<- as.character(factor(selected_meanstd_data[ ,2], labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")))
##replace numbers with descriptive activity names to name activitites in data set

aggregatedata<- aggregate(selected_meanstd_data[,3:68],by=list(selected_meanstd_data$Subject,selected_meanstd_data$Activity), FUN=mean) ##create second data set with the average of each variable for each activity and each subject

tidydata<-rename(aggregatedata,Subject=Group.1,Activity=Group.2) ##rename column names of first and second columns which were ##lost during the previous step
tidydata
