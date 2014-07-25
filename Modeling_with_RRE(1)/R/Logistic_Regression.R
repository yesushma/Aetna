

knit_child("config_knit.R")



## x = -10:10;
## y = 1/(1+exp(-x))
## plot(x,y, type = "l", col="red")



## rxLogit(formula, data, ... )



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile) 
logitMod <- rxLogit(default ~ age + balance, data = BankDS)



summary(logitMod)



## ## Age
## exp(-8.391e-03)
## 
## ## Balance
## exp(-2.266e-03)



logitMod <- rxLogit(y ~ age + balance + housing + marital, data = BankDS)



summary(logitMod)



df <- as.data.frame(logitMod$coefficients)
df[2] <- exp(df[1])
names(df)<- c("coeff","oddsRatio")
df


