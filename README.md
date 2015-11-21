The script is transforming the dataset in a following way:
1. It merges train and test sets by rows (union)
2. It extracts variables with mean or std
3. Attaches subject and activity columns with matched activity names.
4. Generates averages of columns for given subject/activity
5. Writes the resulted dataset to working directory in file "tidy_set.txt"
