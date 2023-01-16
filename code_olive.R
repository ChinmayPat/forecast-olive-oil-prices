str(oliveoil)

# Change column name
names(oliveoil)[names(oliveoil) == "POLVOILUSDA"] <- "Price"
class(oliveoil)
summary(oliveoil)
dim(oliveoil)
print(oliveoil)
library(ggplot2)
ggplot(oliveoil, aes(DATE,Price,group=1))+geom_line()+labs(title='Global price of Olive Oil', x="Years", y="US Dollars per Metric Ton")
sum(is.na(oliveoil))
summary(is.na(oliveoil))

# Outlier detection

boxplot(oliveoil[,c('Price')])

# Converting to ts

oliveoil.ts=ts(oliveoil[,-1])
#oliveoil.ts.log=log(oliveoil.ts)
plot(oliveoil.ts, ylab='Price', main='Global Price of Olive oil from 1990-2020' )

# ACF

acf(oliveoil.ts, lag.max = 30)

# PACF

pacf(oliveoil.ts, lag.max = 30)

# Dicky-Fuller test
library(CADFtest)
CADFtest(oliveoil.ts)

# Detrending

oliveoil.ts.df = diff(oliveoil.ts, differences = 1)
plot(oliveoil.ts.df)
acf(oliveoil.ts.df,ylab="ACF", lag.max = 30)
pacf(oliveoil.ts.df,ylab="PACF", lag.max = 30)
CADFtest(oliveoil.ts.df)

# ACF cuts off at lag 1 q=1,2
# PACF p=0
# d=1

library(FitAR)
library(rcompanion)
parameterEstimationARIMA <- function(p,d,q) {
  #Parameter estimation using MLE
  
  Estimate1=arima(oliveoil.ts.df,order=c(p,d,q), method = 'ML')
  print(Estimate1)
  
  #Compare models using AIC and BIC
  
  AR=arima(oliveoil.ts.df,order = c(p,d,q))
  print(AIC(AR))
}

residualAnalysis <- function(p,d,q){
  AR=arima(oliveoil.ts.df,order = c(p,d,q))
  tsdiag(AR, gof = 15, omit.initial = F, lwd=2, col="red")
  # QQ Plot
  
  qqnorm(AR$residuals)
  qqline(AR$residuals)
  
  # Shapiro-Wilk Test
  
  print(shapiro.test(AR$residuals))
  plotNormalHistogram(AR$residuals)
  ts.plot(oliveoil.ts.df)
  AR_fit = oliveoil.ts.df - residuals(AR)
  points(AR_fit,type='o',col='red',lty=2)
}

parameterEstimationARIMA(0,1,1)
parameterEstimationARIMA(0,1,2)


residualAnalysis(0,1,2)

#GARCH
arima012=arima(oliveoil.ts.df,order = c(0,1,2))
res.arima012=arima012$res
squared.res.arima012=res.arima012^2
#par(mfcol=c(3,1))
plot(squared.res.arima012,main='Squared Residuals')

acf.squared012=acf(squared.res.arima012,main='ACF Squared
Residuals',lag.max=100,ylim=c(-0.5,1))
pacf.squared012=pacf(squared.res.arima012,main='PACF Squared
Residuals',lag.max=100,ylim=c(-0.5,1))

garchparameterestimation <- function(p,q) {
  arch=garch(res.arima012,order=c(p,q),method='ML',trace=F)
  loglik=logLik(arch)
  print(loglik)
  print(AIC(arch))
  summary(arch)
}

garchparameterestimation(0,1)
garchparameterestimation(0,2)

# Compute ht, conditional variance:
arch=garch(res.arima012,order=c(0,2),trace=F)
ht.arch=arch$fit[,1]^2
plot(ht.arch,main='Conditional variances')

library(forecast)
final_AR=arima(oliveoil.ts.df,order = c(0,1,2))
fit012=fitted.values(final_AR)
low=fit012-1.96*sqrt(ht.arch)
high=fit012+1.96*sqrt(ht.arch)
plot(oliveoil.ts.df,type='l')
lines(low,col='red')
lines(high,col='blue')
forecastAR=forecast(final_AR,5,level=95)
plot(forecastAR)
