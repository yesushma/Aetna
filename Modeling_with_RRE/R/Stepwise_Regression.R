---
title: 'Modeling in Revolution R Enterprise \newline  Module 5: Stepwise Regression: \newline Linear, GLM, and Logistic'
fontsize: '10pt'
author: 'Revolution Analytics'
header-icons: 
  - "REV_Icon_Consulting_RGB"
  - "REV_Icon_TrainingServices_RGB"
toc: TRUE
---





## Stepwise Regression

Sometimes models may contain extraneous predictor variables that unnecessarily complicate our formula without substantially increasing our ability to explain our response variable. In this case, Stepwise Regression can provide a viable method to reduce model complexity by deleting superfluous predictor terms.

In this module, we will consider inclusion and exclusion of response variables in our statistical models. Up to now, our examples have largely concerned only a small subset of potential response variables to predict an outcome, and it can be useful to expand the number of response variables sometimes.

## Stepwise Regression

Some things to keep in mind when adding additional variables to our models:

 - Adding variables will always either increase or, at worst, cause the R-squared value for the model to remain the same.
 - At the same time, adding additional variables inherently increases the complexity of any statistical model.
 
## Added Complexity

It may seem tempting to add as many variables as possible to any model in the hopes of raising R-squared. Indeed, wouldn't an increase in our model's ability to account for the variance in the observational data worth any added complexity?

 - Not necessarily. When making predictions, the additional variables suddenly require the additional collection of data, which in application may be much more costly or even unfeasible. 
    * Also, if you have a model explaining, to a high degree of accuracy, a predictor variable by a small number of response variables, sometimes that is more desirable than having a model explaining the same predictor variable with limited improvement in accuracy.
 
## Adding Response Variables

Ultimately, the statistician must determine the attributes and detriments of adding or deleting variables. Usually, the debate surrounds two main points:

 1. What is the added benefit, in terms of accuracy, of keeping the debated response variable?
 2. Is it worth the added complexity?
 
After considering both of these points, an informed decision can be made on whether or not to keep the debated response variable.

## Model Selection: Stepwise Regression

This process may be tedious to perform for a large number of variables, especially for a large data set. Statisticians have developed algorithms to help users with the process of determining which predictor variables to keep and which to discard, and these processes are referred to as Stepwise Regression.

There are three main choices one has when dealing with variable selection, and we will consider each of these in a greater detail:

 - Forward Selection
 - Backwards Selection
 - Stepwise (a combination of forward and backward selection, bidirectional)

## Model Selection: Stepwise Regression

In ScaleR, stepwise linear regression is implemented by the appropriate regression function and rxStepControl.

- Using the correct regression function, add the variableSelection argument to the function call for stepwise regression. 

- Using rxStepControl, specify the method, the scope, and various control parameters. The default method, "stepwise", specifies a bidirectional search, while the scope provides upper and lower formulas for the search. 

## Methods of Variable Selection

There are three methods of variable selection supported by ScaleR:

- "forward": variables are added onto the minimal model one at a time until either no additional variable satisfies the selection criterion or until the maximal model is reached.
- "backward": variables are removed from the maximal model one at a time until either the removal of another variable won't satisfy the selection criterion or until the minimal model is reached.
- "stepwise": combination of forward and backward variable selection; that is, variables are added to the minimal model, but at each step the model is reanalyzed to re-evaluate whether previously added variables should be deleted from the updated (current) model.

## Example: Stepwise Regression

For this example, let's construct a multivariate linear model predicting balance from all of the other variables in the Bank data set. We can anticipate that this model could be potentially too complex with little added capability in predictability. Consequently, we will implement stepwise regression, using a scope specifying the lower bound as the minimal model and an upper bound as the maximal model. Note that the SigLevel step criterion is identical to using AIC:


```r
infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)

subLinMod <- rxLinMod(balance ~ age, data = BankDS, 
                      variableSelection = rxStepControl( 
                        method = "stepwise", 
                        scope = ~ age + job + marital + education + default +
                          housing + loan + contact + day + month + 
                          duration + campaign + pdays + 
                          previous + poutcome + y, 
                        stepCriterion = "SigLevel"))
```

```
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.031 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Elapsed computation time: 0.275 secs.
```

## Example: Stepwise Regression

This is a long summary, so let's consider the output:


```r
summary(subLinMod)
```

```
## Call:
## rxLinMod(formula = balance ~ age, data = BankDS, variableSelection = rxStepControl(method = "stepwise", 
##     scope = ~age + job + marital + education + default + housing + 
##         loan + contact + day + month + duration + campaign + 
##         pdays + previous + poutcome + y, stepCriterion = "SigLevel"))
## 
## Linear Regression Results for: balance ~ age + job + marital +
##     education + default + housing + loan + contact + day + month +
##     duration + campaign + pdays + previous + poutcome + y
## Data: BankDS (RxXdfData Data Source)
## File name: data/BankXDF.xdf
## Dependent variable(s): balance
## Total independent variables: 46 (Including number dropped: 9)
## Number of valid observations: 45211
## Number of missing observations: 0 
##  
## Coefficients: (9 not defined because of singularities)
##                      Estimate Std. Error t value Pr(>|t|)    
## (Intercept)         -1.25e+03   2.23e+02   -5.63  1.8e-08 ***
## age                  2.71e+01   1.72e+00   15.73  2.2e-16 ***
## month=may           -3.23e+02   1.31e+02   -2.47  0.01349 *  
## month=jun            1.02e+02   1.35e+02    0.75  0.45032    
## month=jul           -6.05e+02   1.31e+02   -4.60  4.3e-06 ***
## month=aug           -3.93e+02   1.31e+02   -2.99  0.00276 ** 
## month=oct            3.11e+02   1.65e+02    1.88  0.05955 .  
## month=nov            8.50e+02   1.35e+02    6.31  2.9e-10 ***
## month=dec            3.41e+02   2.38e+02    1.43  0.15132    
## month=jan           -7.63e+02   1.51e+02   -5.04  4.6e-07 ***
## month=feb           -3.02e+02   1.38e+02   -2.20  0.02815 *  
## month=mar            9.14e+01   1.84e+02    0.50  0.61879    
## month=apr           -4.87e+01   1.37e+02   -0.35  0.72283    
## month=sep             Dropped    Dropped Dropped  Dropped    
## education=tertiary   4.63e+02   5.64e+01    8.22  2.2e-16 ***
## education=secondary  9.73e+01   4.51e+01    2.16  0.03085 *  
## education=unknown    1.79e+02   8.03e+01    2.23  0.02572 *  
## education=primary     Dropped    Dropped Dropped  Dropped    
## loan=no              5.30e+02   3.92e+01   13.54  2.2e-16 ***
## loan=yes              Dropped    Dropped Dropped  Dropped    
## default=no           1.28e+03   1.06e+02   12.16  2.2e-16 ***
## default=yes           Dropped    Dropped Dropped  Dropped    
## marital=married      3.09e+02   4.54e+01    6.80  1.1e-11 ***
## marital=single       3.67e+02   5.26e+01    6.97  3.3e-12 ***
## marital=divorced      Dropped    Dropped Dropped  Dropped    
## housing=yes         -1.81e+02   3.38e+01   -5.37  8.0e-08 ***
## housing=no            Dropped    Dropped Dropped  Dropped    
## y=no                -1.69e+02   5.01e+01   -3.37  0.00074 ***
## y=yes                 Dropped    Dropped Dropped  Dropped    
## contact=unknown     -3.20e+02   7.03e+01   -4.55  5.3e-06 ***
## contact=cellular    -2.22e+02   5.94e+01   -3.73  0.00019 ***
## contact=telephone     Dropped    Dropped Dropped  Dropped    
## job=management       2.69e+01   1.10e+02    0.25  0.80577    
## job=technician      -1.56e+02   1.07e+02   -1.46  0.14530    
## job=entrepreneur    -5.05e+01   1.30e+02   -0.39  0.69694    
## job=blue-collar     -1.77e+02   1.08e+02   -1.64  0.10026    
## job=unknown         -9.76e+01   2.04e+02   -0.48  0.63232    
## job=retired         -1.15e+02   1.28e+02   -0.89  0.37103    
## job=admin.          -2.09e+02   1.10e+02   -1.91  0.05670 .  
## job=services        -2.50e+02   1.12e+02   -2.23  0.02565 *  
## job=self-employed   -1.66e+01   1.27e+02   -0.13  0.89624    
## job=unemployed      -2.51e+01   1.31e+02   -0.19  0.84787    
## job=housemaid       -1.86e+02   1.35e+02   -1.38  0.16763    
## job=student           Dropped    Dropped Dropped  Dropped    
## duration             1.72e-01   5.96e-02    2.89  0.00390 ** 
## day                  4.88e+00   1.91e+00    2.56  0.01052 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2970 on 45174 degrees of freedom
## Multiple R-squared: 0.0502 
## Adjusted R-squared: 0.0494 
## F-statistic: 66.3 on 36 and 45174 DF,  p-value: <2e-16 
## Condition number: 554.8
```

