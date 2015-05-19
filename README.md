# Getting and Cleaning Data Project

## Introduction

The goal of this project is to generate a tidy dataset from data collected from the accelerometers from the Samsung Galaxy S smartphone.

## Study Design

The dataset used in this analysis is available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Additional information about the study and the data collected can be found on the [project page](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This analysis performs the following operations on the original dataset :

* merge subject informations, activities and observations in one dataset, both for the training and test data.
* merge training and test data in one dataset.
* filter the columns we are insterested in, which are only the mean and standard deviations of the variables.
* create an independent tidy data set with the average of each variable for each activity and each subject.

## Instructions

Download the Samsung dataset and unzip the file in your working directory, then run the R script "run_analysis.R". No parameters are required to run the script. An error will be raised if the dataset can not be found in the working directory.

After completion, the script will create a file in the working directory, "output.txt", containing the tidy dataset. This file can be read in R using :

```
read.table("./output.txt", header=TRUE)
```
