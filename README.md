# forecast-olive-oil-prices
Time series analysis and Forecasting of Olive oil Prices

# Data Description
The dataset is from Fred Economic Data | St. Louis Fed and the source link of the dataset is
https://fred.stlouisfed.org/series/POLVOILUSDA. The dataset has 31 samples (rows) and 2 groups
(columns). The two columns are Date and Price of Olive oil. The Date column is yearly starting from
1990 to 2020. There are no missing values and no outliers as shown by the box-plot diagram below.

![outlier](https://user-images.githubusercontent.com/40643158/212625825-9523f140-b7a6-436f-b36c-a61a07a644e6.png)

As the dataset was in a dataframe, it is converted in a time series format in order to perform a time
series decision process called Box-Jenkins and forecast future prices. Below is the graph of global price
of olive oil from 1990 to 2020.

![global_price](https://user-images.githubusercontent.com/40643158/212627573-17607845-7d34-4dee-a6d7-3d42051e0a92.png)

# Box-Jenkins Process
## I. Stationary Test
After converting to a time series data type, the time series data is plotted with its ACF and PACF plots.
These three plots are used to determine whether the data shows any trend or gives any sign of nonstationary. By observing the time series plot, the data seems to follow an upward trend, then a downward trend followiing the same pattern twice and eventually falls down. Similarly, by observing the
ACF and PACF plots, the ACF plot shows significant lag at 0,5,10 and 15 and slowly decays and the
PACF plot has significant lag at 1, 2 and 5 and decays away. By observing the plots, we can say the
data is non-stationary. In order to confirm our observation we perform a Dicky-Fuller test. The DickyFuller test gives a p-value of 0.06659 which is greater than 0.05 hence failing to reject the nullhypothesis that data is non-stationary. Below are the plots of ACF and PACF and the result of Dick-Fuller test.

![acf](https://user-images.githubusercontent.com/40643158/212627650-6344c9a2-20c6-4497-9635-2f15204c9e1e.png)

![pacf](https://user-images.githubusercontent.com/40643158/212627694-edb0b0c3-3e66-4009-b999-e73b3c60f6f9.png)

![adf](https://user-images.githubusercontent.com/40643158/212627736-f103669c-455a-4075-ae4b-5e317e7cf5c9.png)

In order to detrend the data, I differenced the data by order of 1. After differencing, ACF and PACF of
the differenced data was plotted and performed the Dicky-Fuller test to confirm whether data is
stationary or not. The result of Dick-Fuller test gave a p-value of 0.02745 hence rejecting the null
hypothesis and confirming that detrended data is stationary. Below are ACF and PACF plots of
differenced data.

![d-acf](https://user-images.githubusercontent.com/40643158/212627894-576be70c-8621-4287-ba4f-399913619528.png)

![d-pacf](https://user-images.githubusercontent.com/40643158/212627922-96538351-d98d-4c5b-b943-92a199a3aec6.png)

![d-adf](https://user-images.githubusercontent.com/40643158/212627957-cd591530-a6d5-4a86-8542-a6ef097ff3f6.png)

## II. Finding Models and Parameter Redundancy
By observing ACF and PACF plots, the following inferences are made – the PACF plot has no
significant lags, the ACF plot has 1 significant lag after which there is a drop and the plot decays.
Based on these inferences, a MA(1) and MA(2) model can be suggested. Therefore since we have
difference the data once, the order of difference is 1. Therefore an ARIMA(0,1,1) and an
ARIMA(0,1,2) are the suggested models.

## III. Parameter Estimation
![image](https://user-images.githubusercontent.com/40643158/212626803-f156b56f-1441-4eca-9fc8-72240aa25d31.png)

After finalizing the suggested models, we need to confirm which model better fits the data. In order to
find the best model we will compare the log likelihood values and AIC values of the suggested models.
We have suggested ARIMA(0,1,1) and ARIMA(0,1,2) model and their respective log likelihood and
AIC values are given above. We need to choose the model which has the highest log likelihood value
and lowest AIC values as we are going to forecast future values AIC is better indicator. By observing
we conclude that the AIC value of ARIMA(0,1,2) has the lowest value among the two models and its
log likelihood is higher among the two models. Therefore ARIMA(0,1,2) is a good fit to forecast future
values for the data.

## IV. Residual Analysis
We have finalized our model using which we are going to predict future values. Now, we perform
residual analysis in order to test the goodness of the fit of the model. Below is the plot of standardized
residuals of the fitted ARIMA(0,1,2) model. The parameters are estimated using maximum likelihood
method. By observing the standardized residuals plot we can see that there is one significant residual
having higher magnitude and elsewhere the residuals are very close to the zero horizontal level and
show no trend whatsoever. The variance among the residuals is also very low. Based on these
inferences we can say that the model is adequate. Next we observe the ACF of the residuals, we can see
that there is only one significant auto-correlation in the residuals and can conclude that ARIMA(0,1,2)
is a better fit for the data. We look into another method to test against residual auto-correlation called
Ljung-Box test. The null hypothesis of the Ljung-Box test is that the error terms are uncorrelated and
the alternate hypothesis is its opposite. By observing the p-values of the Ljung-Box test statistics given
below, it indicates that majority of the p-values are significantly higher hence failing to reject the null
hypothesis that the error term are uncorrelated hence concluding that the model ARIMA(0,1,2) is a
good fit. Now we asses the normal Q-Q plot of the residuals of the ARIMA(0,1,2) model. The points
seems to fairly follow the line except for the points at the tail of the line. Based on this plot, we could
safely assume that this set of data is normally distributed. Next, we confirm the Normality of the model
by performing the Shapiro-Wilks test. The result of the Shapiro-Wilks test is given below where the pvalue is 0.04485 indicating that the residuals do not follow a normal distribution rejecting normality.

![sd-residual](https://user-images.githubusercontent.com/40643158/212630049-aef93c0a-0169-48a8-8b9f-af8ce389650a.png)

![qq](https://user-images.githubusercontent.com/40643158/212630077-85685c94-e99c-49f4-9935-e3e6a308db56.png)

![s-w-test](https://user-images.githubusercontent.com/40643158/212630133-bc701265-8485-413a-ad2f-53b77101c8b0.png)

Below is the histogram of the distribution of the residuals clearly indicating that the residuals are not
normally distributed.

![hist](https://user-images.githubusercontent.com/40643158/212630166-7b5c3fe0-a470-4fee-9d62-6512d21bd270.png)

## V. GARCH Model Implementation
As there is a slight indication of volatility in the residuals of the fitted ARIMA(0,1,2) model, a
GARCH(p,q) model is therefore implemented to better fit the data. Now we observe the squared
residual plots given below which confirms a cluster of volatility. Then we plot the ACF and PACF of
the squared residuals to estimate the parameters of the GARCH model.

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

By observing the ACF and PACF of the squared residuals, we infer that there is no significant
correlation in the PACF and in ACF there is only only one significant lag after which it drops and
decays slowly. Based on these indicators we suggest GARCH models such as GARCH(0,1) and
GARCH(0,2). In order to find which model better fits the data we compare the AIC and log likelihood
values of both the GARCH models.

![image](https://user-images.githubusercontent.com/40643158/212627302-f4520849-b8e0-452c-abff-477afcba0671.png)

Based on values given in the above table we can conclude that GARCH(0,2) model is a better fit for the
data as its AIC value is less compared to GARCH(0,1) model.
We then performed some residual analysis on the GARCH(0,2) model. The p-value of the parameters
are all greater than 0.05 indicating that the parameters are not significant. In addition, p-value of LjungBox test is greater than 0.05 and so we cannot reject the null hypothesis that the autocorrelation of the
residuals is different from zero. The model thus poorly represents the residuals.
Below is the 95% Confidence Interval of the ARIMA(0,1,2)-GARCH(0,2) model.

![garch-resi](https://user-images.githubusercontent.com/40643158/212630219-20b88bb3-b1a7-4277-bd57-21b0f9a66994.png)

![garch-CI](https://user-images.githubusercontent.com/40643158/212630328-7174ea28-948c-402f-b784-ee77f8637cc3.png)

VI. Prediction
After residual analysis and testing the goodness of the fitted model we then forecast the future global
price of olive oil. Below is the prediction plot of the next 5 years of olive oil price.

![forecast](https://user-images.githubusercontent.com/40643158/212630354-965c4c1d-062c-48d9-8597-3ab3c311e043.png)

# Conclusion
The model did not accurately represent the data as the dataset had very few samples. The 95%
confidence interval range for the fitted model is very large hence affecting the predicted values. With
more data provided a better model can be trained and provide a low 95% confidence interval range
hence significantly improving the prediction of future prices of olive oil.