## Example: Stepwise Regression

Notice that only some values of months are determined to be significant. For instance, January clients tend to have smaller account balances, whereas November clients tend to have larger balances. However, for values like March, the response variable is not significant enough to have an noticeable effect on our model.


```r
summary(subLinMod)$balance$coefficients[4:14,]
```

```
##           Estimate Std. Error t value  Pr(>|t|)
## month=jun   102.16      135.3  0.7549 4.503e-01
## month=jul  -604.51      131.5 -4.5985 4.267e-06
## month=aug  -392.52      131.1 -2.9936 2.759e-03
## month=oct   311.47      165.3  1.8841 5.955e-02
## month=nov   849.92      134.8  6.3071 2.870e-10
## month=dec   340.98      237.6  1.4349 1.513e-01
## month=jan  -763.14      151.3 -5.0438 4.581e-07
## month=feb  -302.48      137.8 -2.1953 2.815e-02
## month=mar    91.42      183.7  0.4976 6.188e-01
## month=apr   -48.73      137.4 -0.3547 7.228e-01
## month=sep       NA         NA      NA        NA
```

## Example: Stepwise Regression

Similarly, clients owning a home tend to have lower account balances.


```r
summary(subLinMod)$balance$coefficients[26:27,]
```

```
##             Estimate Std. Error t value  Pr(>|t|)
## housing=yes   -181.1      33.75  -5.367 8.048e-08
## housing=no        NA         NA      NA        NA
```

## Example: Stepwise Regression

Notice that the R-squared value equals only about 5 percent, so even after the inclusion of all possible predictor variables our model still only explain about 5-percent of the variance contained in the observable data. 


```r
summary(subLinMod)$balance$r.squared
```

```
## [1] 0.0502
```

This value can be improved by considering more relevant statistical models; for instance, we have already discussed how age and balance are not linearly related, and therefore a non-linear regression would be more applicable.


## Exercise: Stepwise Regression

In this exercise, construct a similar model as the one above using all of the predictor variables in the Bank data set, except poutcome, only this time predict whether or not a client will subscribe to a term deposit (the y variable). Use a combination of forward and backward selection, and because of the binary response variable, remember to use logistic regression rather than linear regression.

.
.

## Exercise: Stepwise Regression

In this exercise, construct a similar model as the one above using all of the predictor variables in the Bank data set, except poutcome, only this time predict whether or not a client will subscribe to a term deposit (the y variable). Use a combination of forward and backward selection, and because of the binary response variable, remember to use logistic regression rather than linear regression.

 - Hint: start with a minimal model, as above, and define your scope to be the maximum number of response variables in the data set, excluding poutcome.

## Exercise: Solution

Constructing the logistic model, 


```r
subLogMod <- rxLogit(y ~ age, data = BankDS, 
                     variableSelection = rxStepControl( 
                       method = "stepwise", 
                        scope = ~ age + job + marital + education + default +
                          housing + loan + contact + day + month + 
                          duration + campaign + pdays + previous + balance,
                       stepCriterion = "SigLevel"))
```

