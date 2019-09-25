# Steps taken by `run_analysis.R` to tidy and manipulate the data set:

1. Load `dplyr` package for simple data frame manipulation
2. Assign the url for the data set as `accel_url`.
3. Check for `accel_data.zip`; if it's not there, download it from the url above.
4. Check for `./data/`; if it's not there, unzip `accel_data.zip` into the current working directory.
5. Check for `./UCI HAR Dataset/`; if it's not there, rename `./UCI HAR Dataset/` to `./data/`.
6. Load in features as `headers`.
7. Load in test measurements as `test_data` and make it a tibble.
8. Rename column names in `test_data` using the rows from column 2 in `headers`.
9. Remove columns from `test_data` that have duplicate names, keeping the last for each duplicate.
10. Load in subject id tags for the test set as `subject_test` with column name as `subject_id`.
11. Load in activity tags for the test set as `activity_test` with column name as `activity`.
12. Combine the three data frames `subject_test`, `activity_test`, `test_data` as `test_data`.
13. Repeat steps 7-12, replacing all instances of `test` with `train`.
14. Make sure your data is still a tibble.
15. Merge `test_data` and `train_data` as `tidy_data`.
16. Make a subset of `tidy_data` as `tidy_data_sub` containing the columns `student_id`, `activity`, and any columns matching the literal strings `"-mean()"` or `"-std()"`, in that order.
17. Load in activity labels as `activity_labels`.
18. Replace all instances of `numeric` activity labels in `tidy_data_sub` with their value pair `character` from `activity_labels`.
19. Group `tidy_data_sub` by variables `activity` and `subject_id`.
20. Make a subset of `tidy_data_sub`, containing the average of each variable for each activity and each subject, as `final`.
21. Remove the now redunant columns 3-4 from `final`.
22. Fix the column names 1-2 by renaming `subject_id` and `activity` in `final`.
23. Write the data frame `final` out to the file `./data/final_data.csv`.
