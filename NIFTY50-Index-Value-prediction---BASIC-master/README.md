# NIFTY50-Index value-prediction using python---BASIC
Test project to map and test the correlations between NIFTY50 Index &amp; NASDAQ Index, USD/INR Exchange rate, WTI Crude oil price using the most suitable machine learning model/s. Also explore other factors that have high correlation metric value.

Problem Clarification:

Predict future (next 6 months-TEST) values of NIFTY50 index (at t+1,next day,next month,next year) when the following Macroeconomic data(past 18 months data-TRAINING):

* NASDAQ composite index value (IXIC)
* USD/INR exchange rate
* WTI Crude oil price value

Test metric for accuracy: Mean Absolute Error(MAE) or Mean absolute percentage error(MAPE)

Any and all requisite financial data for the mentioned 2 years can be found at Quandl.
https://www.quandl.com/tools/python
Examples:
https://www.quandl.com/data/NSE/NIFTY_50-National-Stock-Exchange-of-India-NSE-Stock-Index-Nifty-50
https://www.quandl.com/data/NASDAQOMX/COMP-NASDAQ-Composite-COMP
https://www.eia.gov/dnav/pet/hist/RWTCD.htm
https://www.quandl.com/data/CUR/INR-Currency-Exchange-Rates-USD-INR

Tools & Frameworks: 
- Jupyter Notebook,with anaconda navigator (package manager) https://www.anaconda.com/download/#macos
- https://github.com/quandl/quandl-python
-(to be updated)

OBJECTIVES:
1. Propose the most suitable prediction(learning & mapping) model.
2. Calculate and optimize the Mean Absolute Error (MAE) between actual and predicted prices.
3. Hypothesis testing for correlation between markets & indices.
4. Propose optimized techniques to prepare and preprocess datasets, specifically for the given problem. 
5. Map the correlation percentage of each of the given macroenomonic factors with the CNX Nifty index value to facilitate work in fundamental market analysis of CNX Nifty
6. Test efficacy of Fundamental vs Technical vs Sentiment analysis as well as of clustering them(if viable).
7. Propose additional,significant input paramters.
8. Create a library of citations for resources used in the development of the project.
9.(to be updated)

DRAFT PROJECT PIPELINE:(under development)

Suggested Prerequisites: 

1. Download the following historic data:
* Open, high, low, close, volume, turnover - CNX Nifty
* Index value, open, high, low, close - NASDAQ composite
* WTI Oil Price values
* USD/INR exchange rate
       For period of  10/07/2016 - 10/07/2018, and divide them into 2 data frames named train<for initial 18 months data> and test<for last 6 months data> (optional at this stage)

2. Clean data, format it, prepare for merging
3. Merge all the data in a single dataframe
* Data frame consisting of date wise OHLCV of NIFTY50 index from 13/07/16-13/02/18
* Data frame consisting of date wise Closing of NIFTY50, Oil price, NASDAQ, EX rate from 13/06/16-13/01/18
*  Data frame consisting of date wise OHLCV of NIFTY50 index from 13/02/18-13/07/18
* Data frame consisting of date wise Closing of NIFTY50, Oil price, NASDAQ, EX rate from 13/02/18-13/07/18
5. Bring all parameters to scale. Figure out most suitable method for scaling. 
6. Exploratory Data analysis:
* Use correlation and cross validation tests to figure out best input amongst: Closing, Opening, High, Low also consider other technical indicators at later stage. 
7. Consider PCA of OHLC after scaling, and clustering output with other input data(scaled).
8. Prediction Model
*  inputs with additional data derived from input e.g. trend direction, previous days indice movement
* Current list of models to be explored - 
NN-EGARCH (KOSPI)
SVM
Random forest
Decision tree, Gradient boosted trees
Naive Bayesian
Deep learning models - MLP, RNN(LSTM), CNN,
linear (AR, MA, ARIMA, ARMA), and non-linear models (ARCH, GARCH, NN)
Genetic Algorithm
LSSVM and PSO
Twin Gaussian Process
SVR and PCA
9. Optimisation
