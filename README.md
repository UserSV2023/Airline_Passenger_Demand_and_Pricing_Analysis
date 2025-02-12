# Airline Passenger Demand and Pricing Analysis

This project analyzes the impact of fare prices and market concentration on airline passenger demand using U.S. domestic airline fare data (1997–2000). Key objectives include estimating price elasticity and understanding demand trends.

📊 Data

Source: U.S. Domestic Airline Fares Consumer Report

Variables: Year, Distance, Passengers, Fare, Market Share

🔍 Methodology
Exploratory Data Analysis (EDA): Log transformation for skewed variables, correlation analysis.

Econometric Models:
Pooled OLS: Baseline regression.

Fixed Effects (FE) & Random Effects (RE): Address route-specific unobserved heterogeneity.

Hausman Test: Preference for FE model.

📈 Key Findings

Price Elasticity: A 1% fare increase leads to a 1.136% drop in passengers.

Market Concentration: Higher market share correlates with increased passengers.

Trends Over Time: Price sensitivity declines over time, suggesting evolving consumer preferences.

📌 Conclusion
Fare prices strongly influence demand, but factors like service quality and competition are becoming more significant. Future work could explore causal relationships using natural experiments.
