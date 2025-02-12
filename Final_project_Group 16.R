# Group 5: ECON Project:

# Setting working directory

setwd('/Users/shekharvashist/Documents/UTD MSBA/UTD MSBA sem 3 Spring 2024/Econometrics/Project/Final Project')

# Importing Data
rm(list = ls())
load('Airfare.Rdata')

# Descriptive Analysis (EDA):

summary_df <- summary(data)

write.csv(summary_df, "summary_df.csv")

library(dplyr)

max_fare_year <- data %>%
  filter(fare == max(fare))

least_fare_year <- data %>%
  filter(fare == min(fare))


# Visualizing Data:

# Load required libraries
library(ggplot2)

# Histogram of log of passengers
ggplot(data, aes(x = lpassen)) + 
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  ggtitle("Distribution of Log of Passengers") +
  xlab("Log of Passengers") +
  ylab("Frequency")

# Boxplot of log of fares by year
ggplot(data, aes(x = factor(year), y = lfare)) +
  geom_boxplot(fill = "lightblue") +
  ggtitle("Boxplot of Log of Fares by Year") +
  xlab("Year") +
  ylab("Log of Fares")

# Scatter plot of log of fare vs log of passengers
ggplot(data, aes(x = lfare, y = lpassen)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  ggtitle("Scatter Plot of Log of Fare vs. Log of Passengers") +
  xlab("Log of Fare") +
  ylab("Log of Passengers")



# Correlation Analysis:

df_1 <- subset(data , select  = c(year, dist, passen, fare, bmktshr))
corr_matrix <- cor(df_1)


#install.packages("corrplot")

# Load corrplot
library(corrplot)

# Plot the correlation matrix
corrplot(corr_matrix, method = "color", type = "upper", order = "hclust", 
         tl_col = "black", tl_srt = 45, addCoef.col = "black", 
         title = "Correlation Matrix of Airline fare", cl.lim = c(-1, 1))


# Panel Data Analysis:

# Load lmtest for robust standard errors if needed
library(lmtest)

# Basic Pooled OLS model
model_1 <- lm(lpassen ~ lfare + ldist + factor(year) + bmktshr, data = data)
summary(model_1)  

# Load stargazer
#install.packages("stargazer")
library(stargazer)

# Open a connection to a text file
sink("model_summary.txt")

# Use stargazer to create the output
stargazer(model_1, type = "text", title = "Regression Results")

# Close the connection
sink()


# Removing ldist from the model and adding interactions between the lfare, bmktshr with time dummies.

model_2 <- lm(lpassen ~ lfare  + factor(year) + bmktshr + lfare*factor(year) + 
                bmktshr * factor(year), data = data) ;summary(model_2)  

sink("model_summary_OLS2.txt")

# Use stargazer to create the output
stargazer(model_2, type = "text", title = "Pooled OLS 2: Regression Results")

# Close the connection
sink()

# Panel Data Analysis:
library(plm)


# Fixed Effects model

library(plm)
pdata <- pdata.frame(data, index = c("id", "year"))

fe_model <- plm(lpassen ~ lfare + bmktshr + factor(year) + lfare:factor(year) + bmktshr:factor(year), 
                data = pdata, model = "within")
summary(fe_model)

re_model <- plm(lpassen ~ lfare + bmktshr + factor(year) + lfare:factor(year) + bmktshr:factor(year), 
                data = pdata, model = "random")
summary(re_model)

# Hausman Test
phtest(fe_model, re_model)

# From this test we conclude we should be using the FE model.

#---------------------------------
# writing results using stargazer:

sink("model_summary_FE.txt")

# Use stargazer to create the output
stargazer(fe_model, type = "text", title = "FE Model: Regression Results")

# Close the connection
sink()


# RE Results:

sink("model_summary_RE.txt")

# Use stargazer to create the output
stargazer(re_model, type = "text", title = "RE Model: Regression Results")

# Close the connection
sink()





#-------------------------------------------------------------------------------
#--------------------------------Extra work-------------------------------------
#-------------------------------------------------------------------------------
# Checking for Multicollinearity:

# Fit a linear model on the pooled data for VIF computation
model_lin <- lm(lpassen ~ lfare + bmktshr + factor(year) + lfare:factor(year) + bmktshr:factor(year), data = pdata)
# Calculate VIF
library(car)
vif(model_lin)

# Wooldridge test for autocorrelation in panel data
library(plm)
phtest <- pbgtest(lpassen ~ lfare + bmktshr + lfare:factor(year) + bmktshr:factor(year), data = pdata)
print(phtest)


# Adding a lagged dependent variable
pdata$lag_lpassen <- lag(pdata$lpassen, 1)  # create a lag of lpassen

# Fit the fixed effects model with the lagged variable
fe_model_lagged <- plm(lpassen ~ lfare + bmktshr + lfare:factor(year) + bmktshr:factor(year) + lag_lpassen,
                       data = pdata, model = "within")
summary(fe_model_lagged)

# Adding quadratic terms
fe_model_quad <- plm(lpassen ~ lfare + I(lfare^2) + bmktshr + I(bmktshr^2) + lfare:factor(year) + bmktshr:factor(year),
                     data = pdata, model = "within")
summary(fe_model_quad)

# Using the lmtest package to perform Breusch-Godfrey test
bg_test <- bgtest(fe_model_quad, order = 1)  # Check first-order serial correlation
print(bg_test)

