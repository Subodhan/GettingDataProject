# GettingDataProject
Project for Getting and Cleaning Data course
## Assumptions

It is assumed that the zip file contents are unzipped in the working directory. The folder structure, as created by unzip, has been retained. The run_analysis.R script file is copied to the working directory.

## Sequence of operations

* Include the dplyr and reshape2 libraries
* Read the features.txt file to get the 561 column names for data (var: names_colnames)
* Read the activity_labels.txt file to get the activity labels (var: names_activities)
* Read the 'train' data set from train subfolder
	* Read the data from X_train.txt file (var: train_data) and set the column names (names_colnames)
	* Read the subject data from subject_train.txt file (var: train_subject) and set the column names as "Subject_id"
	* Read the activity data from the y_train.txt file (var: train_activity) and set the column names as "activity_id"
	* Column bind the three data frames in the order Subject, activity and data to create cumulative data(var: cum_train_data)
* Read the 'test' data set from test subfolder
	* Read the data from X_test.txt file (var: test_data) and set the column names (names_colnames)
	* Read the subject data from subject_test.txt file (var: test_subject) and set the column names as "Subject_id"
	* Read the activity data from the y_test.txt file (var: test_activity) and set the column names as "activity_id"
	* Column bind the three data frames in the order Subject, activity and data to create cumulative data(var: cum_test_data)
* Merge the above two cumulative data sets to create a total cumulative data set using rbind (var: cum_data)
* using the grep command on the names_colnames table , extract the column names which contains the string 'mean(' (var:names_with_mean)
* using the grep command on the names_colnames table , extract the column names which contains the string 'std(' (var:names_with_std)
* Extract the following columns from cum_data into extracted_data data set:
	* Subject_id
	* activity_id
	* names_with_mean
	* names_with_std
* Using melt function create a tall and skiny dataset with 'Subject_id' and 'activity_id' as id columns (var: temp_df1)
* Calculate the mean for each Subject_id and activity_id combination for the measures (use dcast, var: temp_df2)
* Merge the names_activities table and the temp_df2 tables to insert activity_name column (use merge, var:temp_df3)
* Drop the activity_id column (use select)
* Once again use melt to create tall and skinny data set with 'Subject_id' and 'activity_name' as id columns (var: tidy_data)
* Arrange the data on 'Subject_id' and 'activity_name'
* write the table out with row.names = FALSE