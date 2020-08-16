# Code Book

## Table of contents

1. [Introduction](#1)
2. [The original raw dataset](#2)
3. [How raw data is loaded into R](#3)
4. [Merging the training and the test sets to create one dataset](#4)
5. [Extracting only the measurments on the mean and standard deviation for each measurement](#5)
6. [Using descriptive activity names to name the ativities in the dataset](#6)
7. [Appropriately labeling the dataset with descriptive variable names](#7)
8. [Final step: obtaining the final tidy dataset by creating it from the dataset in the previous step, as a second, independent tidy dataset with the average of each variable for each activity and each subject](#8)
9. [Session info](#9)

## Introduction <a name="1"></a>

This code book refers to the tidy data stored in the `tidyFinalData.txt` file and
describes the variables, the data, and all the transformations performed by the
`run_analysis.R` script from the original raw dataset downloaded from the web up
to that final tidy data.

## The original raw dataset <a name="2"></a>

The files that contain the rawest form of the data which all the tidying process
was based on, were downloaded from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Those files belong to a Human Activity Recognition database built from the recordings
of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted
smartphone with embedded inertial sensors.

A full description of this original dataset is in [this site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## How raw data is loaded into R <a name="3"></a>

Once the dataset was downloaded, unziped into the working directory and examined the
names of all the unziped files, the analysis script reads from disk the files as follows:

- The dataset is randomly partitioned into two sets, where 70% of the volunteers was selected
  for generating the training data and 30% the test data.  
- The total number of observations of the dataset is 10299.  
    - The number of observations of the files that contain the test data partition is 2947.  
    - The number of those files containing the training data partition is 7352.  
- The files that have to be loaded are: `subject_test.txt`, `subject_train.txt`, `X_test.txt`,
  `X_train.txt`, `y_test.txt`, `y_train.txt`, `features.txt` and `activity_labels.txt`.  
- The `subject_test.txt` and `subject_train.txt` are loaded as data frames into a list
  variable called `subjectsList`.  
    - The first element of that list is a data frame with 2947 observations and 1 integer
      variable.  
    - The second element is a data frame with 7352 observations and 1 integer variable.  
    - Each row of both data frames, identifies the subject who performed the activity for
      each window sample. Because the number of volunteers who performed the experiment is
      30, the range of the variable is from 1 to 30.  
- The `X_test.txt` and `X_train.txt` are loaded as data frames into a list variable
  called `xList`.  
    - The first element of that list is a data frame with 2947 obs. and 561 numeric
      variables.  
    - The second element is a data frame with 7352 observations and 561 numeric variables.  
    - Because those data frames are a partition of the experiment, the 561 variables of
      each data frame represent the same, that is to say, they represent a specific
      measurment coming from the accelerometer and gyroscope 3-axial raw time domanin signals,
      later filtered and separated into body and gravity signals, subsequently derived to
      obtain Jerk signals and finally submitted to a Fast Fourier Transform to produce other
      freqency domain signals. The complete list of these 561 measurments is in the
      `features.txt` file.  
- The `y_test.txt` and `y_train.txt` are loaded as data frames into a list variable
  called `yList`.  
    - The first element of that list is a data frame with 2947 obs. and 1 integer variable.
    - The second element is a data frame with 7352 observations and 1 integer variable.  
    - Each row of both data frames, identifies the activity performed by each subject.
      Because the experiment involves six activities, the range of this variable is from 1
      to 6 and encodes the names of those activities contained in the `activity_labels.txt`
      file.  
- Finally, the `features.txt` and `activity_labels.txt` files are loaded separately in
  the `features` and `activities` variables, respectively.  
    - `activities` is a data frame with 6 rows and 2 columns. Each row contains the
      label and the name of one of the activity involved in the experiment, therefore, the
      first column is an integer variable and the second a factor variable.  
    - `features` is a data frame with 561 rows and 2 columns. Each row contains the
      code and the name of one of the measurments involved in the experiment so, again,
      the first column in an integer variable and the second a factor variable.  

## Merging the training and the test sets to create one dataset <a name="4"></a>

The way in which the data load was divided before, makes it easy to rebuild into one
dataset the original data partition. Indeed, the analysis script computes this step
as follows:

- First, it row-binds the test and training data frames together.  
    - From the `subjectsList`, it creates the `subjectMerged` data frame that ends up
      having 10299 obs. and 1 integer variable.  It also names this variable as
      *subject*.  
    - From the `xList`, it creates the `xMerged` data frame that ends up having 10299
      obs. and 561 variables. It also takes from the `features` data frame, the vector
      of the 561 measurments names and assigns it as the variable's names of the new
      merged data frame.  
    - From the `yList`, it creates the `yMerged` data frame that ends up having 10299
      obs. and 1 integer variable. It also names this variable as *label*.  
- Then, it column-binds all the above row-binded data frames (`subjectMerged`, `xMerged`
  and `yMerged`) into the final merged data frame, called `mergedDataset`, that ends
  up having 10299 obs. and 563 variables.  

## Extracting only the measurments on the mean and standard deviation for each measurement <a name="5"></a>

The analysis script first uses the `"[Mm]ean|std"` pattern to grep from the `feature`
column of the `features` data frame, only the names of the measurements we are interested
in.

- The result are 86 measurment names that are stored in the `means_stds` variable.  

Then, the scrip subsets the `mergedDataset` by selecting the columns `subject`, `label`
(that contains the encoding of the activities) and the 86 columns that matches the
`means_stds` vector.  

- The result is a new data frame, called `meanStdDataset`, with 10299 rows and 88 columns. 
- All the columns are `numeric` variables, exept for `subject` and `label` (that are
  `integer` variables).  

## Using descriptive activity names to name the ativities in the dataset <a name="6"></a>

As we saw, the `label` column of the `meanStdDataset` encodes the activities involved in
the experiment and whose names are in the `activity` column of the `activities` data frame.

So the analysis script uses the common `label` information, to create a vector of activity
names that matches and replaces the 10299 labels in the `label` column of `meanStdDataset`
(now this column becomes a `factor` variable).

## Appropriately labeling the dataset with descriptive variable names <a name="7"></a>

To achieve this purpose, the analysis script proceeds as follows:

- It creates a vector of 19 patterns to identify the sub-strings in all the variables'
  names that are to be replaced. The patterns are:  
  ```
  "label", "^t", "^f", "-", ",|\\(,", "Acc", "Gyro", "Mag", "jerk", "mean\\(\\)",
  "std\\(\\)", "meanFreq\\(\\)", "^angle\\(t", "^angle\\(X", "^angle\\(Y", "^angle\\(Z",
  "gravity\\)", "gravityMean\\)" and "BodyBody"
  ```  
- Then it creates a vector with the 19 corrisponding replacements:  
  ```  
  "activity", "time", "frequency", "", ".", "Accelerometer", "Gyroscope", "Magnitude",
  "Jerk", ".mean", ".standard", ".meanFrequency", "angle.Time", "angle.X", "angle.Y",
  "angle.Z", "Gravity", "GravityMean", "Body"
  ```  
- Finally, it loops over those vectors and makes at each step the corrisponding
  substitution in the variables' names in order to get descriptive names.  

## Final step: obtaining the final tidy dataset by creating it from the dataset in the previous step, as a second, independent tidy dataset with the average of each variable for each activity and each subject <a name="8"></a>

Finally the analysis script, after grouping the `meanStdDataset` by `activity` and `subject`,
summarizes all its `numeric` variables (as we saw, all variables are `numeric` except for
`activity` and `subject` that are also the grouping variables), by taking the mean.

That produces the **final tidy dataset, called `averagesDataset`**, with 180 observations and
88 variables.

It is then exported into the `tidyFinalData.txt` file.

## Session info <a name="9"></a>

Here's the session info where the analysis script were run over.

```
R version 3.6.3 (2020-02-29)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 18.04.5 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.7.1
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.7.1

Random number generation:
 RNG:     Mersenne-Twister 
 Normal:  Inversion 
 Sample:  Rounding 
 
locale:
 [1] LC_CTYPE=es_AR.UTF-8       LC_NUMERIC=C               LC_TIME=es_AR.UTF-8        LC_COLLATE=es_AR.UTF-8    
 [5] LC_MONETARY=es_AR.UTF-8    LC_MESSAGES=es_AR.UTF-8    LC_PAPER=es_AR.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=es_AR.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] dplyr_1.0.1

loaded via a namespace (and not attached):
 [1] fansi_0.4.1      digest_0.6.25    utf8_1.1.4       assertthat_0.2.1 crayon_1.3.4     R6_2.4.1        
 [7] lifecycle_0.2.0  magrittr_1.5     evaluate_0.14    pillar_1.4.6     cli_2.0.2        rlang_0.4.7     
[13] rstudioapi_0.11  vctrs_0.3.2      generics_0.0.2   ellipsis_0.3.1   rmarkdown_2.3    tools_3.6.3     
[19] glue_1.4.1       purrr_0.3.4      xfun_0.16        compiler_3.6.3   pkgconfig_2.0.3  htmltools_0.5.0 
[25] knitr_1.29       tidyselect_1.1.0 tibble_3.0.3
```
***
