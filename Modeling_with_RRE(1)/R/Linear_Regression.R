

knit_child("config_knit.R")



## rxLinMod(formula, data, ... )



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile) 
linMod <- rxLinMod(balance~age, data = BankDS)



summary(linMod)



## linMod <- rxLinMod(balance~duration, data = BankDS)



## summary(linMod)
## 



## df <- rxDataStep(inData = BankDS,
##                  rowSelection = as.logical(rbinom(.rxNumRows, 1, .10)) == TRUE)
## rxLinePlot(balance~duration, type = "p", data = df)



df <- rxDataStep(inData = BankDS, 
                 rowSelection = as.logical(rbinom(.rxNumRows, 1, .10)) == TRUE)
rxLinePlot(balance~duration, type = "p", data = df)



## rxLinMod(y ~ x1 + x2 + x3 + ..., data, ... )



multiLinMod <- rxLinMod(balance ~ age + duration + marital + housing, 
                        data = BankDS)



## summary(multiLinMod)



##     rxLinMod(y ~ x + I(x^2) + I(x^3) + ..., data)



highMod <- rxLinMod(balance ~ age + I(age^2), data = BankDS)



summary(highMod)


