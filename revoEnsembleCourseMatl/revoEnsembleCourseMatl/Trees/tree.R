rm(list=ls())
require(rpart)
setwd("C:\\Documents and Settings\\Administrator\\My Documents\\MLClasses\\revoClasses\\Ensemble\\revoEnsembleCourseMatl\\data")

#Trees 1 - Training a Regression Tree
set.seed(531)

#A Simple Problem
x <- seq(1,10,.1)
y <- x + 2.0*rnorm(length(x))
dataSet <- as.data.frame(cbind(x,y))

#plot the data to see how these are related
plot(x,y, pch=".")

#build a decision tree
rcontrol <- rpart.control(minsplit=10, cp=0.00,
                          maxdepth=1)
tree1 <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(tree1,compress=TRUE, uniform=TRUE)
text(tree1, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,y, pch=".")

#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)

#make the column names match
dimnames(xIn)[[2]]='x'

#add the predictions to the graph
lines(x,predict(tree1,xIn))

#Suppose we divide at x < ?
#sum square error in child nodes

testSplits <- function(testVal, xx, yy){
   iDiv <- which(xx<testVal)
   sumSqError <- var(yy[iDiv])*length(iDiv) + var(yy[-iDiv])*(length(yy)-length(iDiv))
   return(sumSqError)
}

testSplits(3.4, x, y)

#Trees 2 - more complicated trees
######################################################
#

#add more levels
rcontrol <- rpart.control(minsplit=10, cp=0.00,
                          maxdepth=2)
tree2 <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(tree2,compress=TRUE)
text(tree2, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,y, pch=".")

#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)

#make the column names match
dimnames(xIn)[[2]]='x'

lines(x,predict(tree2,xIn))


#Trees 3 - Overfitting and regularizing a tree
##################################################################
#
set.seed(531)

#A Simple Problem
x <- seq(1,10, 0.1)
y <- x + 2.0*rnorm(length(x))
dataSet <- as.data.frame(cbind(x,y))

#plot the data to see how these are related
plot(x,y, pch=".")

#dial up the depth parameter to get over-fitting
rcontrol <- rpart.control(minsplit=3, cp=0.00,
                          maxdepth=4)
tree3 <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(tree3,compress=TRUE)
text(tree3, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,y, pch=".")

#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)

#make the column names match
dimnames(xIn)[[2]]='x'

lines(x,predict(tree3,xIn))


#look at the following parameters to control 
#overfitting and complexity
# depth, cp, minsplit


#you've seen how depth can control over-fit.  

#minsplit
#######################################################
#minsplit - smallest number of points that will be split
#

rcontrol <- rpart.control(minsplit=5, cp=0.00,maxdepth=10)
treeSplit <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(treeSplit,compress=TRUE)
text(treeSplit, use.n=TRUE,xpd=TRUE)

plot(x,y, pch=".")#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)#make the column names match
dimnames(xIn)[[2]]='x'

lines(x,predict(treeSplit,xIn))

#cp
###################################################################
#cp is the smallest improvement in fit
#sum squared error of child nodes versus sum squared error of parent
#

rcontrol <- rpart.control(minsplit=3, cp=0.00,maxdepth=10)
treeCP <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(treeCP,compress=TRUE)
text(treeCP, use.n=TRUE,xpd=TRUE)

plot(x,y, pch=".")#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)#make the column names match
dimnames(xIn)[[2]]='x'

lines(x,predict(treeCP,xIn))


#Trees 4 - multidimensional problem 
##########################################################
#concrete data set
#http://archive.ics.uci.edu/ml/machine-learning-databases/concrete/compressive/Concrete_Readme.txt
#

concrete <- read.table(file="Concrete_Data.csv",
                       header=TRUE, sep=",")

#define holdout set
nsamp <- as.integer(0.30*nrow(concrete))
iOut <- sample(1:nrow(concrete),nsamp )

conTrain <- concrete[-iOut,]
conTest <- concrete[iOut,]

rcontrol <- rpart.control(minsplit=4, cp=0.00, maxdepth=10)
treeConcrete <- rpart(compressiveStrength~.,data=conTrain,control = rcontrol)

#here's what the tree looks like
#plot(treeConcrete,compress=TRUE)
#text(treeConcrete, use.n=TRUE,xpd=TRUE)

mse <-mean((conTest$compressiveStrength - predict(treeConcrete, conTest))**2)
sqrt(mse)

#Try running through these same steps with the following file
wineQ <- read.table(file="http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", header=TRUE, sep=";")
str(wineQ)


#Trees 5. Using Trees for Classification Problems
###############################################
#modify simple problem
set.seed(531)

#A Simple Problem
x <- seq(1,10,.1)
y <- (x + 2.0*rnorm(length(x))) > 5.5
y <- as.factor(y)
dataSet <- as.data.frame(cbind(x,y))
dataSet[,2] <- y

#plot the data to see how these are related
plot(x,y, pch=".")

