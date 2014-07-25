---
title: 'Modeling in Revolution R Enterprise \newline  Module 1: Overview and Review'
fontsize: '10pt'
author: 'Revolution Analytics'
header-icons: 
  - "REV_Icon_Consulting_RGB"
  - "REV_Icon_TrainingServices_RGB"
toc: TRUE
---


## Overview

After completing this course, you will be able to:

- Conduct predictive analysis on your enterprise data using regression and tree-based models. 
- Implement models through embedded scoring functions in Revolution R Enterprise. 
- Use advanced algorithms for unsupervised learning and data manipulation such as principal components and clustering techniques.
- Understand key concepts in coding big data functions efficiently.


## Algorithm and Function Overview

The basic methods we will cover in this course are listed as follows:

- Linear Regression Modeling and Evaluation
    * Simple Regression
    * Multivariate Regression
    * Complex Formulas and Higher Order Terms
    * Stepwise Regression
- Generalized Linear Models
    * Logistic Regression
    * Additional Forms for General Linearized Models
- Data Mining using Trees and Forests
    * Tree Modeling
    * Random Forest

## Algorithm and Function Overview

- Unsupervised Model and Other Techniques
    * Clustering
    * Principal Components
    * Running Simulations

## The Data

Throughout this course we will be using the following data set:

 - Bank Marketing data set from the Machine Learning Repository at University of California, Irvine
 
[Moro et al., 2011] S. Moro, R. Laureano and P. Cortez. Using Data Mining for Bank Direct Marketing: An Application of the CRISP-DM Methodology. In P. Novais et al. (Eds.), Proceedings of the European Simulation and Modelling Conference - ESM'2011, pp. 117-121, Guimaraes, Portugal, October, 2011. EUROSIS (http://hdl.handle.net/1822/14838)

## The Data: Bank Marketing Data

The Bank Marketing Data Set, which we will refer to as the Bank data, concerns the direct marketing campaigns, or phone calls, of a Portuguese banking institution to its clientele, and the success of those campaigns in causing customers to subscribe to a term deposit. Multiple types of data are collected on each bank client, such as information on one's age and marital status. 

    
## Review: Creating a Data Source

We can create the data source using one of the the following commands:


```r
# infile <- file.path("data", "bank-full.csv") 
# BankDS <- RxTextData(file = infile) 

infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile) 
```

## Review: Creating a Data Source

We can get basic information about the data using the the following commands:


```r
rxGetInfo(BankDS, getVarInfo=TRUE, numRows=6)
```

```
## File name: D:\Github\Legacy_Course_Materials\modules\Modeling\Overview_and_Review\doc\data\BankXDF.xdf 
## Number of observations: 45211 
## Number of variables: 21 
## Number of blocks: 5 
## Compression type: zlib 
## Variable information: 
## Var 1: age, Type: integer, Low/High: (18, 95)
## Var 2: job
##        12 factor levels: management technician entrepreneur blue-collar unknown ... services self-employed unemployed housemaid student
## Var 3: marital
##        3 factor levels: married single divorced
## Var 4: education
##        4 factor levels: tertiary secondary unknown primary
## Var 5: default
##        2 factor levels: no yes
## Var 6: balance, Type: integer, Low/High: (-8019, 102127)
## Var 7: housing
##        2 factor levels: yes no
## Var 8: loan
##        2 factor levels: no yes
## Var 9: contact
##        3 factor levels: unknown cellular telephone
## Var 10: day, Type: integer, Low/High: (1, 31)
## Var 11: month
##        12 factor levels: may jun jul aug oct ... jan feb mar apr sep
## Var 12: duration, Type: integer, Low/High: (0, 4918)
## Var 13: campaign, Type: integer, Low/High: (1, 63)
## Var 14: pdays, Type: integer, Low/High: (-1, 871)
## Var 15: previous, Type: integer, Low/High: (0, 275)
## Var 16: poutcome
##        4 factor levels: unknown failure other success
## Var 17: y
##        2 factor levels: no yes
## Var 18: balance_Pred, Type: numeric, Low/High: (850.9300, 1658.2380)
## Var 19: balance_StdErr, Type: numeric, Low/High: (14.6506, 1231.9305)
## Var 20: balance_Lower, Type: numeric, Low/High: (-1563.6740, 1491.9588)
## Var 21: balance_Upper, Type: numeric, Low/High: (1324.9665, 3265.5340)
## Data (6 rows starting with row 1):
##   age          job marital education default balance housing loan contact
## 1  58   management married  tertiary      no    2143     yes   no unknown
## 2  44   technician  single secondary      no      29     yes   no unknown
## 3  33 entrepreneur married secondary      no       2     yes  yes unknown
## 4  47  blue-collar married   unknown      no    1506     yes   no unknown
## 5  33      unknown  single   unknown      no       1      no   no unknown
## 6  35   management married  tertiary      no     231     yes   no unknown
##   day month duration campaign pdays previous poutcome  y balance_Pred
## 1   5   may      261        1    -1        0  unknown no         1370
## 2   5   may      151        1    -1        0  unknown no         1332
## 3   5   may       76        1    -1        0  unknown no         1305
## 4   5   may       92        1    -1        0  unknown no         1311
## 5   5   may      198        1    -1        0  unknown no         1348
## 6   5   may      139        1    -1        0  unknown no         1328
##   balance_StdErr balance_Lower balance_Upper
## 1          15.04          1340          1399
## 2          15.65          1301          1363
## 3          19.15          1267          1343
## 4          18.22          1275          1347
## 5          14.73          1319          1377
## 6          16.06          1296          1359
```

