# Script to download and tidy the data set ready for analysis

# 1. Load `dplyr` package for simple data frame manipulation
library(dplyr)

# 2. Assign the url for the data set as `accel_url`.
accel_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# 3. Check for `accel_data.zip`; if it's not there, download it from the url above.
if(!file.exists("./accel_data.zip")) {
    download.file(url = accel_url, 
                  destfile = "./accel_data.zip", 
                  method = "curl")
    download_date <- date()
}

# 4. Check for `./data/`; if it's not there, unzip `accel_data.zip` into the current working directory.
if(!dir.exists("./data/")) {
    unzip("./accel_data.zip", exdir = ".")
}

# 5. Check for `./UCI HAR Dataset/`; if it's not there, rename `./UCI HAR Dataset/` to `./data/`.
if(dir.exists("./UCI HAR Dataset/")) {
    file.rename("UCI HAR Dataset", "data")
}

# 6. Load in features as `headers`.
headers <- read.table("./data/features.txt")

# 7. Load in test measurements as `test_data` and make it a tibble.
test_data <- read.table("./data/test/X_test.txt", 
                        colClasses = c("numeric"))
test_data <- tbl_df(test_data)

# 8. Rename column names in `test_data` using the rows from column 2 in `headers`.
names(test_data) <- headers[,2]

# 9. Remove columns from `test_data` that have duplicate names, keeping the last for each duplicate.
test_data <- subset(test_data, select = which(!duplicated(names(test_data))))

# 10. Load in subject id tags for the test set as `subject_test` with column name as `subject_id`.
subject_test <- tbl_df(read.table("./data/test/subject_test.txt",
                                  col.names = "subject_id"))

# 11. Load in activity tags for the test set as `activity_test` with column name as `activity`.
activity_test <- read.table("./data/test/y_test.txt",
                            col.names = "activity")

# 12. Combine the three data frames `subject_test`, `activity_test`, `test_data` as `test_data`.
test_data <- cbind(subject_test, activity_test, test_data)

# 13. Repeat steps 7-12, replacing all instances of `test` with `train`.
train_data <- tbl_df(read.table("./data/train/X_train.txt",
                        colClasses = c("numeric")))
train_data <- tbl_df(train_data)

names(train_data) <- headers[,2]

train_data <- subset(train_data, select=which(!duplicated(names(train_data))))

subject_train <- tbl_df(read.table("./data/train/subject_train.txt",
                                   col.names = "subject_id"))

activity_train <- read.table("./data/train/y_train.txt",
                             col.names = "activity")

train_data <- cbind(subject_train, activity_train, train_data)

# 14. Make sure your data is still a tibble.
test_data <- tbl_df(test_data)
train_data <- tbl_df(train_data)

# 15. Merge `test_data` and `train_data` as `tidy_data`.
tidy_data <- tbl_df(rbind(test_data, train_data))

# 16. Make a subset of `tidy_data` as `tidy_data_sub` containing the columns `student_id`, `activity`, and any columns matching the literal strings `"-mean()"` or `"-std()"`, in that order.
tidy_data_sub <- tbl_df(select(tidy_data, 
                                  contains("subject_id"), 
                                  contains("activity"),
                                  contains("-mean()"),
                                  contains("-std()")))

# 17. Load in activity labels as `activity_labels`.
activity_labels <- read.table("./data/activity_labels.txt")

# 18. Replace all instances of `numeric` activity labels in `tidy_data_sub` with their value pair `character` from `activity_labels`.
tidy_data_sub <- mutate(tidy_data_sub, activity = activity_labels$V2[activity])

# 19. Group `tidy_data_sub` by variables `activity` and `subject_id`.
tidy_data_sub <- group_by(tidy_data_sub, activity, subject_id)

# 20. Make a subset of `tidy_data_sub`, containing the average of each variable for each activity and each subject, as `final`.
final <- tbl_df(aggregate(tidy_data_sub, 
                          by = list(tidy_data_sub$subject_id, 
                                    tidy_data_sub$activity), 
                          mean))

# 21. Remove the now redunant columns 3-4 from `final`.
final <- select(final, -(3:4))

# 22. Fix the column names 1-2 by renaming `subject_id` and `activity` in `final`.
final <- rename(final, subject_id = 1, activity = 2)

# 23. Write the data frame `final` out to the file `./data/final_data.csv`.
write.table(final, file = "./data/final_data.txt", row.names = FALSE)
