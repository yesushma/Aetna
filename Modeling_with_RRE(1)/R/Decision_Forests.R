

knit_child("config_knit.R")



## rxDForest(formula, data, nTree, mTry, ... )



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)

Forest <- rxDForest(housing ~ balance + age, data = BankDS, 
                    seed = 10, cp = 0.01, nTree = 500, mTry = 2,
                    overwrite = TRUE)



Forest



Forest2 <- rxDForest(y ~ duration + age, data = BankDS, 
                     seed = 10, cp = 0.01, nTree = 500, mTry = 2,
                     overwrite=TRUE)
Forest2


