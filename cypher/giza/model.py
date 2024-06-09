
import datetime
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.optim as optim
import yfinance as yf
from sklearn.metrics import mean_squared_error as mse

def load_data():
    hub = DatasetsHub()
    loader = DatasetsLoader()
    df = loader.load('tokens-ohcl').to_pandas()
    df = df[df['token'] == 'WBTC']
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date').resample('D').asfreq().interpolate().reset_index()
    df['Volatility'] = (df['High'] - df['Low']) / df['Open']
    return df


# In[26]:



def feature_engineering(df):
    df['Avg_Open'] = df['Open'].rolling(window=7).mean()
    df['Avg_High'] = df['High'].rolling(window=7).mean()
    df['Avg_Low'] = df['Low'].rolling(window=7).mean()
    df['Avg_Close'] = df['Close'].rolling(window=7).mean()
    df['Trend_Open'] = df['Open'].pct_change(periods=7)
    df['Trend_High'] = df['High'].pct_change(periods=7)
    df['Trend_Low'] = df['Low'].pct_change(periods=7)
    df['Trend_Close'] = df['Close'].pct_change(periods=7)
    df.dropna(inplace=True)
    df['Target'] = (df['Close'].shift(-1) > df['Close']).astype(int)
    df = df[:-1]
    return df


# In[27]:



def split_data(df):
    features = ['Open', 'High', 'Low', 'Close', 'Volatility', 'Avg_Open', 'Avg_High', 'Avg_Low', 'Avg_Close', 'Trend_Open', 'Trend_High', 'Trend_Low', 'Trend_Close']
    X = df[features]
    y = df['Target']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
    return X_train, X_test, y_train, y_test, features


# In[28]:



def train_model(X_train, y_train):
    model = xgb.XGBClassifier(objective='binary:logistic', random_state=42)
    model.fit(X_train, y_train)
    return model


# In[29]:



def evaluate_model(model, X_test, y_test):
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)
    report = classification_report(y_test, predictions)
    print(f"Model Accuracy: {accuracy}")
    print("Classification Report:")
    print(report)


# In[30]:



def save_model(model, filename='model.json'):
    model.save_model(filename)
    print(f"Model saved as '{filename}'.")


# In[31]:



def get_user_inputs():
    amount_to_invest = float(input("Enter the amount to be invested: "))
    risk_profile = input("Enter your risk profile (low, medium, high): ")
    duration_of_investment = int(input("Enter the duration of investment in days: "))
    return amount_to_invest, risk_profile, duration_of_investment


# In[32]:



def determine_action(probabilities, buy_threshold=0.6, sell_threshold=0.6):
    print(f"Buy probability: {probabilities[0][1]}, Sell probability: {probabilities[0][0]}")
    if probabilities[0][1] >= buy_threshold:
        return 'buy'
    elif probabilities[0][0] >= sell_threshold:
        return 'sell'
    else:
        return 'watch'


# In[35]:



def predict_action(model, user_inputs, features, df):
    amount_to_invest, risk_profile, duration_of_investment = user_inputs
    if risk_profile == 'low':
        volatility_range = 0.05
    elif risk_profile == 'medium':
        volatility_range = 0.2
    elif risk_profile == 'high':
        volatility_range = 0.4

    sample_input = pd.DataFrame({
        'Open': [df['Open'].median()],
        'High': [df['High'].median()],
        'Low': [df['Low'].median()],
        'Close': [df['Close'].median()],
        'Volatility': [volatility_range],
        'Avg_Open': [df['Avg_Open'].median()],
        'Avg_High': [df['Avg_High'].median()],
        'Avg_Low': [df['Avg_Low'].median()],
        'Avg_Close': [df['Avg_Close'].median()],
        'Trend_Open': [df['Trend_Open'].median()],
        'Trend_High': [df['Trend_High'].median()],
        'Trend_Low': [df['Trend_Low'].median()],
        'Trend_Close': [df['Trend_Close'].median()]
    })
    sample_input = sample_input[features]
    probabilities = model.predict_proba(sample_input)
    print(f"Probabilities: {probabilities}")
    action = determine_action(probabilities)
    return action

if __name__ == "__main__":
    df = load_data()
    df = feature_engineering(df)
    X_train, X_test, y_train, y_test, features = split_data(df)
    model = train_model(X_train, y_train)
    evaluate_model(model, X_test, y_test)
    save_model(model)
    
    user_inputs = get_user_inputs()
    action = predict_action(model, user_inputs, features, df)
    print(f"The model suggests to {action} based on the provided inputs.")


# In[ ]:







def main():
    #!/usr/bin/env python
    # coding: utf-8
    # In[1]:
    get_ipython().system('pip install giza-datasets')
    get_ipython().system('pip install git+https://github.com/gizatechxyz/datasets')
    get_ipython().system('pip install xgboost')
    get_ipython().system('pip install scikit-learn')
    get_ipython().system('pip install polars')
    # In[13]:
    import os
    import certifi
    import polars as pl
    import pandas as pd
    from giza.datasets import DatasetsHub, DatasetsLoader
    from sklearn.model_selection import train_test_split
    from sklearn.metrics import accuracy_score, classification_report
    import xgboost as xgb
    import numpy as np
    # Set SSL_CERT_FILE environment variable
    os.environ['SSL_CERT_FILE'] = certifi.where()
    # In[25]:

if __name__ == "__main__":
    main()
