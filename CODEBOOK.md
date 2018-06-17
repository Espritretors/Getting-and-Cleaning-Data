Code Book
This script will merge the training and test data and output a tidy dataset containing the mean and standard deviations measures for all activities for each subject.
The script first checks if the data file exists in your working directory. If not, it will download and unzip the file.

Steps:

1.	The data is read from the different text files in the folder.
activity_labels : Description of activity IDs
features : Description  of each variables (columns) of X train and test
subject_test : subject IDs for test
subject_train : subject IDs for train
X_test : values of variables in test
X_train : values of variables in train
y_test : activity ID in test
y_train : activity ID in train

2.	Sets all the column names for Subjects for train and test, X_test, y_test, X_train, Y_train and the activity labels columns

3.	Extracts only mean() and std() from the data set columns through subsetting

4.	Adds the subject number and merges the training and test data sets

5.	Adds the activity labels column to give descriptive titles and removes the activity ids

6.	Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

7.	Cleans up the column names to remove parentheses and to give more descriptive names

8.	Outputs the tidy data as "tidy_data.txt"