```
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.064 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Iteration 4 time: 0.035 secs.
## 
## Elapsed computation time: 0.203 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.038 secs.
## 
## Elapsed computation time: 0.171 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Iteration 3 time: 0.036 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.042 secs.
## 
## Elapsed computation time: 0.209 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.039 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Iteration 5 time: 0.042 secs.
## 
## Elapsed computation time: 0.214 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.039 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.042 secs.
## 
## Elapsed computation time: 0.167 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.044 secs.
## 
## Elapsed computation time: 0.227 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.038 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.041 secs.
## 
## Elapsed computation time: 0.251 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.046 secs.
## 
## Elapsed computation time: 0.188 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Iteration 2 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.045 secs.
## 
## Elapsed computation time: 0.178 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.041 secs.
## 
## Elapsed computation time: 0.213 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.045 secs.
## 
## Elapsed computation time: 0.228 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.046 secs.
## 
## Elapsed computation time: 0.186 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.046 secs.
## 
## Elapsed computation time: 0.280 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Starting values (iteration 1) time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.038 secs.
## 
## Elapsed computation time: 0.169 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation.
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.038 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.039 secs.
## 
## Elapsed computation time: 0.166 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Iteration 3 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.036 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.038 secs.
## 
## Elapsed computation time: 0.241 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.039 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.044 secs.
## 
## Elapsed computation time: 0.261 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.041 secs.
## 
## Elapsed computation time: 0.252 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.042 secs.
## 
## Elapsed computation time: 0.269 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.041 secs.
## 
## Elapsed computation time: 0.273 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.045 secs.
## 
## Elapsed computation time: 0.282 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.043 secs.
## 
## Elapsed computation time: 0.271 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.047 secs.
## 
## Elapsed computation time: 0.281 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.048 secs.
## 
## Elapsed computation time: 0.293 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.046 secs.
## 
## Elapsed computation time: 0.284 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.049 secs.
## 
## Elapsed computation time: 0.296 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.048 secs.
## 
## Elapsed computation time: 0.282 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.045 secs.
## 
## Elapsed computation time: 0.270 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation.
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation. (similar message repeated 3 times)
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.043 secs.
## 
## Elapsed computation time: 0.280 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation.
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.042 secs.
## 
## Elapsed computation time: 0.266 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.039 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.042 secs.
## 
## Elapsed computation time: 0.272 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.041 secs.
## 
## Elapsed computation time: 0.257 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.039 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.040 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.038 secs.
## 
## Elapsed computation time: 0.243 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.043 secs.
## 
## Elapsed computation time: 0.275 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.004 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.044 secs.
## 
## Elapsed computation time: 0.281 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.048 secs.
## 
## Elapsed computation time: 0.302 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.048 secs.
## 
## Elapsed computation time: 0.288 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.049 secs.
## 
## Elapsed computation time: 0.321 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.048 secs.
## 
## Elapsed computation time: 0.298 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.049 secs.
## 
## Elapsed computation time: 0.296 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.046 secs.
## 
## Elapsed computation time: 0.283 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.050 secs.
## 
## Elapsed computation time: 0.306 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.051 secs.
## 
## Elapsed computation time: 0.301 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 6 time: 0.046 secs.
## 
## Elapsed computation time: 0.300 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.049 secs.
## 
## Elapsed computation time: 0.283 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.046 secs.
## 
## Elapsed computation time: 0.290 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 2 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.043 secs.
## 
## Elapsed computation time: 0.260 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.049 secs.
## 
## Elapsed computation time: 0.309 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.048 secs.
## 
## Elapsed computation time: 0.313 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 4 time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.052 secs.
## 
## Elapsed computation time: 0.323 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.051 secs.
## 
## Elapsed computation time: 0.316 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 6 time: 0.059 secs.
## 
## Elapsed computation time: 0.345 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.056 secs.
## 
## Elapsed computation time: 0.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.059 secs.
## 
## Elapsed computation time: 0.343 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.066 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.054 secs.
## 
## Elapsed computation time: 0.340 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.058 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.052 secs.
## 
## Elapsed computation time: 0.336 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 4 time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.056 secs.
## 
## Elapsed computation time: 0.335 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.068 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.057 secs.
## 
## Elapsed computation time: 0.340 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.047 secs.
## 
## Elapsed computation time: 0.289 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.043 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.045 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.043 secs.
## 
## Elapsed computation time: 0.280 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 3 time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.047 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 5 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.045 secs.
## 
## Elapsed computation time: 0.288 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.005 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 2 time: 0.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 4 time: 0.042 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 5 time: 0.044 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 6 time: 0.041 secs.
## 
## Elapsed computation time: 0.261 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.063 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.062 secs.
## 
## Elapsed computation time: 0.344 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.058 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 6 time: 0.055 secs.
## 
## Elapsed computation time: 0.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.063 secs.
## 
## Elapsed computation time: 0.345 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 6 time: 0.055 secs.
## 
## Elapsed computation time: 0.333 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.065 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 3 time: 0.076 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 4 time: 0.065 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.063 secs.
## 
## Elapsed computation time: 0.385 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.065 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.063 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.064 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.063 secs.
## 
## Elapsed computation time: 0.373 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.066 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.069 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.063 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.062 secs.
## 
## Elapsed computation time: 0.379 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.065 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 5 time: 0.074 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.064 secs.
## 
## Elapsed computation time: 0.377 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.065 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.063 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.064 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.064 secs.
## 
## Elapsed computation time: 0.371 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 5 time: 0.064 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.070 secs.
## 
## Elapsed computation time: 0.366 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.068 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.066 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.067 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.063 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.068 secs.
## 
## Elapsed computation time: 0.390 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.069 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 6 time: 0.053 secs.
## 
## Elapsed computation time: 0.348 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.061 secs.
## 
## Elapsed computation time: 0.354 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.058 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.056 secs.
## 
## Elapsed computation time: 0.325 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.060 secs.
## 
## Elapsed computation time: 0.349 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.078 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.082 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 4 time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.076 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 6 time: 0.078 secs.
## 
## Elapsed computation time: 0.450 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.077 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 3 time: 0.072 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 5 time: 0.073 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.073 secs.
## 
## Elapsed computation time: 0.434 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.063 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.082 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 3 time: 0.073 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 5 time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.074 secs.
## 
## Elapsed computation time: 0.444 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.067 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.078 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.076 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 4 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 6 time: 0.084 secs.
## 
## Elapsed computation time: 0.474 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Starting values (iteration 1) time: 0.081 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 2 time: 0.105 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.017 seconds 
## 
## Iteration 3 time: 0.133 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 4 time: 0.160 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.024 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 5 time: 0.194 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 6 time: 0.126 secs.
## 
## Elapsed computation time: 0.800 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.020 seconds 
## 
## Starting values (iteration 1) time: 0.103 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.108 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 4 time: 0.084 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 5 time: 0.076 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 6 time: 0.096 secs.
## 
## Elapsed computation time: 0.544 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Starting values (iteration 1) time: 0.189 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 2 time: 0.112 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 3 time: 0.098 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 4 time: 0.091 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 5 time: 0.099 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.099 secs.
## 
## Elapsed computation time: 0.689 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.064 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 2 time: 0.116 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.085 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.124 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 5 time: 0.139 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.020 seconds 
## 
## Iteration 6 time: 0.123 secs.
## 
## Elapsed computation time: 0.654 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Starting values (iteration 1) time: 0.089 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 2 time: 0.120 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Iteration 3 time: 0.108 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 4 time: 0.110 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.080 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.077 secs.
## 
## Elapsed computation time: 0.585 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.059 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.067 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 3 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.061 secs.
## 
## Elapsed computation time: 0.373 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.053 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.051 secs.
## 
## Elapsed computation time: 0.315 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 2 time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 3 time: 0.056 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 4 time: 0.058 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 5 time: 0.057 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Iteration 6 time: 0.056 secs.
## 
## Elapsed computation time: 0.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 2 time: 0.058 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.050 secs.
## 
## Elapsed computation time: 0.311 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.049 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.052 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.054 secs.
## 
## Elapsed computation time: 0.310 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.048 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.054 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 3 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 4 time: 0.051 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 6 time: 0.051 secs.
## 
## Elapsed computation time: 0.305 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Starting values (iteration 1) time: 0.055 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 7197.238 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.057 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 2 time: 7197.719 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.092 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.115 seconds 
## 
## Iteration 3 time: 0.595 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.132 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 4 time: 0.461 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 5 time: 0.292 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Iteration 6 time: 0.270 secs.
## 
## Elapsed computation time: 7199.395 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.027 seconds 
## 
## Starting values (iteration 1) time: 0.271 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.036 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Iteration 2 time: 0.268 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.028 seconds 
## 
## Iteration 3 time: 0.192 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.045 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 4 time: 0.192 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.029 seconds 
## 
## Iteration 5 time: 0.172 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.038 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Iteration 6 time: 0.203 secs.
## 
## Elapsed computation time: 1.302 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Starting values (iteration 1) time: 0.169 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.027 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 2 time: 0.187 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.025 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 3 time: 0.164 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Iteration 4 time: 0.276 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 5 time: 0.175 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.026 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 6 time: 0.174 secs.
## 
## Elapsed computation time: 1.148 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Starting values (iteration 1) time: 0.138 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.021 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Iteration 2 time: 0.157 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 3 time: 0.140 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.082 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.117 seconds 
## 
## Iteration 4 time: 0.334 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.102 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 5 time: 0.397 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 6 time: 0.313 secs.
## 
## Elapsed computation time: 1.483 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Starting values (iteration 1) time: 0.263 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.047 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 2 time: 0.395 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 3 time: 0.445 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 4 time: 0.398 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.068 seconds 
## 
## Iteration 5 time: 0.396 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.094 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.095 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 6 time: 0.526 secs.
## 
## Elapsed computation time: 2.435 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.031 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Starting values (iteration 1) time: 0.291 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 2 time: 0.334 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 3 time: 0.251 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Iteration 4 time: 0.232 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Iteration 5 time: 0.277 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 6 time: 0.325 secs.
## 
## Elapsed computation time: 1.716 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.031 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Starting values (iteration 1) time: 0.244 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.045 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Iteration 2 time: 0.349 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 3 time: 0.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 4 time: 0.341 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.030 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.029 seconds 
## 
## Iteration 5 time: 0.246 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.036 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Iteration 6 time: 0.226 secs.
## 
## Elapsed computation time: 1.761 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Starting values (iteration 1) time: 0.189 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 2 time: 0.269 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Iteration 3 time: 0.213 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.048 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.036 seconds 
## 
## Iteration 4 time: 0.259 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.034 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Iteration 5 time: 0.234 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.026 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.028 seconds 
## 
## Iteration 6 time: 0.198 secs.
## 
## Elapsed computation time: 1.369 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.021 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Starting values (iteration 1) time: 0.142 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.028 seconds 
## 
## Iteration 2 time: 0.229 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.027 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 3 time: 0.160 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.025 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.021 seconds 
## 
## Iteration 4 time: 0.139 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 5 time: 0.159 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.025 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 6 time: 0.149 secs.
## 
## Elapsed computation time: 0.981 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Starting values (iteration 1) time: 0.103 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 2 time: 0.116 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 3 time: 0.120 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 4 time: 0.131 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 5 time: 0.114 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 6 time: 0.105 secs.
## 
## Elapsed computation time: 0.692 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Starting values (iteration 1) time: 0.117 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 2 time: 0.120 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 3 time: 0.126 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 4 time: 0.140 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.021 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.027 seconds 
## 
## Iteration 5 time: 0.134 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.022 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 6 time: 0.136 secs.
## 
## Elapsed computation time: 0.775 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Starting values (iteration 1) time: 0.101 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 2 time: 0.135 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.017 seconds 
## 
## Iteration 3 time: 0.121 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.021 seconds 
## 
## Iteration 4 time: 0.122 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 5 time: 0.105 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.078 secs.
## 
## Elapsed computation time: 0.665 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.074 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.090 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.085 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 4 time: 0.077 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.084 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.082 secs.
## 
## Elapsed computation time: 0.495 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.070 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 2 time: 0.095 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 3 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 4 time: 0.072 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 5 time: 0.076 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.071 secs.
## 
## Elapsed computation time: 0.473 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.072 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.086 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 3 time: 0.082 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.085 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 5 time: 0.087 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.082 secs.
## 
## Elapsed computation time: 0.497 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Starting values (iteration 1) time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 2 time: 0.104 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 3 time: 0.097 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 4 time: 0.111 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 5 time: 0.106 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 6 time: 0.127 secs.
## 
## Elapsed computation time: 0.628 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Starting values (iteration 1) time: 0.107 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.027 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 2 time: 0.179 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 3 time: 0.179 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 4 time: 0.132 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 5 time: 0.143 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 6 time: 0.103 secs.
## 
## Elapsed computation time: 0.844 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.077 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 2 time: 0.097 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 3 time: 0.089 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 4 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 5 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 6 time: 0.093 secs.
## 
## Elapsed computation time: 0.538 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.017 seconds 
## 
## Starting values (iteration 1) time: 0.123 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 2 time: 0.120 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 3 time: 0.096 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 4 time: 0.097 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 5 time: 0.103 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 6 time: 0.099 secs.
## 
## Elapsed computation time: 0.641 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Starting values (iteration 1) time: 0.083 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 2 time: 0.102 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 3 time: 0.090 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 4 time: 0.091 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 5 time: 0.099 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 6 time: 0.089 secs.
## 
## Elapsed computation time: 0.557 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Starting values (iteration 1) time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 2 time: 0.099 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 3 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 5 time: 0.089 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 6 time: 0.091 secs.
## 
## Elapsed computation time: 0.532 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 2 time: 0.094 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 3 time: 0.089 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 4 time: 0.097 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 5 time: 0.089 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 6 time: 0.089 secs.
## 
## Elapsed computation time: 0.537 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.068 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 3 time: 0.080 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 5 time: 0.080 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.078 secs.
## 
## Elapsed computation time: 0.475 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.067 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.084 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.087 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 5 time: 0.080 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.082 secs.
## 
## Elapsed computation time: 0.482 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.061 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.080 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 3 time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 4 time: 0.071 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 5 time: 0.073 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.077 secs.
## 
## Elapsed computation time: 0.442 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.068 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.084 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 3 time: 0.080 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 4 time: 0.083 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 5 time: 0.081 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.080 secs.
## 
## Elapsed computation time: 0.478 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.060 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.076 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 3 time: 0.072 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 4 time: 0.071 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.070 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 6 time: 0.071 secs.
## 
## Elapsed computation time: 0.423 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.062 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.074 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 3 time: 0.068 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 4 time: 0.067 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 5 time: 0.068 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.071 secs.
## 
## Elapsed computation time: 0.413 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.007 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Starting values (iteration 1) time: 0.058 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 2 time: 0.074 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 3 time: 0.072 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Iteration 4 time: 0.071 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 5 time: 0.070 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Iteration 6 time: 0.069 secs.
## 
## Elapsed computation time: 0.414 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.009 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.065 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 2 time: 0.081 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 3 time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 4 time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 5 time: 0.075 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Iteration 6 time: 0.076 secs.
## 
## Elapsed computation time: 0.454 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.008 seconds 
## 
## Starting values (iteration 1) time: 0.074 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 2 time: 0.094 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 3 time: 0.084 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.088 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 5 time: 0.086 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.086 secs.
## 
## Elapsed computation time: 0.512 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.008 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Starting values (iteration 1) time: 0.072 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 2 time: 0.091 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 3 time: 0.082 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 4 time: 0.081 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 5 time: 0.081 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.012 seconds 
## 
## Iteration 6 time: 0.081 secs.
## 
## Elapsed computation time: 0.489 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Starting values (iteration 1) time: 0.153 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.021 seconds 
## 
## Iteration 2 time: 0.158 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 3 time: 0.091 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 4 time: 0.096 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 5 time: 0.094 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 6 time: 0.090 secs.
## 
## Elapsed computation time: 0.686 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Starting values (iteration 1) time: 0.099 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.021 seconds 
## 
## Iteration 2 time: 0.146 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 3 time: 0.146 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.021 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 4 time: 0.136 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 5 time: 0.118 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.027 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 6 time: 0.140 secs.
## 
## Elapsed computation time: 0.787 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Starting values (iteration 1) time: 0.096 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 2 time: 0.122 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.022 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 3 time: 0.113 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 4 time: 0.097 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 5 time: 0.092 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 6 time: 0.094 secs.
## 
## Elapsed computation time: 0.616 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.009 seconds 
## 
## Starting values (iteration 1) time: 0.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 2 time: 0.116 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Iteration 3 time: 0.097 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.013 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 4 time: 0.089 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.013 seconds 
## 
## Iteration 5 time: 0.090 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.315 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 6 time: 0.435 secs.
## 
## Elapsed computation time: 0.908 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.009 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.014 seconds 
## 
## Starting values (iteration 1) time: 408.429 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.017 seconds 
## 
## Iteration 2 time: 0.116 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.017 seconds 
## 
## Iteration 3 time: 0.114 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.017 seconds 
## 
## Iteration 4 time: 0.110 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 1.228 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Iteration 5 time: 1.408 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.026 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.023 seconds 
## 
## Iteration 6 time: 0.242 secs.
## 
## Elapsed computation time: 410.426 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.021 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Starting values (iteration 1) time: 0.173 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.022 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 2 time: 0.209 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 3 time: 0.197 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Iteration 4 time: 0.180 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Iteration 5 time: 0.208 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Iteration 6 time: 0.227 secs.
## 
## Elapsed computation time: 1.198 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Starting values (iteration 1) time: 0.157 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 2 time: 0.143 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 3 time: 0.143 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.021 seconds 
## 
## Iteration 4 time: 0.128 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.020 seconds 
## 
## Iteration 5 time: 0.129 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.021 seconds 
## 
## Iteration 6 time: 0.133 secs.
## 
## Elapsed computation time: 0.837 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Starting values (iteration 1) time: 0.118 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.022 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 2 time: 0.181 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.027 seconds 
## 
## Iteration 3 time: 0.162 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.020 seconds 
## 
## Iteration 4 time: 0.126 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 5 time: 0.145 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 6 time: 0.114 secs.
## 
## Elapsed computation time: 0.848 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.012 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.011 seconds 
## 
## Starting values (iteration 1) time: 0.091 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 2 time: 0.110 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.022 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 3 time: 0.119 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 4 time: 0.112 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Iteration 5 time: 0.117 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 6 time: 0.112 secs.
## 
## Elapsed computation time: 0.664 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.011 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Starting values (iteration 1) time: 0.090 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 2 time: 0.109 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 3 time: 0.104 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 4 time: 0.102 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.016 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 5 time: 0.104 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 6 time: 0.103 secs.
## 
## Elapsed computation time: 0.617 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.010 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.010 seconds 
## 
## Starting values (iteration 1) time: 0.086 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Iteration 2 time: 0.121 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 3 time: 0.109 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 4 time: 0.111 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.020 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 5 time: 0.124 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.020 seconds 
## 
## Iteration 6 time: 0.131 secs.
## 
## Elapsed computation time: 0.686 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.014 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Starting values (iteration 1) time: 0.107 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 2 time: 0.110 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 3 time: 0.107 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.016 seconds 
## 
## Iteration 4 time: 0.106 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Iteration 5 time: 0.103 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.015 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 6 time: 0.110 secs.
## 
## Elapsed computation time: 0.646 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.017 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.015 seconds 
## 
## Starting values (iteration 1) time: 0.114 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.022 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.020 seconds 
## 
## Iteration 2 time: 0.141 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Iteration 3 time: 0.155 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 4 time: 0.163 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.027 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 5 time: 0.166 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.034 seconds 
## 
## Iteration 6 time: 0.187 secs.
## 
## Elapsed computation time: 0.928 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.018 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.018 seconds 
## 
## Starting values (iteration 1) time: 1.640 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Iteration 2 time: 0.190 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.027 seconds 
## 
## Iteration 3 time: 0.196 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.027 seconds 
## 
## Iteration 4 time: 0.168 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.034 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 5 time: 0.219 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.034 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.030 seconds 
## 
## Iteration 6 time: 0.207 secs.
## 
## Elapsed computation time: 2.623 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.024 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.019 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.019 seconds 
## 
## Starting values (iteration 1) time: 0.181 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.008 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 2 time: 0.187 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.011 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.031 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 3 time: 0.179 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.026 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.025 seconds 
## 
## Iteration 4 time: 0.160 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.026 seconds 
## 
## Iteration 5 time: 0.171 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.024 seconds 
## 
## Iteration 6 time: 0.185 secs.
## 
## Elapsed computation time: 1.067 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.023 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Starting values (iteration 1) time: 0.174 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.010 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.091 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.085 seconds 
## 
## Iteration 2 time: 0.417 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 3 time: 0.428 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 4 time: 0.382 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 5 time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.121 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.115 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.084 seconds 
## 
## Iteration 6 time: 0.581 secs.
## 
## Elapsed computation time: 2.360 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.365 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.094 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 2 time: 0.522 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 3 time: 0.430 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.057 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 4 time: 0.381 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.104 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.047 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 5 time: 0.444 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.082 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.079 seconds 
## 
## Iteration 6 time: 0.496 secs.
## 
## Elapsed computation time: 2.647 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Starting values (iteration 1) time: 2.409 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 2 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.125 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 3 time: 0.501 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.103 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.108 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.119 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.077 seconds 
## 
## Iteration 4 time: 0.602 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.119 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.105 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.116 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.099 seconds 
## 
## Iteration 5 time: 0.659 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.094 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.073 seconds 
## 
## Iteration 6 time: 0.509 secs.
## 
## Elapsed computation time: 5.102 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Starting values (iteration 1) time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 2 time: 0.418 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 3 time: 0.372 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.057 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Iteration 4 time: 0.381 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.089 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 5 time: 0.377 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.085 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.068 seconds 
## 
## Iteration 6 time: 0.396 secs.
## 
## Elapsed computation time: 2.321 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.048 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Starting values (iteration 1) time: 0.301 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 2 time: 0.295 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Iteration 3 time: 0.243 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.036 seconds 
## 
## Iteration 4 time: 0.243 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.036 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.036 seconds 
## 
## Iteration 5 time: 0.253 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Iteration 6 time: 0.263 secs.
## 
## Elapsed computation time: 1.605 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.026 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.028 seconds 
## 
## Starting values (iteration 1) time: 0.209 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 2 time: 0.244 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 3 time: 0.222 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 4 time: 0.253 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Iteration 5 time: 0.247 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.038 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Iteration 6 time: 0.228 secs.
## 
## Elapsed computation time: 1.409 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 18.322 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.078 seconds 
## 
## Starting values (iteration 1) time: 18.599 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.057 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 2 time: 0.440 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 3 time: 0.289 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.054 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 4 time: 0.280 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Iteration 5 time: 0.245 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.036 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 6 time: 0.261 secs.
## 
## Elapsed computation time: 20.122 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.021 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Starting values (iteration 1) time: 0.184 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 2 time: 0.247 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 3 time: 0.217 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 4 time: 0.225 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 5 time: 0.223 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 6 time: 0.220 secs.
## 
## Elapsed computation time: 1.319 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.038 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.038 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.028 seconds 
## 
## Starting values (iteration 1) time: 0.240 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 2 time: 0.280 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.047 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Iteration 3 time: 0.244 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.034 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 4 time: 0.227 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 5 time: 0.236 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 6 time: 0.329 secs.
## 
## Elapsed computation time: 1.576 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Starting values (iteration 1) time: 0.273 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 2 time: 0.242 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.040 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 3 time: 0.237 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.038 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 4 time: 0.264 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.036 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 5 time: 0.236 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 6 time: 0.256 secs.
## 
## Elapsed computation time: 1.513 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Starting values (iteration 1) time: 0.197 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.036 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 2 time: 0.244 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Iteration 3 time: 0.220 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.038 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.040 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 4 time: 0.231 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.035 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Iteration 5 time: 0.222 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.038 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 6 time: 0.233 secs.
## 
## Elapsed computation time: 1.353 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.022 seconds 
## 
## Starting values (iteration 1) time: 0.205 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.034 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.031 seconds 
## 
## Iteration 2 time: 0.240 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Iteration 3 time: 0.232 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Iteration 4 time: 0.243 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.032 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Iteration 5 time: 0.221 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Iteration 6 time: 0.233 secs.
## 
## Elapsed computation time: 1.378 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.025 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.025 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.027 seconds 
## 
## Starting values (iteration 1) time: 0.207 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.037 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.040 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Iteration 2 time: 0.304 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 3 time: 0.343 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 4 time: 0.399 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 5 time: 0.384 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.092 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 6 time: 0.332 secs.
## 
## Elapsed computation time: 1.973 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.030 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.030 seconds 
## 
## Starting values (iteration 1) time: 0.238 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.111 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 2 time: 0.448 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 3 time: 0.389 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 4 time: 0.354 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.092 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 5 time: 0.448 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.026 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 6 time: 0.400 secs.
## 
## Elapsed computation time: 2.288 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.029 seconds 
## 
## Starting values (iteration 1) time: 0.316 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Iteration 2 time: 0.408 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.085 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Iteration 3 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 4 time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.100 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 5 time: 0.440 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 6 time: 0.377 secs.
## 
## Elapsed computation time: 2.293 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Starting values (iteration 1) time: 0.333 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 2 time: 0.405 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 3 time: 0.395 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.083 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 4 time: 0.411 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.070 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 5 time: 0.411 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 6 time: 0.376 secs.
## 
## Elapsed computation time: 2.341 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Starting values (iteration 1) time: 0.353 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 2 time: 0.426 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 3 time: 0.374 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.091 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 4 time: 0.413 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 5 time: 0.412 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.075 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.085 seconds 
## 
## Iteration 6 time: 0.468 secs.
## 
## Elapsed computation time: 2.454 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.047 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Starting values (iteration 1) time: 0.355 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.092 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.077 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.073 seconds 
## 
## Iteration 2 time: 0.513 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.084 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 3 time: 0.444 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.084 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 4 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 5 time: 0.416 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.085 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.088 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.075 seconds 
## 
## Iteration 6 time: 0.471 secs.
## 
## Elapsed computation time: 2.629 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Starting values (iteration 1) time: 0.352 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.080 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 2 time: 0.454 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 3 time: 0.425 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.078 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 4 time: 0.408 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.070 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 5 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 6 time: 0.416 secs.
## 
## Elapsed computation time: 2.484 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Starting values (iteration 1) time: 0.369 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 2 time: 0.394 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 3 time: 0.377 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 4 time: 0.374 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 5 time: 0.330 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 6 time: 0.390 secs.
## 
## Elapsed computation time: 2.241 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Starting values (iteration 1) time: 0.351 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 2 time: 0.410 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.084 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 3 time: 0.390 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 4 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.074 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 5 time: 0.416 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 6 time: 0.400 secs.
## 
## Elapsed computation time: 2.349 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.047 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Starting values (iteration 1) time: 0.332 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 2 time: 0.339 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.047 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 3 time: 0.315 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 4 time: 0.324 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.057 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 5 time: 0.312 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.047 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.048 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Iteration 6 time: 0.295 secs.
## 
## Elapsed computation time: 1.927 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.028 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Starting values (iteration 1) time: 0.227 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.054 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 2 time: 0.394 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 3 time: 0.345 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 4 time: 0.344 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 5 time: 0.396 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 6 time: 0.366 secs.
## 
## Elapsed computation time: 2.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Starting values (iteration 1) time: 0.343 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 2 time: 0.323 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Iteration 3 time: 0.321 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 4 time: 0.281 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 5 time: 0.334 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.048 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 6 time: 0.317 secs.
## 
## Elapsed computation time: 1.931 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.029 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.260 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.022 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 2 time: 0.401 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 3 time: 0.351 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.082 seconds 
## 
## Iteration 4 time: 0.413 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 5 time: 0.387 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 6 time: 0.372 secs.
## 
## Elapsed computation time: 2.190 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Starting values (iteration 1) time: 0.315 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 2 time: 0.315 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.038 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 3 time: 0.279 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.038 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 4 time: 0.269 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 5 time: 0.287 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Iteration 6 time: 0.267 secs.
## 
## Elapsed computation time: 1.737 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.031 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Starting values (iteration 1) time: 0.253 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 2 time: 0.387 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 3 time: 0.379 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.082 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 4 time: 0.415 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.095 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 5 time: 0.423 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 6 time: 0.381 secs.
## 
## Elapsed computation time: 2.243 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.047 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.034 seconds 
## 
## Starting values (iteration 1) time: 0.336 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 2 time: 0.386 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 3 time: 0.403 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 4 time: 0.393 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 5 time: 0.389 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.078 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 6 time: 0.394 secs.
## 
## Elapsed computation time: 2.307 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.023 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Starting values (iteration 1) time: 0.375 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 2 time: 0.453 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 3 time: 0.419 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.082 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.047 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 4 time: 0.429 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 5 time: 0.412 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.082 seconds 
## 
## Iteration 6 time: 0.460 secs.
## 
## Elapsed computation time: 2.556 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.048 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.047 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Starting values (iteration 1) time: 0.378 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.074 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 2 time: 0.463 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 3 time: 0.412 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 4 time: 0.434 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.075 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 5 time: 0.452 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.072 seconds 
## 
## Iteration 6 time: 0.437 secs.
## 
## Elapsed computation time: 2.588 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Starting values (iteration 1) time: 0.364 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 2 time: 0.455 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.094 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.073 seconds 
## 
## Iteration 3 time: 0.465 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.091 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.074 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 4 time: 0.435 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 5 time: 0.439 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 6 time: 0.421 secs.
## 
## Elapsed computation time: 2.586 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Starting values (iteration 1) time: 0.375 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.101 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 2 time: 0.507 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 3 time: 0.466 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.071 seconds 
## 
## Iteration 4 time: 0.463 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.090 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.085 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.085 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.070 seconds 
## 
## Iteration 5 time: 0.498 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.077 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.078 seconds 
## 
## Iteration 6 time: 0.481 secs.
## 
## Elapsed computation time: 2.799 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Starting values (iteration 1) time: 0.367 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.074 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 2 time: 0.432 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.097 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 3 time: 0.411 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.074 seconds 
## 
## Iteration 4 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.094 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 5 time: 0.437 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 6 time: 0.380 secs.
## 
## Elapsed computation time: 2.458 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.038 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Starting values (iteration 1) time: 0.300 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 2 time: 0.373 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 3 time: 0.347 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 4 time: 0.361 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 5 time: 0.354 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 6 time: 0.338 secs.
## 
## Elapsed computation time: 2.083 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Starting values (iteration 1) time: 0.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 2 time: 0.414 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 3 time: 0.381 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 4 time: 0.387 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 5 time: 0.395 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 6 time: 0.377 secs.
## 
## Elapsed computation time: 2.298 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.036 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Starting values (iteration 1) time: 0.305 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 2 time: 0.339 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 3 time: 0.367 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 4 time: 0.349 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 5 time: 0.358 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 6 time: 0.382 secs.
## 
## Elapsed computation time: 2.109 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.037 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.028 seconds 
## 
## Starting values (iteration 1) time: 0.265 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.070 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 2 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 3 time: 0.360 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 4 time: 0.351 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.057 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 5 time: 0.365 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 6 time: 0.336 secs.
## 
## Elapsed computation time: 2.079 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.300 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Iteration 2 time: 0.292 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.040 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Iteration 3 time: 0.267 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 4 time: 0.278 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 5 time: 0.266 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.040 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 6 time: 0.273 secs.
## 
## Elapsed computation time: 1.680 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.029 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.027 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.028 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.029 seconds 
## 
## Starting values (iteration 1) time: 0.232 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 2 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.067 seconds 
## 
## Iteration 3 time: 0.374 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 4 time: 0.364 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 5 time: 0.369 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 6 time: 0.323 secs.
## 
## Elapsed computation time: 2.046 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.048 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Starting values (iteration 1) time: 0.315 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 2 time: 0.378 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.088 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 3 time: 0.404 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 4 time: 0.371 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 5 time: 0.352 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 6 time: 0.335 secs.
## 
## Elapsed computation time: 2.163 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Starting values (iteration 1) time: 0.309 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 2 time: 0.291 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 3 time: 0.274 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 4 time: 0.269 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Iteration 5 time: 0.277 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 6 time: 0.271 secs.
## 
## Elapsed computation time: 1.698 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Starting values (iteration 1) time: 0.273 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 2 time: 0.409 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 3 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 4 time: 0.366 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 5 time: 0.385 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 6 time: 0.401 secs.
## 
## Elapsed computation time: 2.217 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.047 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.047 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Starting values (iteration 1) time: 0.328 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 2 time: 0.415 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.072 seconds 
## 
## Iteration 3 time: 0.398 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 4 time: 0.378 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 5 time: 0.406 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 6 time: 0.410 secs.
## 
## Elapsed computation time: 2.342 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.054 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Starting values (iteration 1) time: 0.366 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 2 time: 0.457 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 3 time: 0.402 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.095 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 4 time: 0.447 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.070 seconds 
## 
## Iteration 5 time: 0.450 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.094 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 6 time: 0.451 secs.
## 
## Elapsed computation time: 2.580 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Starting values (iteration 1) time: 0.355 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.077 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 2 time: 0.444 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 3 time: 0.406 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.082 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 4 time: 0.421 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.082 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 5 time: 0.419 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 6 time: 0.452 secs.
## 
## Elapsed computation time: 2.504 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Starting values (iteration 1) time: 0.403 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 2 time: 0.475 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.087 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.096 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.083 seconds 
## 
## Iteration 3 time: 0.493 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.095 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.084 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.080 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 4 time: 0.470 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.082 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 5 time: 0.455 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.090 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.081 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.072 seconds 
## 
## Iteration 6 time: 0.479 secs.
## 
## Elapsed computation time: 2.785 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.048 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Starting values (iteration 1) time: 0.357 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 2 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 3 time: 0.387 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 4 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 5 time: 0.372 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.088 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 6 time: 0.424 secs.
## 
## Elapsed computation time: 2.365 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.045 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.033 seconds 
## 
## Starting values (iteration 1) time: 0.312 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.070 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 2 time: 0.423 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.085 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 3 time: 0.384 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 4 time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 5 time: 0.370 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 6 time: 0.406 secs.
## 
## Elapsed computation time: 2.271 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.046 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Starting values (iteration 1) time: 0.350 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.074 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 2 time: 0.419 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 3 time: 0.427 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.079 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 4 time: 0.416 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.093 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 5 time: 0.415 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.089 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.084 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 6 time: 0.422 secs.
## 
## Elapsed computation time: 2.456 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.035 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.334 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.048 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 2 time: 0.432 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 3 time: 0.420 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 4 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.068 seconds 
## 
## Iteration 5 time: 0.427 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 6 time: 0.389 secs.
## 
## Elapsed computation time: 2.433 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Starting values (iteration 1) time: 0.318 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 2 time: 0.415 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 3 time: 0.423 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 4 time: 0.400 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 5 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 6 time: 0.359 secs.
## 
## Elapsed computation time: 2.297 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Starting values (iteration 1) time: 0.344 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.068 seconds 
## 
## Iteration 2 time: 0.443 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 3 time: 0.396 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 4 time: 0.403 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 5 time: 0.394 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 6 time: 0.386 secs.
## 
## Elapsed computation time: 2.377 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Starting values (iteration 1) time: 0.309 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Iteration 2 time: 0.315 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 3 time: 0.297 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 4 time: 0.287 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 5 time: 0.300 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 6 time: 0.324 secs.
## 
## Elapsed computation time: 1.837 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.039 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.039 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.276 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 2 time: 0.448 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.119 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 3 time: 0.437 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 4 time: 0.386 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 5 time: 0.404 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 6 time: 0.395 secs.
## 
## Elapsed computation time: 2.352 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.349 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 2 time: 0.458 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 3 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 4 time: 0.391 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 5 time: 0.388 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 6 time: 0.382 secs.
## 
## Elapsed computation time: 2.371 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.045 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Starting values (iteration 1) time: 0.307 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 2 time: 0.304 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 3 time: 0.286 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 4 time: 0.285 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 5 time: 0.286 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.048 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 6 time: 0.316 secs.
## 
## Elapsed computation time: 1.791 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.032 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Starting values (iteration 1) time: 0.285 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.071 seconds 
## 
## Iteration 2 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.088 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.149 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 3 time: 0.486 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 4 time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 5 time: 0.393 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 6 time: 0.406 secs.
## 
## Elapsed computation time: 2.365 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.049 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.048 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.036 seconds 
## 
## Starting values (iteration 1) time: 0.309 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 2 time: 0.411 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 3 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.112 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 4 time: 0.421 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.085 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 5 time: 0.421 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 6 time: 0.428 secs.
## 
## Elapsed computation time: 2.374 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.038 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Starting values (iteration 1) time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.087 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.077 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.074 seconds 
## 
## Iteration 2 time: 0.487 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 3 time: 0.417 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.085 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 4 time: 0.442 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 5 time: 0.412 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.093 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.052 seconds 
## 
## Iteration 6 time: 0.429 secs.
## 
## Elapsed computation time: 2.561 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Starting values (iteration 1) time: 0.405 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.086 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.080 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 2 time: 0.494 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.090 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.093 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 3 time: 0.454 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.097 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.087 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 4 time: 0.496 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.087 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 5 time: 0.474 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.088 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.091 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.092 seconds 
## 
## Iteration 6 time: 0.522 secs.
## 
## Elapsed computation time: 2.851 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.040 seconds 
## 
## Starting values (iteration 1) time: 0.346 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.054 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 2 time: 0.405 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.082 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 3 time: 0.385 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.070 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 4 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 5 time: 0.408 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.064 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 6 time: 0.395 secs.
## 
## Elapsed computation time: 2.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.040 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.032 seconds 
## 
## Starting values (iteration 1) time: 0.289 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 2 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.060 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 3 time: 0.389 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.056 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 4 time: 0.383 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.068 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.070 seconds 
## 
## Iteration 5 time: 0.426 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 6 time: 0.399 secs.
## 
## Elapsed computation time: 2.286 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.046 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Starting values (iteration 1) time: 0.347 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.053 seconds 
## 
## Iteration 2 time: 0.441 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.079 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 3 time: 0.396 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 4 time: 0.394 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.069 seconds 
## 
## Iteration 5 time: 0.414 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.080 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.063 seconds 
## 
## Iteration 6 time: 0.406 secs.
## 
## Elapsed computation time: 2.403 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.039 seconds 
## 
## Starting values (iteration 1) time: 0.336 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 2 time: 0.413 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 3 time: 0.380 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 4 time: 0.384 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.077 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 5 time: 0.401 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.070 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.060 seconds 
## 
## Iteration 6 time: 0.415 secs.
## 
## Elapsed computation time: 2.339 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.046 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.037 seconds 
## 
## Starting values (iteration 1) time: 0.324 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 2 time: 0.376 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 3 time: 0.380 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.053 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.079 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.066 seconds 
## 
## Iteration 4 time: 0.403 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.075 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 5 time: 0.411 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.071 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 6 time: 0.404 secs.
## 
## Elapsed computation time: 2.304 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.041 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Starting values (iteration 1) time: 0.313 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.061 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.058 seconds 
## 
## Iteration 2 time: 0.397 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.061 seconds 
## 
## Iteration 3 time: 0.397 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.062 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 4 time: 0.368 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.058 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Iteration 5 time: 0.341 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 6 time: 0.393 secs.
## 
## Elapsed computation time: 2.218 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.036 seconds 
## 
## Starting values (iteration 1) time: 0.349 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.045 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 2 time: 0.312 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 3 time: 0.286 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 4 time: 0.289 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.044 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 5 time: 0.288 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.044 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 6 time: 0.288 secs.
## 
## Elapsed computation time: 1.817 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.031 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.030 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.030 seconds 
## 
## Starting values (iteration 1) time: 0.244 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.066 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 2 time: 0.389 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.057 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.058 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 3 time: 0.363 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.067 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.059 seconds 
## 
## Iteration 4 time: 0.405 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.017 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.076 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.059 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.072 seconds 
## 
## Iteration 5 time: 0.410 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.062 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.054 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.065 seconds 
## 
## Iteration 6 time: 0.376 secs.
## 
## Elapsed computation time: 2.198 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.018 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.050 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.055 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.044 seconds 
## 
## Starting values (iteration 1) time: 0.331 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.061 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.048 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.046 seconds 
## 
## Iteration 2 time: 0.355 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.045 seconds 
## 
## Iteration 3 time: 0.372 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.055 seconds 
## 
## Iteration 4 time: 0.377 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.065 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 5 time: 0.389 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.051 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.067 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.057 seconds 
## 
## Iteration 6 time: 0.377 secs.
## 
## Elapsed computation time: 2.208 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Starting values (iteration 1) time: 0.323 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.048 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.041 seconds 
## 
## Iteration 2 time: 0.311 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.043 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.042 seconds 
## 
## Iteration 3 time: 0.285 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.041 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.045 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.045 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 4 time: 0.290 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.046 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 5 time: 0.289 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.042 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.043 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.042 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Iteration 6 time: 0.284 secs.
## 
## Elapsed computation time: 1.788 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.034 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.033 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.033 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.035 seconds 
## 
## Starting values (iteration 1) time: 0.269 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.084 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.074 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.081 seconds 
## 
## Iteration 2 time: 0.477 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.021 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.073 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.078 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.064 seconds 
## 
## Iteration 3 time: 0.433 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.020 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.081 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.075 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 4 time: 0.411 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.090 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 5 time: 0.422 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 6 time: 0.396 secs.
## 
## Elapsed computation time: 2.414 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.052 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.059 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.053 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.038 seconds 
## 
## Starting values (iteration 1) time: 0.338 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.068 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.080 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.063 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.047 seconds 
## 
## Iteration 2 time: 0.409 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.069 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.069 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 3 time: 0.401 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.055 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.076 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.048 seconds 
## 
## Iteration 4 time: 0.385 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.014 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.064 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.072 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.056 seconds 
## 
## Iteration 5 time: 0.386 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.030 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.074 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.070 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.073 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.062 seconds 
## 
## Iteration 6 time: 0.442 secs.
## 
## Elapsed computation time: 2.370 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.056 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.054 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.052 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.043 seconds 
## 
## Starting values (iteration 1) time: 0.373 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.019 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.083 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.066 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.049 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 2 time: 0.449 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.012 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.063 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.091 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.054 seconds 
## 
## Iteration 3 time: 0.392 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.016 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.071 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.072 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.051 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.049 seconds 
## 
## Iteration 4 time: 0.390 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.013 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.065 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.075 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.060 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.050 seconds 
## 
## Iteration 5 time: 0.393 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.015 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.077 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.078 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.050 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.051 seconds 
## 
## Iteration 6 time: 0.404 secs.
## 
## Elapsed computation time: 2.410 secs.
## 
## Elapsed computation time: 7863.166 secs.
```

