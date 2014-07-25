rm(list=ls())
require(rpart)

#Here are some ways to generate a lot of tree models.  
#Start where we left off last time.  
set.seed(531)

#our old friend
x <- seq(1,10,.1)
y <- x + 2.0*rnorm(length(x))
dataSet <- as.data.frame(cbind(x,y))

plot(x,y, pch=".")

rcontrol <- rpart.control(minsplit=10, cp=0.00,
                          maxdepth=1)
tree1 <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(tree1,compress=TRUE)
text(tree1, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,y, pch=".")
#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)
#make the column names match
dimnames(xIn)[[2]]='x'

lines(x,predict(tree1,xIn))


#Bagging - Train a multitude of tree
#each tree on slightly different input data

nsamp <- as.integer(0.5*nrow(dataSet))
modelList <- list(NULL)
rcontrol <- rpart.control(minsplit=10, cp=0.00,
                          maxdepth=1)
iList <- 0

#begin iteration
iList <- iList + 1
idxSamp <- sample((1:nrow(dataSet)),nsamp)
dataSamp <- dataSet[idxSamp,]

tree2<- rpart(y~x,data=dataSamp,control = rcontrol)

#Keep the models
modelList[[iList]] <- tree2

#End Iteration


#Let's see what it looks like
plot(x,y, pch=".")
xIn <- as.data.frame(x)
dimnames(xIn)[[2]]='x'
lines(x,predict(tree1,xIn))

nModels <- length(modelList)
xIn <- as.data.frame(x)
#make the column names match
dimnames(xIn)[[2]]='x'

ensemble <- rep(0.0,nrow(xIn))

for(i in 1:nModels){
  ensemble <- ensemble + predict(modelList[[i]],xIn)/nModels
}

lines(x,ensemble)



#Here's another technique for systematically generating
#and combining a large number of trees.  
#Gradient Boosting.  Start over

set.seed(531)

#our old friend
x <- seq(1,10,.1)
y <- x + 2.0*rnorm(length(x))
dataSet <- as.data.frame(cbind(x,y))

plot(x,y, pch=".")

rcontrol <- rpart.control(minsplit=10, cp=0.00,
                          maxdepth=1)
tree1 <- rpart(y~x,data=dataSet,control = rcontrol)

#here's what the tree looks like
plot(tree1,compress=TRUE)
text(tree1, use.n=TRUE,xpd=TRUE)

#here's what the approximation looks like
plot(x,y, pch=".")
#rpart wants a dataframe as input to predict function
xIn <- as.data.frame(x)
#make the column names match
dimnames(xIn)[[2]]='x'

lines(x,predict(tree1,xIn))

ensembleGB <- rep(0.0,nrow(xIn))
residual <- y
eps <- 0.1
iTrees <- 0


#Begin Iteration
iTrees <- iTrees + 1
df <- as.data.frame(cbind(xIn,residual))
dimnames(df)[[2]] <- c("x","y")
treeGB <- rpart(y~x,data=df,control = rcontrol)

ensembleGB <- ensembleGB + eps*predict(treeGB,xIn)
residual <- y - ensembleGB
#end Iteration

plot(cbind(xIn,residual))


plot(x,y, pch=".")
lines(cbind(xIn,ensembleGB))

#Try these on the concrete data set that we looked at last class


#let's try this with 
require(gbm)

concreteData <- read.table(file="C:\\Documents and Settings\\Administrator\\My Documents\\Downloads\\Concrete_Data-1.csv", 
                           header=TRUE,sep=",")

str(concreteData)
require(gbm)

concreteModel <- gbm(strength~., 
                     distribution="gaussian",
                     data=concreteData, 
                     n.trees = 3000,
                     interaction.depth=3,
                     cv.folds=10,
                     shrinkage=.003)




min(sqrt(concreteModel$cv.error))

par(mfrow=c(2,2))
gbm.perf(concreteModel,method="cv")
summary(concreteModel)

plot(concreteModel, i.var=4)
plot(concreteModel, i.var=7)




#Try on some other problems.  
######################################################

require(rpart)
wineQ <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", sep=";", header=TRUE)
str(wineQ)


wineFormula <-  "quality ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide +       density + pH + sulphates + alcohol" 


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



