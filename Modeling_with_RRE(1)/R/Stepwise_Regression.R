

knit_child("config_knit.R")



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



summary(subLinMod)



summary(subLinMod)$balance$coefficients[4:14,]



summary(subLinMod)$balance$coefficients[26:27,]



summary(subLinMod)$balance$r.squared



subLogMod <- rxLogit(y ~ age, data = BankDS, 
                     variableSelection = rxStepControl( 
                       method = "stepwise", 
                        scope = ~ age + job + marital + education + default +
                          housing + loan + contact + day + month + 
                          duration + campaign + pdays + previous + balance,
                       stepCriterion = "SigLevel"))



summary(subLogMod)



## rxPredict(modelObject, data = targetDataSet, outData = targetDataFileName,
##           computeResiduals = TRUE)


