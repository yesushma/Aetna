---
title: 'Modeling in  Revolution R Enterprise \newline Module 3: Logistic Regression'
fontsize: '10pt'
author: 'Revolution Analytics'
header-icons: 
  - "REV_Icon_Consulting_RGB"
  - "REV_Icon_TrainingServices_RGB"
toc: TRUE
---





## Logistic Regression

Continuing on from our last module, let's extend our discussion about regression. There are actually several different types of regression models, each based on different characteristics in observed data.

Logistic regression applies to binary response variables - that is, terms that assume only two values. Some example binary variables are:

- Positive/Negative account balance (as in our Bank data)
 - Under 18/Over 18 years of age (applicable to some concert venues)
 - Good/Bad song review (applicable to ratings)
 - Alive/Deceased subjects (applicable to Survival Analysis)

as well as many, many other applications...

## Logistic Regression

Binary response variables can be modeled using Logistic Regression:
\begin{center}
$\dfrac{F(x)}{1 - F(x)}$ = $ e^{\beta_0 + \beta_1x_1 + \beta_2x_2 + \cdots + \beta_mx_m}$
\end{center}
Where the above regression assumes multiple predictors and the function $F(t) = \dfrac{1}{1 + e^{-t}}$ is referred to as the logistic function, and $t$ is a linear function to the explanatory variable $x$ or a linear combination of explanatory variables. 

## Logistic Regression

Let's consider the previous equation in a little more detail, first by talking about the Logistic Function:
\begin{align*}
F(t) = \dfrac{1}{1 + e^{-t}}
\end{align*}

The variable $t$ represents a linear function, just like models we constructed in the last module:
\begin{align*}
t = \beta_0 + \beta_1x
\end{align*}

where $x$ is the variable we are modeling. 

## Logistic Regression

If we are dealing with multiple predictor variables we would like to model, then our equation for $t$ changes to a linear combination of those predictor variables. Mathematically, for $m$-predictor variables, the equation for $t$ becomes:
\begin{align*}
t &= \beta_0 + \beta_1x_1 + \beta_2x_2 + \cdots + \beta_mx_m
\end{align*}

We are already familiar with both of these models from the previous module! Essentially, Logistic Regression wraps these fundamental models around some additional theory which we will consider briefly.

## Logistic Regression

Euler's number is a common constant, $2.71828\ldots$ that turns up a lot in math.

For instance, it is very important in: 

- calculating interest on a loan 
- some forms of population growth such as for certain bacteria
- other examples involving increases on an exponential scale.

## Logistic Regression

Alternately, the Natural Logarithm acts as the opposite to using Euler's number as the base of an exponent. In R, the standard log function actually is taking the natural log of a value, simply because of its vast use in both application and theory (much more so than the base 10 log) and because it is easy to convert logarithmic bases using laws of logarithms. Models involving the natural logarithm include:

 - decaying population, perhaps for a bacteria that is exposed to pesticide
 - carbon dating, a process referring to the decaying of half-life of Carbon atoms in an object
 - other such problems involving a reducing sample
 
## Logistic Regression

In Logistic Regression, the exponential term is used to model a binary response variable. Let's consider a supposed variable $x$ as having a response equal to either $0$ or $1$. Statistically, our model should predict $x$ as falling between one of these extreme values - for instance, perhaps a higher proportion of Carbon atoms in some object should have decayed over a certain period of time, so we would model the question of whether a given Carbon atom in that object would have decayed as closer to 1, but not a definite 1 (indicating that all of the Carbon atoms have decayed).

Modeling $t$ with a linear response variable, we get the following plot for our Logistic Function:

```r
x = -10:10;
y = 1/(1+exp(-x))
plot(x,y, type = "l", col="red")
```

## Logistic Regression

![](Plots/Logistic.png)

## Logistic Regression

Of course, we can see that the distributional proportion will depend on the linear modeling of $t$, but in the previous plot one may see the characteristic S-shape of the logistic curve. This shows values falling between minimum and maximum values 0 and 1, respectfully, while asymptotically approaching these values. Predictions based on the above model would strictly follow the line.

