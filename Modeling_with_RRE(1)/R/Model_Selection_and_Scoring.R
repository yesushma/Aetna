

knit_child("config_knit.R")



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)

outfile <- file.path("data", "BankSub.xdf") 

BankSubDS <- rxDataStep(inData = BankDS, outFile = outfile,
                    varsToKeep = c("balance", "age"),
                    transforms = list( newBalance = balance + 8019 + 1,
                                       logBalance = log(newBalance)), 
                    overwrite = TRUE)



## rxLinePlot(balance ~ age, type = "p", data = BankSubDS)
## rxLinePlot(logBalance ~ age, type = "p", data = BankSubDS)



BankSubDS <- rxDataStep(inData = BankSubDS, outFile=BankSubDS,
                    transforms = list(logBalance = ifelse(logBalance < 8, NA, logBalance)),
                    overwrite = TRUE)

BankSubDS <- rxDataStep(inData = BankSubDS, outFile=BankSubDS,
                        rowSelection = !is.na(logBalance), overwrite = TRUE)



rxLinePlot(logBalance ~ age, type = "p", data = BankSubDS)



linMod <- rxLinMod(logBalance~age, data = BankSubDS)
linResult <- rxPredict(linMod, data = BankSubDS, computeResiduals = TRUE)



rxGetVarInfo(linResult)



linMod <- rxLinMod(logBalance~age + I(age^2), data = BankSubDS, covCoef = TRUE)



predResult <- rxPredict(linMod, data=BankSubDS, computeStdErrors=TRUE, interval="confidence", writeModelVars = TRUE, overwrite=TRUE)

summary(predResult)



## rxLinePlot(logBalance + logBalance_Pred + logBalance_Upper + logBalance_Lower ~ age,
##     data = predResult, type = "b",
##     lineStyle = c("blank", "solid", "dotted", "dotted"),
##     lineColor = c(NA, "red", "black", "black"),
##     symbolStyle = c("solid circle", "blank", "blank", "blank"),
##     title = "Data, Predictions, and Confidence Bounds",
##     xTitle = "Increase in Log(age)",
##     yTitle = "Increse in Log(balance)", legend = FALSE)



linMod <- rxLinMod(balance~duration + I(duration^2), data = BankDS, covCoef = TRUE)



predResult <- rxPredict(linMod, data=BankDS, computeStdErrors=TRUE, 
                        interval="confidence", writeModelVars = TRUE, 
                        overwrite=TRUE)



## rxLinePlot(balance + balance_Pred + balance_Upper + balance_Lower ~ duration,
##     data = predResult, type = "b",
##     lineStyle = c("blank", "solid", "dotted", "dotted"),
##     lineColor = c(NA, "red", "black", "black"),
##     symbolStyle = c("solid circle", "blank", "blank", "blank"),
##     title = "Data, Predictions, and Confidence Bounds",
##     xTitle = "Increase in duration",
##     yTitle = "Increse in balance", legend = FALSE)



rxLinePlot(balance + balance_Pred + balance_Upper + balance_Lower ~ duration,
    data = predResult, type = "b",
    lineStyle = c("blank", "solid", "dotted", "dotted"),
    lineColor = c(NA, "red", "black", "black"),
    symbolStyle = c("solid circle", "blank", "blank", "blank"),
    title = "Data, Predictions, and Confidence Bounds",
    xTitle = "Increase in duration",
    yTitle = "Increse in balance", legend = FALSE)


