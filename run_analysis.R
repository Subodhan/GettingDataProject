# Set working directory
#setwd(...)
#### Read common data ####

library(dplyr)
library(reshape2)

#sample_size = 100
#read the column names for the data
names_colnames <- read.table("./features.txt", sep = " ")

#read the activity labels
names_activities <- read.table("./activity_labels.txt", sep = " ")
names(names_activities) <- c("activity_id", "activity_name")

#### Read the Train dataset ####

# read the data
train_data <- read.fortran("./train/X_train.txt", format="561F16")
# assign appropriate column names for the data 
names(train_data) <- names_colnames[,2]

# read the train subject data
train_subject <- read.table("./train/subject_train.txt")
names(train_subject) <- "Subject_id"

# read the train activity data
train_activity <- read.table("./train/y_train.txt")
names(train_activity) <- "activity_id"

cum_train_data <- cbind(train_subject, train_activity, train_data)

#### Read the Test dataset ####

# read the data
test_data <- read.fortran("./test/X_test.txt", format="561F16")
# assign appropriate column names for the data 
names(test_data) <- names_colnames[,2]

# read the test subject data
test_subject <- read.table("./test/subject_test.txt")
names(test_subject) <- "Subject_id"

# read the test activity data
test_activity <- read.table("./test/y_test.txt")
names(test_activity) <- "activity_id"

cum_test_data <- cbind(test_subject, test_activity, test_data)

# merge the train and test data together
cum_data <- rbind(cum_train_data, cum_test_data)


# prepare to extract the mean and std data
names_with_mean <- grep(".mean\\(.", names_colnames[,2], perl=TRUE, value=TRUE)
names_with_std <- grep(".std\\(.", names_colnames[,2], perl=TRUE, value=TRUE)

extracted_data <- subset(cum_data, select = c("Subject_id", "activity_id", names_with_mean, names_with_std))

temp_df1 <- melt(extracted_data, id.vars=c("Subject_id", "activity_id"))
temp_df2 <- dcast(temp_df1, Subject_id + activity_id ~ variable, mean)

# now replace the activity id with activity label
temp_df3 <- merge(names_activities, temp_df2, by.x = "activity_id", by.y = "activity_id", all = FALSE)
temp_df3 <- select(temp_df3, -(activity_id))

tidy_data <- melt(temp_df3, id.vars=c("Subject_id", "activity_name"))
tidy_data <- arrange(tidy_data, Subject_id, activity_name)
names(tidy_data) <- c("Subject_id", "Activity_Name", "measure_name", "mean_value")

write.table(tidy_data, "./outputData.txt", row.names = FALSE)