## Logistic Regression

The rxLogit function fits a logistic regression model to data by specifying a formula and a root data set:


```r
rxLogit(formula, data, ... )
```

## Example: Logistic Regression

In our Bank data set, notice that the default variable has a binary response of either yes or no. Therefore, to model this variable it makes sense to use logistic regression.

Let's predict default based on age and balance:


```r
infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile) 
logitMod <- rxLogit(default ~ age + balance, data = BankDS)
```

```
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.002 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.003 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Starting values (iteration 1) time: 0.027 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.004 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Iteration 2 time: 0.033 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.002 seconds
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation.
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.003 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Iteration 3 time: 0.025 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.004 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Iteration 4 time: 0.025 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.002 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.003 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.002 seconds 
## 
## Iteration 5 time: 0.020 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.003 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Iteration 6 time: 0.024 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.002 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.002 seconds
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation. (similar message repeated 64 times)
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Iteration 7 time: 0.024 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.003 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.003 seconds 
## 
## Iteration 8 time: 0.024 secs.
## 
## Elapsed computation time: 0.204 secs.
## 
## 
##  Warning: One or more fitted probabilities were numerically 0 or 1 during estimation. (similar message repeated 21 times)
```

## Example: Logistic Regression

The RRE output for Logistic Regression is a little different from the linear regression output of the prior module. 


```r
summary(logitMod)
```

```
## Call:
## rxLogit(formula = default ~ age + balance, data = BankDS)
## 
## Logistic Regression Results for: default ~ age + balance
## Data: BankDS (RxXdfData Data Source)
## File name: data/BankXDF.xdf
## Dependent variable(s): default
## Total independent variables: 3 
## Number of valid observations: 45211
## Number of missing observations: 0 
## -2*LogLikelihood: 6846.295 (Residual deviance on 45208 degrees of freedom)
##  
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -3.082651   0.153379  -20.10  2.2e-16 ***
## age         -0.008391   0.003785   -2.22    0.027 *  
## balance     -0.002266   0.000079  -28.70  2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Condition number of final variance-covariance matrix: 1.094 
## Number of iterations: 8
```

Apart from the usual terms is the log-likelihood ratio statistic, testing the fit between the null model and the alternative model. Essentially, this value is used to compute a p-value concerning the relevancy of the model.

From the above coefficients, we can reconstruct the logistic model.

## Example: Logistic Regression

Mathematically, the model reconstructed to two decimal places is:
\begin{align*}
\dfrac{F(x)}{1-F(x)} = e^{-3.08 - 0.008391 \cdot age - 0.00227 \cdot balance}
\end{align*}

Perhaps the interpretation of a logistic model is a little less apparent than it was with linear regression. In this case, exponentiating the coefficients and interpreting them as odds-ratios should make much more sense.

## Example: Odds-Ratio

Computing the Odds-Ratios:

```r
## Age
exp(-8.391e-03)

## Balance
exp(-2.266e-03)
```

Interpreting the results for individuals in our Bank data,

 - Given a one unit increase in age (equivalent to an additional year), the odds of having credit in default (versus not having credit in default) decreases by a factor of approximately 0.9916.
 
 - Given a one unit increase in balance (equivalent to having one additional Euro), the odds of having credit in default (versus not having credit in default) decreases by a factor of approximately 0.9977.
 
## Exercise: Logistic Regression

For this exercise, we will pull on all of the information we have learned so far in this module. Let's construct a model that indicates the success of the Portuguese banking institution's success with its marketing campaign.

## Exercise: Logistic Regression

 - Use logistic regression to model whether or not a client subscribed to a term deposit (i.e. the variable y in the Bank data set), given information on the client's age, balance, housing, and marital status.
 - After constructing the model, interpret your results using odds-ratios for each variable coefficient.
 
## Exercise: Solution

First, using ScaleR to construct the logistic regression using the Bank data source:

