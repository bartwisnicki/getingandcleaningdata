# Loading necessary packages

library(plyr)

# Loading necessary data
test <- read.table("test/X_test.txt")
train <- read.table("train/X_train.txt")
test_label <- read.table("test/y_test.txt")
train_label <- read.table("train/y_train.txt")
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")

features <- read.table("features.txt", stringsAsFactors = F)
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = F)

# Merging datasets by rbind
test_train <- rbind(test, train)

# Extracting measurements with with mean or std
with_mean <- grepl("mean", features[, 2])
with_std <- grepl("std", features[, 2])
with_mean_or_std <- with_mean | with_std
t_t <- test_train[, with_mean_or_std]

# Adding variable names and maping activities to strings
subject <- rbind(subject_test, subject_train)
activity <- rbind(test_label, train_label)

activity <- plyr::mapvalues(activity[, 1], activity_labels[, 1],
                            activity_labels[, 2])

test_train <- cbind(subject, activity, t_t)

names(test_train) <- c("subject", "activity", features[, 2][with_mean_or_std])

# Generating averages
activity_subject <- paste(test_train$activity, test_train$subject)
x <- split(test_train[, -c(1,2)], activity_subject)
tidy_test_train <- t(sapply(x, colMeans))
k <- unlist(strsplit(rownames(tidy_test_train), " "))
activity <- k[seq(from = 1, by = 2, length.out = length(k) / 2)]
subject <- as.numeric(k[seq(from = 2, by = 2, length.out = length(k) / 2)])
tidy_test_train <- as.data.frame(cbind(subject, activity, tidy_test_train))


# Writing the dataset
write.table(tidy_test_train, "tidy_set.txt", row.names = F)
