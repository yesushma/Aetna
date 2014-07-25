

infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)



Kmeans2 <- rxKmeans(~ age + day, data = BankDS, numClusters = 3)
Kmeans2




Kmeans2$centers



Kmeans2$withinss