```r
logitMod <- rxLogit(y ~ age + balance + housing + marital, data = BankDS)
```

```
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.004 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.005 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Starting values (iteration 1) time: 0.041 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 2 time: 0.050 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.002 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.005 seconds 
## 
## Iteration 3 time: 0.038 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.002 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.006 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.005 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.006 seconds 
## 
## Iteration 4 time: 0.039 secs.
## Rows Read: 10000, Total Rows Processed: 10000, Total Chunk Time: 0.003 seconds
## Rows Read: 10000, Total Rows Processed: 20000, Total Chunk Time: 0.005 seconds
## Rows Read: 10000, Total Rows Processed: 30000, Total Chunk Time: 0.007 seconds
## Rows Read: 10000, Total Rows Processed: 40000, Total Chunk Time: 0.006 seconds
## Rows Read: 5211, Total Rows Processed: 45211, Total Chunk Time: 0.007 seconds 
## 
## Iteration 5 time: 0.041 secs.
## 
## Elapsed computation time: 0.212 secs.
```

Analyze the summary using the summary function:

```r
summary(logitMod)
```

```
## Call:
## rxLogit(formula = y ~ age + balance + housing + marital, data = BankDS)
## 
## Logistic Regression Results for: y ~ age + balance + housing +
##     marital
## Data: BankDS (RxXdfData Data Source)
## File name: data/BankXDF.xdf
## Dependent variable(s): y
## Total independent variables: 8 (Including number dropped: 2)
## Number of valid observations: 45211
## Number of missing observations: 0 
## -2*LogLikelihood: 31478.548 (Residual deviance on 45205 degrees of freedom)
##  
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      -2.05e+00   8.70e-02  -23.60  2.2e-16 ***
## age               8.70e-03   1.53e-03    5.68  1.3e-08 ***
## balance           3.15e-05   3.93e-06    8.03  2.2e-16 ***
## housing=yes      -8.25e-01   3.10e-02  -26.63  2.2e-16 ***
## housing=no         Dropped    Dropped Dropped  Dropped    
## marital=married  -1.76e-01   4.79e-02   -3.68  0.00024 ***
## marital=single    3.60e-01   5.40e-02    6.67  2.6e-11 ***
## marital=divorced   Dropped    Dropped Dropped  Dropped    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Condition number of final variance-covariance matrix: 13.98 
## Number of iterations: 5
```

## Exercise: Solution


```r
df <- as.data.frame(logitMod$coefficients)
df[2] <- exp(df[1])
names(df)<- c("coeff","oddsRatio")
df
```

```
##                       coeff oddsRatio
## (Intercept)      -2.052e+00    0.1284
## age               8.701e-03    1.0087
## balance           3.153e-05    1.0000
## housing=yes      -8.250e-01    0.4382
## housing=no               NA        NA
## marital=married  -1.761e-01    0.8385
## marital=single    3.601e-01    1.4334
## marital=divorced         NA        NA
```

## Exercise: Solution

All of the variables listed above were determined to be highly significant. Accordingly, our variable interpretations are listed as follows:

 - For age, given a one year increase, the odds of the client subscribing to a term deposit (versus not subscribing) increases by a factor of approximately 1.008739.
 - For balance, given a one euro increase, the odds of the client subscribing to a term deposit (versus not subscribing) increases by a factor of approximately 1.000032.
 - Given yes on housing, the odds of the client subscribing to a term deposit (versus not subscribing) decreases by a factor of approximately 0.4382246.
 - Given being married, the odds of the client subscribing to a term deposit (versus not subscribing) decreases by a factor of approximately 0.8385092.
 - Given being single, the odds of the client subscribing to a term deposit (versus not subscribing) increases by a factor of approximately 1.4334046.
 
## Recap

Let's review some of the concepts covered in this module:

 - How does logistic regression differ from linear regression?
    * In what ways is it similar?
 - What is a binary response variable?
    * Can you come up with an example?
 - How do you interpret an odds-ratio?
