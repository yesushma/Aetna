

# infile <- file.path("data", "bank-full.csv") 
# BankDS <- RxTextData(file = infile) 

infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile) 



rxGetInfo(BankDS, getVarInfo=TRUE, numRows=6)
rxSummary(~., BankDS)


