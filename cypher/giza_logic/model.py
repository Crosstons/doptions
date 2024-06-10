import numpy as np
import pandas as pd
import xgboost as xgb
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score
from giza.datasets import DatasetsHub, DatasetsLoader
from giza.zkcook import serialize_model, mcr
from twelveData import data

def load_data():
    hub = DatasetsHub()
    loader = DatasetsLoader()
    df = loader.load('tokens-ohcl').to_pandas()
    df = df[df['token'] == 'WBTC']
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date').resample('D').asfreq().interpolate().reset_index()
    df['Volatility'] = (df['High'] - df['Low']) / df['Open']
    df.dropna(subset=['Open', 'High', 'Low', 'Close', 'Volatility'], inplace=True)
    return df

def split_data(df):
    features = ['Open', 'High', 'Low', 'Close', 'Volatility']
    X = df[features]
    y = (df['Close'].shift(-1) > df['Close']).astype(int)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
    return X_train, X_test, y_train, y_test, features

def train_model(X_train, y_train, X_test, y_test):
    model = xgb.XGBClassifier(objective='binary:logistic', random_state=42)
    model.fit(X_train, y_train)
    
    mcr_model, _transformer = mcr(model=model, X_train=X_train, y_train=y_train, X_eval=X_test, y_eval=y_test, eval_metric = 'rmse', transform_features = True)
    save_model(mcr_model)
    return model

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
    id_agent = int(input("Enter the agent-id you want to connect to: "))
    amount_to_invest = float(input("Enter the amount to be invested: "))
    risk_profile = input("Enter your risk profile (low, medium, high): ")
    duration_of_investment = int(input("Enter the duration of investment in days: "))
    return id_agent, amount_to_invest, risk_profile, duration_of_investment

def determine_action(probabilities, buy_threshold=0.6, sell_threshold=0.6):
    print(f"Buy probability: {probabilities[0][1]}, Sell probability: {probabilities[0][0]}")
    if probabilities[0][1] >= buy_threshold:
        return 'buy'
    elif probabilities[0][0] >= sell_threshold:
        return 'sell'
    else:
        return 'watch'

def prediction_df(df):
    features = ['Open', 'High', 'Low', 'Close', 'Volatility']
    inp_df = pd.DataFrame({
        'Open': [df['Open'][-1]],
        'High': [df['High'][-1]],
        'Low': [df['Low'][-1]],
        'Close': [df['Close'][-1]],
        'Volatility': [df['Volatility'][-1]],
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
    })
    inp_df = inp_df[features]
    print(model.predict(inp_df)[0])
    probabilities = model.predict_proba(inp_df)
    print(probabilities)
    print(f"Probabilities: {probabilities}")
    action = determine_action(probabilities)
    return action

def test():
    df = load_data()
    X_train, X_test, y_train, y_test, features = split_data(df)
    
    # Model training with hyperparameter tuning
    model = train_model(X_train, y_train, X_test, y_test)
    
    # Model evaluation
    evaluate_model(model, X_test, y_test)
    evaluate_model_cv(model, X_train, y_train)
    
    user_inputs = get_user_inputs()
    pred_df = data.predict_btc()
    action = predict_action(model, user_inputs, features, pred_df)
    print(f"The model suggests to {action} based on the provided inputs.")
