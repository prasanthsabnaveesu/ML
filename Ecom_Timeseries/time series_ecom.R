
rm(list=ls(all=TRUE))

data=readRDS("ecommerceData.RData")
names(data)
summary(data$Condition)
min(data$Date)
max(data$Date)
dim(data)
length(unique(data$TitleKey))

library(forecast)
library(DMwR)
library(plyr)
library(dplyr)
library(data.table)
library(TTR)
#install.packages("Quand1")
library(Quand1)
#install.packages("graphics")
library(graphics)
#install.packages("imputeTS")
library(imputeTS)
install.packages("Datacombine")
library(Datacombine)

#install.packages("lubridate")
library(lubridate)

data2 = data[data$TitleKey == "4302628" & data$Condition == "Good",]
dim(data2)
head(data2)
tail(data2)
names(data2)
str(data2)

RtData2Day <- data2 %>%  group_by(Date) %>% summarise("MIN_PRICE" = mean(Price))
RtData2Day <- data.frame(RtData2Day)
str(RtData2Day)

RtData2Day$Date = as.Date(RtData2Day$Date,format = "%Y-%m-%d")

head(RtData2Day)
str(RtData2Day)
 
sum(is.na(RtData2Day))

#minDate = min(as.Date(,format="%Y-%m-%d"))
minDate=min(as.Date(RtData2Day$Date,format="%Y-%m-%d"))
typeof(data$Date)

maxDate = max(as.Date(RtData2Day$Date,format="%Y-%m-%d"))

seq <- data.frame("dateRange"=seq(minDate,maxDate,by="days"))

RtData2Day2 <- seq %>% full_join(RtData2Day,c("dateRange" = "Date"))

RtData2Day <- data.frame(RtData2Day)
RtData2Day2 <- RtData2Day2
head(RtData2Day2)

RtData2Day2$MIN_PRICE <- na.locf(RtData2Day2$MIN_PRICE)
head(RtData2Day2)
# Getting the year from the date column and creating a new column YEAR
RtData2Day2$YEAR <-as.numeric(format(RtData2Day2$dateRange,format="%Y"))
# Getting the week from the date column and creating a new column WEEK
RtData2Day2$WEEK <-as.numeric(format(RtData2Day2$dateRange,format="%W"))
# Sorting the data in ascending order based on Year and Week
RtData2Day2 <- RtData2Day2[order(RtData2Day2$YEAR,RtData2Day2$WEEK),]

RtData2Week <- RtData2Day2 %>% group_by(YEAR,WEEK) %>% summarise("MIN_PRICE" = mean(MIN_PRICE))
RtData2Week <- data.frame(RtData2Week)

Train <- RtData2Week[1:(nrow(RtData2Week) - 4),]
Test <- RtData2Week[(nrow(RtData2Week) - 3):nrow(RtData2Week),]

Pricedecomposed = decompose(Price)
plot(Pricedecomposed,col="blue")

Price <- ts(Train$MIN_PRICE, frequency =12)

plot(Price,type="l",lwd=3,col="red",xlab="week",ylab="Price",main="Time series plot for Book-xyzabc")

par(mfrow=c(2,2))
acf(Price,lag=30)
pacf(Price,lag=30)

acf(Train$MIN_PRICE,lag=30)
pacf(Train$MIN_PRICE,lag=30)
plot(diff(Price,lag=2),type="l");  acf(diff(Price,lag = 2),lag=30); pacf(diff(Price,lag = 2),lag=30)

ndiffs(Price)

fitsma <- SMA(Price,n=2)

predsma <- forecast(fitsma[!is.na(fitsma)],h=4)
plot(predsma)

smaTrainMape <- regr.eval(Price[2:length(Price)],fitsma[2:length(Price)])
smaTestMape <- regr.eval(Test$MIN_PRICE,predsma$mean)
smaTrainMape
smaTestMape

fitwma<- WMA(Price,n=2,1:2)

predwma <- forecast(fitwma[!is.na(fitwma)],h=4)
plot(predwma)

wmaTrainMape <- regr.eval(Price[2:length(Price)],fitwma[2:length(Price)])
wmaTestMape <- regr.eval(Test$MIN_PRICE,predwma$mean)
wmaTrainMape
wmaTestMape

fitEma <- EMA(Price, n = 2)

predema <- forecast(fitEma[!is.na(fitEma)],h=4)
plot(predema)

emaTrainMape <- regr.eval(Price[2:length(Price)],fitEma[2:length(Price)])
emaTestMape <- regr.eval(Test$MIN_PRICE,predema$mean)
emaTrainMape
emaTestMape

holtpriceforecast <- HoltWinters(Price,gamma=FALSE)
head(holtpriceforecast$fitted)

priceholtforecast <- HoltWinters(Price, beta=TRUE, gamma=TRUE, seasonal="additive")
head(priceholtforecast$fitted)

holtforecastTrain <- data.frame(priceholtforecast$fitted)
holtforecastTrainpredictions <- holtforecastTrain$xhat
head(holtforecastTrainpredictions)

holtpriceforecast<-  forecast(priceholtforecast,h = 4)
plot(holtpriceforecast,ylim = c(-200,200))

hwTestMape <- regr.eval(Test$MIN_PRICE,holtpriceforecast$mean)
hwTestMape

model1 <- arima(Price,c(0,0,0))
model1
acf(Price) 
pacf(Price)
plot(Price)

model2 <- arima(Price,c(0,1,0))
model2
acf(diff(Price,lag = 1))
pacf(diff(Price,lag = 1))
plot(diff(Price))

model3 <- arima(Price,c(0,2,0))
model3
plot(diff(Price,differences = 2))
acf(diff(Price,differences = 2))
pacf(diff(Price,differences = 2))

model4 <- arima(Price,c(1,1,1))
model4

par(mfrow=c(2,2))
plot(model1$residuals,ylim=c(-50,50))
plot(model2$residuals,ylim=c(-50,50))
plot(model3$residuals,ylim=c(-50,50))
plot(model4$residuals,ylim=c(-50,50))

MODEL_ARIMA <- auto.arima(Price, ic='aic')
summary(MODEL_ARIMA)

set.seed(12334)
x <- rnorm (100)
Box.test (x, lag = 1)
Box.test (x, lag = 1, type = "Ljung")

Box.test(MODEL_ARIMA$residuals, lag = 10, type = "Ljung-Box")

pricearimaforecasts1 <- forecast(model1, h=4)
plot(pricearimaforecasts1)
pricearimaforecast3 <- forecast(model3, h=4)
plot(pricearimaforecast3)
pricearimaforecasts_autArima<- forecast(MODEL_ARIMA,h=4)
plot(pricearimaforecasts_autArima,flwd = 2)

arimaModel1TestMape <- regr.eval(Test$MIN_PRICE,pricearimaforecasts1$mean)
arimaModel1TestMape

arimaModel3TestMape <- regr.eval(Test$MIN_PRICE,pricearimaforecast3$mean)
arimaModel3TestMape

autoarimaTestMape <- regr.eval(Test$MIN_PRICE,pricearimaforecasts_autArima$mean)
autoarimaTestMape
