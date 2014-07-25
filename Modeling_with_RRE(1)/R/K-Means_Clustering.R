

knit_child("config_knit.R")



## rxKmeans(formula, data, numClusters, ... )



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)


Kmeans <- rxKmeans(~ duration + balance, data = BankDS, numClusters = 3)



Kmeans



## SS <- rep(NA, 20)
## for (i in 2:20) SS[i] <- rxKmeans(~ duration + balance, data = BankDS, numClusters =  i)$tot.withinss
## plot(1:20, SS, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")



SS <- rep(NA, 20)
for (i in 2:20) SS[i] <- rxKmeans(~ duration + balance, data = BankDS, numClusters =  i)$tot.withinss
plot(1:20, SS, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")