rcontrol <- rpart.control(minsplit=10, cp=0.00,
                          maxdepth=1)
dTree <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(dTree,compress=TRUE)
text(dTree, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,as.numeric(y)-1, pch=".")

#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)

#make the column names match
dimnames(xIn)[[2]]='x'

#plot the predictions on a separate graph
lines(x,predict(dTree,xIn)[,2], pch=".")

#Suppose we divide at x < ?
#sum square error in child nodes

testSplitsD <- function(testVal, xx, yy){
  iDiv <- which(xx<testVal)
  misClassErr <- sum(TRUE == as.logical(yy[iDiv])) + sum(FALSE == as.logical(yy[-iDiv]))
  return(misClassErr/length(yy))
}

testSplitsD(6.5, x, y)

#Add another split
rcontrol <- rpart.control(minsplit=3, cp=0.00,
                          maxdepth=3)

dTree2 <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(dTree2,compress=TRUE)
text(dTree2, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,as.numeric(y)-1, pch=".")

#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)

#make the column names match
dimnames(xIn)[[2]]='x'

#plot the predictions on a separate graph
lines(x,predict(dTree2,xIn)[,2], pch=".")

#Use Sonar to Distinguish Unexploded Mines from Rocks
########################################################

rockMine <- read.table(file="RvM.csv", header=FALSE, sep=",")
nsamp <- as.integer(0.30*nrow(rockMine))
iOut <- sample(1:nrow(rockMine),nsamp )

rmTrain <- rockMine[-iOut,]
rmTest <- rockMine[iOut,]

rcontrol <- rpart.control(minsplit=5, cp=0.0, maxdepth=12)
treeRM <- rpart(V61~.,data=rmTrain,control = rcontrol)

#here's what the tree looks like
plot(treeRM,compress=TRUE, uniform=TRUE)
text(treeRM, use.n=TRUE,xpd=TRUE)

#str(predict(treeRM, rmTest))

idxM <- which(predict(treeRM, rmTest)[,1] == 1)
pred <- rep("R", length(rmTest$V61))
pred[idxM] <- "M"

error <-sum(rmTest$V61 != pred)
error/length(rmTest$V61)


#Trees 6. Using Revolution Analytics rxDTree on Big Data
##########################################################
require(rpart)
wineQ <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", sep=";", header=TRUE)
str(wineQ)


wineFormula <-  "quality ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide +       density + pH + sulphates + alcohol" 


wineTree <- rxDTree(wineFormula , seed = 10, data = wineQ, cp=0.01, maxDepth=3)

plotcp(rxAddInheritance(wineTree))
printcp(rxAddInheritance(wineTree))
summary(wineTree)
require(RevoTreeView)
plot(createTreeView(wineTree))

#Some other data sets to try
##################################################

#Predicting the Age of Abalone - 
#####################################################

abalone <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=FALSE, sep=",")
dimnames(abalone)[[2]] <- c("Sex", "Length", "Diameter", "Height", "Whole_weight", "Shucked_weight", "Viscera_weight", "Shell_weight", "Rings")

abaloneFormula <- "Rings ~ Sex + Length + Diameter + Height + Whole_weight + Shucked_weight + Viscera_weight + Shell_weight"
	

	
#Detecting Unexploded Mines Data Set	
######################################################

rocksMinesData <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/undocumented/connectionist-bench/sonar/sonar.all-data", header=FALSE, sep=",")

RvMFormula <- "V61 ~  V1 + V2 + V3 + V4 + V5 + V6 + V7 + V8 + V9 + V10 + V11 + V12 + V13 + V14 + V15 + V16 + V17 + V18 + V19 + V20 + V21 + V22 + V23 + V24 + V25 + V26 + V27 + V28 + V29 + V30 + V31 + V32 + V33 + V34 + V35 + V36 + V37 + V38 + V39 + V40 + V41 + V42 + V43 + V44 + V45 + V46 + V47 + V48 + V49 + V50 + V51 + V52 + V53 + V54 + V55 + V56 + V57 + V58 + V59 + V60"


#Predict the area burned in a forest fire
#####################################################

forestFires <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/forest-fires/forestfires.csv", header=TRUE, sep=",")

forestFiresFormula <- "area ~ X + Y + month + day + FFMC + DMC + DC + ISI + temp + RH + wind + rain" 


#Detecting Parkinson's Disease from voice data
#####################################################

parkinsonData <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/parkinsons/parkinsons.data", header=TRUE, sep=",")

pdFormula <- "status ~ name + MDVP.Fo.Hz. + MDVP.Fhi.Hz. + MDVP.Flo.Hz. + MDVP.Jitter... + MDVP.Jitter.Abs. + MDVP.RAP + MDVP.PPQ + Jitter.DDP + MDVP.Shimmer + MDVP.Shimmer.dB. + Shimmer.APQ3 + Shimmer.APQ5 + MDVP.APQ + Shimmer.DDA + NHR +  HNR + RPDE + DFA + spread1 + spread2 + D2 + PPE" 
