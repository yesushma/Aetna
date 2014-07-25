

knit_child("config_knit.R")



##   x <- seq(-3,3, length = 100)
##   y <- dnorm(x)
##   plot(x, y, type = "l", col = "blue")



##     x <- seq(0, 5, length = 50)
##     plot(x, dexp(x, 1), col = "red", type="l")



## rxGlm(formula, data, family = gaussian(), ... )



## infile <- file.path("data", "BankXDF.xdf")
## BankDS <- RxXdfData(file = infile)
## rxHistogram(~housing , data = BankDS)



infile <- file.path("data", "BankXDF.xdf") 
BankDS <- RxXdfData(file = infile)
rxHistogram(~housing , data = BankDS)



    glmMod <- rxGlm(housing ~ balance + marital, data = BankDS, family = binomial())



#    glmMod <- rxLogit(housing ~ balance + marital, data = BankDS)



summary(glmMod)



df <- as.data.frame(glmMod$coefficients)
df[2] <- exp(df[1])
names(df)<- c("coeff","oddsRatio")
df



glmMod <- rxLogit(default ~ balance + age + housing, data = BankDS)

summary(glmMod)



df <- as.data.frame(glmMod$coefficients)
df[2] <- exp(df[1])
names(df)<- c("coeff","oddsRatio")
df


