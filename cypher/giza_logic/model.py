import numpy as np
import pandas as pd
import xgboost as xgb
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score
from giza.datasets import DatasetsHub, DatasetsLoader
from giza.zkcook import serialize_model
from giza.agents import AgentResult, GizaAgent
from twelveData import data

def load_data():
    hub = DatasetsHub()
    loader = DatasetsLoader()
    df = loader.load('tokens-ohcl').to_pandas()
    df = df[df['token'] == 'WBTC']
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date').resample('D').asfreq().interpolate().reset_index()
    df['Volatility'] = (df['High'] - df['Low']) / df['Open']
    return df

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

def split_data(df):
    features = ['Open', 'High', 'Low', 'Close', 'Volatility', 'Avg_Open', 'Avg_High', 'Avg_Low', 'Avg_Close', 'Trend_Open', 'Trend_High', 'Trend_Low', 'Trend_Close']
    X = df[features]
    y = df['Target']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
    return X_train, X_test, y_train, y_test, features

def train_model(X_train, y_train):
    model = xgb.XGBClassifier(objective='binary:logistic', random_state=42)
    model.fit(X_train, y_train)
    return model

def hyperparameter_tuning(X_train, y_train):
    param_grid = {
        'n_estimators': [100, 200],
        'max_depth': [3, 4, 5],
        'learning_rate': [0.01, 0.1, 0.2],
        'subsample': [0.8, 0.9, 1.0],
        'colsample_bytree': [0.8, 0.9, 1.0]
    }

    xgb_model = xgb.XGBClassifier(objective='binary:logistic', random_state=42, n_jobs=-1)
    grid_search = GridSearchCV(estimator=xgb_model, param_grid=param_grid, cv=3, scoring='accuracy', verbose=1)
    grid_search.fit(X_train, y_train)

    print(f"Best parameters found: {grid_search.best_params_}")
    best_model = grid_search.best_estimator_

    return best_model

def evaluate_model(model, X_test, y_test):
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)
    report = classification_report(y_test, predictions)
    print(f"Model Accuracy: {accuracy}")
    print("Classification Report:")
    print(report)

def evaluate_model_cv(model, X, y):
    cv_scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
    print(f"Cross-validation scores: {cv_scores}")
    print(f"Mean cross-validation score: {np.mean(cv_scores)}")

def save_model(model, filename='giza_logic/model.json'):
    serialize_model(model, filename)
    print(f"Model saved as '{filename}'.")

def get_user_inputs():
    amount_to_invest = float(input("Enter the amount to be invested: "))
    risk_profile = input("Enter your risk profile (low, medium, high): ")
    duration_of_investment = int(input("Enter the duration of investment in days: "))
    return amount_to_invest, risk_profile, duration_of_investment

def determine_action(probabilities, buy_threshold=0.6, sell_threshold=0.6):
    print(f"Buy probability: {probabilities[0][1]}, Sell probability: {probabilities[0][0]}")
    if probabilities[0][1] >= buy_threshold:
        return 'buy'
    elif probabilities[0][0] >= sell_threshold:
        return 'sell'
    else:
        return 'watch'

def prediction_df(df):
    features = ['Open', 'High', 'Low', 'Close', 'Volatility', 'Avg_Open', 'Avg_High', 'Avg_Low', 'Avg_Close', 'Trend_Open', 'Trend_High', 'Trend_Low', 'Trend_Close']
    inp_df = pd.DataFrame({
        'Open': [df['Open'][-1]],
        'High': [df['High'][-1]],
        'Low': [df['Low'][-1]],
        'Close': [df['Close'][-1]],
        'Volatility': [df['Volatility'][-1]],
        'Avg_Open': [df['Avg_Open'][-1]],
        'Avg_High': [df['Avg_High'][-1]],
        'Avg_Low': [df['Avg_Low'][-1]],
        'Avg_Close': [df['Avg_Close'][-1]],
        'Trend_Open': [df['Trend_Open'][-1]],
        'Trend_High': [df['Trend_High'][-1]],
        'Trend_Low': [df['Trend_Low'][-1]],
        'Trend_Close': [df['Trend_Close'][-1]]
    })
    inp_df = inp_df[features]
    return inp_df.to_numpy()

def predict_action(model, user_inputs, features, df):
    amount_to_invest, risk_profile, duration_of_investment = user_inputs
    if risk_profile == 'low':
        volatility_range = 0.05
    elif risk_profile == 'medium':
        volatility_range = 0.2
    elif risk_profile == 'high':
        volatility_range = 0.4

    inp_df = pd.DataFrame({
        'Open': [df['Open'][-1]],
        'High': [df['High'][-1]],
        'Low': [df['Low'][-1]],
        'Close': [df['Close'][-1]],
        'Volatility': [df['Volatility'][-1]],
        'Avg_Open': [df['Avg_Open'][-1]],
        'Avg_High': [df['Avg_High'][-1]],
        'Avg_Low': [df['Avg_Low'][-1]],
        'Avg_Close': [df['Avg_Close'][-1]],
        'Trend_Open': [df['Trend_Open'][-1]],
        'Trend_High': [df['Trend_High'][-1]],
        'Trend_Low': [df['Trend_Low'][-1]],
        'Trend_Close': [df['Trend_Close'][-1]]
    })
    inp_df = inp_df[features]
    probabilities = model.predict_proba(inp_df)
    print(f"Probabilities: {probabilities}")
    action = determine_action(probabilities)
    return action

def test():
    df = load_data()
    df = feature_engineering(df)
    X_train, X_test, y_train, y_test, features = split_data(df)
    
    # Model training with hyperparameter tuning
    model = hyperparameter_tuning(X_train, y_train)
    
    # Model evaluation
    evaluate_model(model, X_test, y_test)
    evaluate_model_cv(model, X_train, y_train)
    
    save_model(model)
    
    user_inputs = get_user_inputs()
    pred_df = feature_engineering(data.predict_btc())
    action = predict_action(model, user_inputs, features, pred_df)
    print(f"The model suggests to {action} based on the provided inputs.")