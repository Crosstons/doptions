# Cypher
#### AI-Driven Options Trading Agent on Decentralized Protocols

- [Video Demo](https://youtu.be/ZQf8cjNT3h0?si=6WNDQa5Ld4NJLhTd)
- [Pitch Deck](https://gamma.app/docs/Agent-Cypher--us39azt1iezgykt)

## Table of Contents

1. Problem Statement
2. Project Description
3. Tech Stack
4. Workflow
5. Future Improvements

## Problem Statement

Options trading is complex and requires constant monitoring of market conditions and strategic decision-making. Traditional methods lack automation and real-time responsiveness, leading to missed opportunities and potential losses. There's a need for an intelligent, automated system that can make informed trading decisions on decentralized platforms, ensuring efficient and profitable trading.

## Project Description

Cypher is an AI-driven options trading agent designed to automate and optimize trading decisions on decentralized options protocols. By leveraging an advanced XGBoost machine learning model, Cypher provides users with actionable insights based on real-time market data. Users input their investment amount, risk tolerance, and investment duration, and Cypher handles the rest.

### Key Features

1. User Inputs: Amount to be invested, risk tolerance (low, medium, high), and duration of investment.
2. Data Fetching: Real-time market data collection.
3. Model Prediction: XGBoost ML model for market movement predictions.
4. Threshold Check: Determine action buy (call, put) option based on prediction thresholds.
5. Volatility Check: Compare current and historical volatility to match user’s risk profile.
6. Option Selection: Fetch and filter call/put options, calculate potential profits, and select the best option.
7. Execution: Execute trades based on the highest profit potential.

## Tech Stack

Leveraging below technologies:

1. Giza - For zero knowledge machine learning and agents-sdk.
2. XGBoost - Machine learning model for predictions.
3. APIs - For fetching real-time market data.
4. Pandas - Data manipulation and feature engineering.
5. Sklearn - Model training and evaluation.

## Workflow

1. Fetch Data from API
   - Real-time collection of market data.
2. Model Prediction
   - Predict market movements using XGBoost.
3. Threshold Check
   - Evaluate prediction probabilities and determine action.
4. Volatility Check
   - Compare current volatility with 30-day average.
5. Option Selection
   - Fetch and filter options based on premium and expiration.
6. Execution
   - Execute the trade with the highest profit potential.

## Future Improvements

1. Total Automation: Implement end-to-end trade execution.
2. Advanced Strategies: Introduce strategies like hedging and diversification.
3. Providing Multiple Options: Provide multiple optimal trading options.
4. Option Writing: Enable the agent to write options for additional profits.
5. Increased Accuracy: Enhance the model’s accuracy through improved data processing.

---

This comprehensive README provides an overview of the Agent Cipher project, detailing its functionality, technical stack, workflow, and future improvements for an intelligent options trading system on decentralized protocols.