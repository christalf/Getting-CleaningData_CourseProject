# Getting and Cleaning Data Course Project | Coursera.

This repo is a submission for a peer-graded assignment of a Coursera's Getting
and Cleaning Data Course Project (from Johns Hopkins University).

It carries out the project instructions to collect a raw dataset from the web,
clean it up and produce a final tidy dataset.

- The original raw dataset is a Human Activity Recognition database built
  from the recordings of 30 subjects performing activities of daily living
  (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.  
  
- The final tidy dataset is the average of each mean and standard deviation
  measurment for each activity and each subject.  
    
The files submitted on this repo are the following:

1. `run_analysis.R` script. It contains the instructions list performed (and that
   can be reproduced) to take the raw data of the course project and produce a final
   tidy dataset. The steps that this script performs, are the following:
    - Download the project's raw data.  
    - Read project's raw data from disk.  
    - Merge the training and the test sets to create one dataset.  
    - Extract only the measurments on the mean and standard deviation for each
      measurement.  
    - Use descriptive activity names to name the activities in the dataset.  
    - Appropriately label the dataset with descriptive variable names.  
    - From the dataset in the previous step, create a second, independent tidy dataset
      with the average of each variable for each activity and each subject (this is
      the final tidy dataset requested by the project).  
2. `tidyFinalData.txt` file. It's the final tidy dataset produced and exported by
   the analysis script peviously mentioned.  
3. `CodeBook.md` file. It describes the variables, the data, and all the work and
   transformations performed to clean up the data.  
4. Finally, the uncompressed downloaded raw dataset under the folder `UCI HAR Dataset`.  

***
