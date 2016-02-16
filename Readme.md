---
title: "Readme"
output: html_document
---

The script run_analysis.R performs several data manipulations to create a tidy data summary export file. 

1. It loads the ply and dplyr packages for later use./
2. it checks whether a "/data"" directory exists in the primary directory. If the directory does not exist it is created.
3. the data files for the analysis are downloaded directly into the new "/data" directory.
4. the downloaded zip file is unzipped into the "/data" folder.
5. the "features" and "activities" decription text files are loaded as vectors to be combined with the primary data files as labels.
6. the 3 files associated with the test subjects are read in as data tables from their repsectives CSV files.
7. these files are are then joined used the cbind() command since they do not contain a pertinent "id" column to link the files (and each data frame has equal corresponding rows.
8. The same process as in #7 is repeated for the training subjects.
9. the train and test data tables are combined using the rbind() function. Note, this same task can be completed using the join() command with the argument type = "full"
10. the mean and std columns are extracted by using the grep be using the "|" OR operator.
11. the activity_id column is then mutate the replace the index values with activity descriptions by using the mapvalues() function.
12. an _avgs data table is created by summarizing the mean of each column, grouped by "activity_id" and "subject_id"
13. the _avgs summary file is exported to the "/output" folder as a .csv file. If the "/outpout" folder does not exist, it is created.

