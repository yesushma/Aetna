rm(list=ls())
require(randomForest)
require(rpart)
setwd("C:\\Documents and Settings\\Administrator\\My Documents\\MLClasses\\revoClasses\\Ensemble\\revoEnsembleCourseMatl\\data")



#Random Forests 1.

#To demo Random Forest we'll need a multidimensional problem
concreteData <- read.table(file="Concrete_Data.csv", header=TRUE, sep=",")

ensembleRF <- rep(0.0,nrow(concreteData))
nFrac <- 0.5
nSamp <- as.integer(nFrac*(ncol(concreteData)-1))
iTrees <- 0
rcontrol <- rpart.control(minsplit=3, cp=0.00,
                          maxdepth=6)


#Begin iteration
iTrees <- iTrees + 1
idx <- sample(1:(ncol(concreteData)-1),nSamp)
idx2 <- c(idx,ncol(concreteData))
dfTemp <- concreteData[,idx2]

treeRF <- rpart(compressiveStrength~.,data=dfTemp,control = rcontrol)
xIn <- concreteData[,idx]


ensembleRF <- ensembleRF + predict(treeRF,xIn)
#End iteration

iTrees
residual <- concreteData$compressiveStrength - ensembleRF/iTrees
plot(residual)
mean(abs(residual))


#Random Forest Package - Random Forest 2. 
#From Package Documentation
iris.rf <- randomForest(Species ~ ., data=iris, importance=TRUE,
                        proximity=TRUE)
print(iris.rf)
## Look at variable importance:
round(importance(iris.rf), 2)
## Do MDS on 1 - proximity:
iris.mds <- cmdscale(1 - iris.rf$proximity, eig=TRUE)
op <- par(pty="s")
pairs(cbind(iris[,1:4], iris.mds$points), cex=0.6, gap=0,
      col=c("red", "green", "blue")[as.numeric(iris$Species)],
      main="Iris Data: Predictors and MDS of Proximity Based on RandomForest")
par(op)
print(iris.mds$GOF)


set.seed(17)
iris.urf <- randomForest(iris[, -5])
MDSplot(iris.urf, iris$Species)

## data(airquality)
set.seed(131)
ozone.rf <- randomForest(Ozone ~ ., data=airquality, mtry=4,
                         importance=TRUE, na.action=na.omit)
print(ozone.rf)

#What about our concrete problem?
concreteRF <- randomForest(compressiveStrength~., data=concreteData,
                           mtry=3,
                           importance=TRUE,
                           maxnodes=8)

print(concreteRF)


#Random Forest on big data - Section 3.
rm(list=ls())

wineQ <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", sep=";", header=TRUE)
str(wineQ)

wineFormula <-  "quality ~ fixed.acidity + volatile.acidity + citric.acid +
       residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + 
      density + pH + sulphates + alcohol" 


wineForest <- rxDForest(wineFormula , seed = 10, data = wineQ, cp=0.01, nTree=500, mTry=3)

plot(wineForest)
summary(wineForest)


#Some other data sets to try

#Predicting the Age of Abalone - 
#####################################################

abalone <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=FALSE, sep=",")
dimnames(abalone)[[2]] <- c("Sex", "Length", "Diameter", "Height", "Whole_weight", "Shucked_weight", "Viscera_weight", "Shell_weight", "Rings")

abaloneFormula <- "Rings ~ Sex + Length + Diameter + Height + Whole_weight + Shucked_weight + Viscera_weight + Shell_weight"
	

	
#Detecting Unexploded Mines Data Set	
######################################################

rocksMinesData <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/undocumented/connectionist-bench/sonar/sonar.all-data", header=FALSE, sep=",")

RvMFormula <- "V61 ~  V1 + V2 + V3 + V4 + V5 + V6 + V7 + V8 + V9 + V10 + V11 + V12 + V13 + V14 + V15 + V16 + V17 + V18 + V19 + V20 + V21 + V22 + V23 + V24 + V25 + V26 + V27 + V28 + V29 + V30 + V31 + V32 + V33 + V34 + V35 + V36 + V37 + V38 + V39 +
V40 + V41 + V42 + V43 + V44 + V45 + V46 + V47 + V48 + V49 + V50 + V51 + V52 + V53 + V54 + V55 + V56 + V57 + V58 + V59 + V60"


#Predict the area burned in a forest fire
#####################################################

forestFires <- read.table("http//archive.ics.uci.edu/ml/machine-learning-databases/forest-fires/forestfires.csv", header=TRUE, sep=",")

forestFiresFormula <- "area ~ X + Y + month + day + FFMC + DMC + DC + ISI + temp + RH + wind + rain" 



#Detecting Parkinson's Disease from voice data
#####################################################

parkinsonData <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/parkinsons/parkinsons.data", header=TRUE, sep=",")

pdFormula <- "status ~ name + MDVP.Fo.Hz. + MDVP.Fhi.Hz. + MDVP.Flo.Hz. + MDVP.Jitter... + MDVP.Jitter.Abs. + MDVP.RAP + MDVP.PPQ + Jitter.DDP + MDVP.Shimmer + MDVP.Shimmer.dB. + Shimmer.APQ3 + Shimmer.APQ5 + MDVP.APQ + Shimmer.DDA + NHR +  HNR + RPDE + DFA + spread1 + spread2 + D2 + PPE" 