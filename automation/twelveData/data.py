import requests
import numpy as np
import pandas as pd
from datetime import datetime, timedelta
from sklearn.linear_model import LinearRegression

def avg_volatility():

    # starting and ending dates for calling the API
    _now = datetime.now()
    currentDate = _now.strftime('%Y-%m-%d')
    startDate = (_now - timedelta(days=30)).strftime('%Y-%m-%d')

    # API call and converting the received data into json
    raw = requests.get(f"https://api.twelvedata.com/time_series?apikey=f81ecba5955846bc8d7d9bc2589a05ff&interval=1h&type=none&symbol=BTC/USD&dp=4&start_date={startDate}&end_date={currentDate}")
    raw = raw.json()

    # creating a list of difference between highs and lows for each day
    lengths = []
    for i in raw['values']:
        lengths.append(float(i['high']) - float(i['low']))

    # returining the average difference (volatility)
    return np.array(lengths).mean()

def current_btc():

    # API call and converting the received data into json
    raw = requests.get("https://api.twelvedata.com/time_series?apikey=f81ecba5955846bc8d7d9bc2589a05ff&interval=1h&type=none&symbol=BTC/USD&dp=4&outputsize=1&previous_close=true")
    raw = raw.json()

    # returining the close price
    return (float(raw['values'][0]['close']), float(raw['values'][0]['previous_close']))

def moving_averages():

    # starting and ending dates for calling the API
    _now = datetime.now()
    currentDate = _now.strftime('%Y-%m-%d')
    startDate = (_now - timedelta(days=30)).strftime('%Y-%m-%d')

    # API call and converting the received data into json
    raw = requests.get(f"https://api.twelvedata.com/ma?apikey=f81ecba5955846bc8d7d9bc2589a05ff&interval=1h&symbol=BTC/USD&dp=4&start_date={startDate}&end_date={currentDate}")
    raw = raw.json()

    # convert json to dataframe and data preparations
    df = pd.DataFrame(raw['values'])
    df['datetime'] = pd.to_datetime(df['datetime'])
    df['ma'] = df['ma'].astype(float)
    df = df.sort_values(by='datetime')
    df['timestamp'] = df['datetime'].map(pd.Timestamp.timestamp)
    X = df['timestamp'].values.reshape(-1, 1)
    y = df['ma'].values

    # initialize and fit the model
    model = LinearRegression()
    model.fit(X, y)

    # prediction input preparation
    input_timestamp = pd.to_datetime(round_up_to_next_hour(_now).strftime('%Y-%m-%d %H:00:00'))
    input_timestamp = input_timestamp.timestamp()
    input_timestamp = np.array(input_timestamp).reshape(-1, 1)

    predicted_ma = model.predict(input_timestamp)
    
    return predicted_ma[0]


def round_up_to_next_hour(dt):
    if dt.minute != 0 or dt.second != 0:
        dt = dt + timedelta(hours=1)
        dt = dt.replace(minute=0, second=0, microsecond=0)
    else:
        dt = dt.replace(second=0, microsecond=0)
    return dt