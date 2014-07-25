

knit_child("config_knit.R")



## rxDTree(formula, data, ... )



## infile <- file.path("data", "BankXDF.xdf")
## BankDS <- RxXdfData(file = infile)
## 
## Tree <- rxDTree(housing ~ age + balance, data = BankDS, cp = 0.01)



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)

Tree <- rxDTree(housing ~ age + balance, data = BankDS, cp = 0.01)
Tree



## library(RevoTreeView)
## plot(createTreeView(Tree))



## Tree2 <- rxDTree(y ~ age + duration, data = BankDS, cp = 0.01)



Tree2 <- rxDTree(y ~ age + duration, data = BankDS, cp = 0.01)



## plot(createTreeView(Tree2))


