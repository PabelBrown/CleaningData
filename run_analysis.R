library(plyr); library(dplyr)

#Checks if the data directory exists, and creates it if not
if(!file.exists("~/data")){dir.create("~/data")}
setwd("~/data")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip")
unzip(zipfile = "~/data/UCI HAR Dataset.zip")

dirmain = "~/data/UCI HAR Dataset/"
dirtest = paste0(dirmain,"/test/")
dirtrain = paste0(dirmain,"/train/")

#create frame of the feature column names

df_features <- read.table(paste0(dirmain,"features.txt"))
features <- df_features[,2]
activities <- read.table(paste0(dirmain,"activity_labels.txt"))
actid <- as.vector(activities[,1])
actnames <- as.vector(activities[,2])

#gather and merge the test data results
test_x <- read.table(paste0(dirtest,"x_test.txt"),col.names = features)
test_y <- read.table(paste0(dirtest,"y_test.txt"),col.names = c("activity_id"))
test_subs <- read.table(paste0(dirtest,"subject_test.txt"),col.names = c("subject_id"))

#using cbind because multiple-step join here seems to produce NA for activity and id columns above
#test_m <- join(x=test_x,y=test_y)
#test_m <- join(x=test_m,y=test_subs)
test_m <- cbind(test_x, test_y, test_subs)

#gather and merge the train data results
train_x <- read.table(paste0(dirtrain,"X_train.txt"),col.names = features)
train_y <- read.table(paste0(dirtrain,"y_train.txt"),col.names = c("activity_id"))
train_subs <- read.table(paste0(dirtrain,"subject_train.txt"),col.names = c("subject_id"))

#trying the join_all to merge three dataframes - seems to produce NA for activity and id > using cbind again
#dflist_train <- list(train_x,train_y,train_subs)
#train_m <- join_all(dflist_train)
train_m <- cbind(train_x,train_y,train_subs)

#combine the two datasets - rbind to combine all the rows because both have common columns. "full" join should produce the same result.
both_m <- rbind(test_m,train_m)
#both_m2 <- join(x=test_m,y=train_m, type="full")

#extracts just the standard devitions and mean measures, along with the activity_id and subject_id
both_m <- both_m[,grepl(pattern = "std|mean|activity_id|subject_id", x = colnames(both_m))]

#replaces the activity_id column index values with their descriptions
both_m <- mutate(both_m,activity_id = mapvalues(activity_id,from = actid, to = actnames))

#convert both_m to data_table
both_m <- data.table(both_m)
both_avgs <- both_m[,lapply(.SD,mean), by=list(activity_id,subject_id)]

#checks if an output directory exists, creates one if not, and writes .csv for
if(!file.exists("~/data/output")){dir.create("~/data/output")}
write.table(x = both_avgs, "~/data/output/summary_avgs.txt", row.names = FALSE)