And beginning the analysis for the summary:

```r
summary(subLogMod)
```

```
## Call:
## rxLogit(formula = y ~ age, data = BankDS, variableSelection = rxStepControl(method = "stepwise", 
##     scope = ~age + job + marital + education + default + housing + 
##         loan + contact + day + month + duration + campaign + 
##         pdays + previous + balance, stepCriterion = "SigLevel"))
## 
## Logistic Regression Results for: y ~ duration + month + contact +
##     job + housing + pdays + campaign + loan + education + previous
##     + marital + day + balance
## Data: BankDS (RxXdfData Data Source)
## File name: data/BankXDF.xdf
## Dependent variable(s): y
## Total independent variables: 45 (Including number dropped: 7)
## Number of valid observations: 45211
## Number of missing observations: 0 
## -2*LogLikelihood: 22730.189 (Residual deviance on 45173 degrees of freedom)
##  
## Coefficients:
##                      Estimate Std. Error z value Pr(>|z|)    
## (Intercept)         -1.70e+00   1.78e-01   -9.58  2.2e-16 ***
## duration             4.15e-03   6.36e-05   65.29  2.2e-16 ***
## month=may           -1.49e+00   1.07e-01  -13.91  2.2e-16 ***
## month=jun           -5.60e-01   1.16e-01   -4.82  1.5e-06 ***
## month=jul           -1.91e+00   1.11e-01  -17.12  2.2e-16 ***
## month=aug           -1.75e+00   1.08e-01  -16.18  2.2e-16 ***
## month=oct           -8.84e-02   1.28e-01   -0.69  0.48946    
## month=nov           -1.93e+00   1.16e-01  -16.67  2.2e-16 ***
## month=dec           -1.56e-01   1.81e-01   -0.86  0.39087    
## month=jan           -2.33e+00   1.45e-01  -16.06  2.2e-16 ***
## month=feb           -1.20e+00   1.14e-01  -10.58  2.2e-16 ***
## month=mar            4.91e-01   1.38e-01    3.55  0.00038 ***
## month=apr           -1.14e+00   1.12e-01  -10.13  2.2e-16 ***
## month=sep             Dropped    Dropped Dropped  Dropped    
## contact=unknown     -1.52e+00   9.77e-02  -15.53  2.2e-16 ***
## contact=cellular     2.01e-01   7.18e-02    2.80  0.00504 ** 
## contact=telephone     Dropped    Dropped Dropped  Dropped    
## job=management      -6.05e-01   1.02e-01   -5.95  2.6e-09 ***
## job=technician      -5.94e-01   9.99e-02   -5.95  2.7e-09 ***
## job=entrepreneur    -8.29e-01   1.44e-01   -5.75  8.8e-09 ***
## job=blue-collar     -7.47e-01   1.04e-01   -7.17  2.2e-16 ***
## job=unknown         -7.21e-01   2.33e-01   -3.09  0.00199 ** 
## job=retired         -1.21e-01   1.12e-01   -1.07  0.28289    
## job=admin.          -4.06e-01   1.03e-01   -3.94  8.2e-05 ***
## job=services        -6.53e-01   1.12e-01   -5.85  5.0e-09 ***
## job=self-employed   -7.14e-01   1.31e-01   -5.45  4.9e-08 ***
## job=unemployed      -5.69e-01   1.30e-01   -4.38  1.2e-05 ***
## job=housemaid       -9.29e-01   1.52e-01   -6.10  1.0e-09 ***
## job=student           Dropped    Dropped Dropped  Dropped    
## housing=yes         -7.77e-01   4.26e-02  -18.25  2.2e-16 ***
## housing=no            Dropped    Dropped Dropped  Dropped    
## pdays                1.33e-03   1.79e-04    7.39  2.2e-16 ***
## campaign            -1.09e-01   1.02e-02  -10.70  2.2e-16 ***
## loan=no              5.04e-01   5.87e-02    8.58  2.2e-16 ***
## loan=yes              Dropped    Dropped Dropped  Dropped    
## education=tertiary   4.44e-01   7.26e-02    6.12  9.3e-10 ***
## education=secondary  2.13e-01   6.28e-02    3.39  0.00071 ***
## education=unknown    2.93e-01   1.01e-01    2.91  0.00362 ** 
## education=primary     Dropped    Dropped Dropped  Dropped    
## previous             5.76e-02   8.00e-03    7.20  2.2e-16 ***
## marital=married     -1.48e-01   5.69e-02   -2.60  0.00933 ** 
## marital=single       1.08e-01   6.12e-02    1.76  0.07828 .  
## marital=divorced      Dropped    Dropped Dropped  Dropped    
## day                  1.06e-02   2.42e-03    4.37  1.2e-05 ***
## balance              1.41e-05   4.87e-06    2.90  0.00375 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Condition number of final variance-covariance matrix: 178.7 
## Number of iterations: 6
```

## Predictions

To finish our discussion on regression, let's lastly mention the rxPrediction function.

What if we want to calculate predictions for our fitted models? Luckily, ScaleR has us covered with the rxPredict function, which basically takes a model object an outputs predicted values and residuals:


```r
rxPredict(modelObject, data = targetDataSet, outData = targetDataFileName, 
          computeResiduals = TRUE)
```

## Conceptual Example: Predictions

For some applications, we may wish to test the effectiveness of our model on a similar data set. One technique is pulling a sub-sample of data from the original data set, constructing a model, and testing the rigidity of that model on the entire data set. The rxPredict function is very useful for this.

## Conceptual Example: Predictions

The model object is simply the name of the model we have defined in our ScaleR command. For instance, our last GLM model we created was named glmMod, and that would be used as the input to the rxPredict command. Other things to keep in mind are:

 - Data should be defined as your target data set, or entire data set if continuing the example above.
 - Computing the residuals allows you to conduct model evaluation, an important topic we will cover in a later module.
 
## Recap

Let's review some of the concepts covered in this module:

 - Is it possible to model too many variables?
 - What is the benefit of excluding a variable from a model?
 - What are the three methods compatible with Stepwise Regression in ScaleR?