```r
rxSummary(~., BankDS)
```

```
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## Computation time: 0.063 seconds.
```

```
## Call:
## rxSummary(formula = ~., data = BankDS)
## 
## Summary Statistics Results for: ~.
## Data: BankDS (RxXdfData Data Source)
## File name: data/BankXDF.xdf
## Number of valid observations: 45211 
##  
##  Name           Mean      StdDev   Min      Max    ValidObs MissingObs
##  age              40.9362   10.619    18.00     95 45211    0         
##  balance        1362.2721 3044.766 -8019.00 102127 45211    0         
##  day              15.8064    8.322     1.00     31 45211    0         
##  duration        258.1631  257.528     0.00   4918 45211    0         
##  campaign          2.7638    3.098     1.00     63 45211    0         
##  pdays            40.1978  100.129    -1.00    871 45211    0         
##  previous          0.5803    2.303     0.00    275 45211    0         
##  balance_Pred   1362.2721   68.684   850.93   1658 45211    0         
##  balance_StdErr   20.1145   14.501    14.65   1232 45211    0         
##  balance_Lower  1322.8474   60.743 -1563.67   1492 45211    0         
##  balance_Upper  1401.6967   85.795  1324.97   3266 45211    0         
## 
## Category Counts for job
## Number of categories: 12
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  job           Counts
##  management    9458  
##  technician    7597  
##  entrepreneur  1487  
##  blue-collar   9732  
##  unknown        288  
##  retired       2264  
##  admin.        5171  
##  services      4154  
##  self-employed 1579  
##  unemployed    1303  
##  housemaid     1240  
##  student        938  
## 
## Category Counts for marital
## Number of categories: 3
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  marital  Counts
##  married  27214 
##  single   12790 
##  divorced  5207 
## 
## Category Counts for education
## Number of categories: 4
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  education Counts
##  tertiary  13301 
##  secondary 23202 
##  unknown    1857 
##  primary    6851 
## 
## Category Counts for default
## Number of categories: 2
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  default Counts
##  no      44396 
##  yes       815 
## 
## Category Counts for housing
## Number of categories: 2
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  housing Counts
##  yes     25130 
##  no      20081 
## 
## Category Counts for loan
## Number of categories: 2
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  loan Counts
##  no   37967 
##  yes   7244 
## 
## Category Counts for contact
## Number of categories: 3
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  contact   Counts
##  unknown   13020 
##  cellular  29285 
##  telephone  2906 
## 
## Category Counts for month
## Number of categories: 12
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  month Counts
##  may   13766 
##  jun    5341 
##  jul    6895 
##  aug    6247 
##  oct     738 
##  nov    3970 
##  dec     214 
##  jan    1403 
##  feb    2649 
##  mar     477 
##  apr    2932 
##  sep     579 
## 
## Category Counts for poutcome
## Number of categories: 4
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  poutcome Counts
##  unknown  36959 
##  failure   4901 
##  other     1840 
##  success   1511 
## 
## Category Counts for y
## Number of categories: 2
## Number of valid observations: 45211
## Number of missing observations: 0
## 
##  y   Counts
##  no  39922 
##  yes  5289
```

## Recap

Let's review some of the concepts covered in this module:

 - How do you create a data source?
