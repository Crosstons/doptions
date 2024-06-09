import os
from dotenv import load_dotenv, find_dotenv
from onchain.addresses import USDT
from giza_logic.model import get_user_inputs, feature_engineering, prediction_df
from giza_logic.agent_helpers import create_agent, predict, get_pred_val
from datetime import datetime, timedelta
from twelveData import data
from onchain import fetch, helpers, options

load_dotenv(find_dotenv())
network_url = os.environ.get("PUBLIC_RPC")

def days_to_unix_timestamp(days_from_now: int) -> int:
    future_time = datetime.now() + timedelta(days=days_from_now)
    return int(future_time.timestamp())

def buy_option_agent(agent_id: int, amt: float, duration: int, account="doptions", chain=network_url):
    print("fetching data")
    fetched_df = feature_engineering(data.predict_btc())
    processed_df = prediction_df(fetched_df)
    contracts = {
        "usdt": USDT
    }
    agent = create_agent(agent_id, chain, contracts, account)
    result = predict(agent, processed_df)
    probabilities = get_pred_val(result)
    print(f"Buy probability: {probabilities[1]}, Sell probability: {probabilities[0]}")

    if probabilities[1] >= 0.6:
        with agent.execute() as contracts:
            print("Buying CALL")
            option = fetch.get_call_option(amt, days_to_unix_timestamp(duration))
            if option:
                helpers.approve_tokens(USDT, option[0], option[1])
                options.buy_option("CALL", option[0])
                return "Successfully Bought"
            else:
                print("no option available")
                return "watch"

    elif probabilities[0] >= 0.6:
        with agent.execute() as contracts:
            print("Buying PUT")
            option = fetch.get_put_option(amt, days_to_unix_timestamp(duration))
            if option:
                helpers.approve_tokens(USDT, option[0], option[1])
                options.buy_option("PUT", option[0])
                return "Successfully Bought"
            else:
                print("no option available")
                return "watch"
    else:
        print("watch!")
        return 'watch'

if __name__ == "__main__":
    print("getting user inputs")
    amount_to_invest, risk_profile, duration_of_investment = get_user_inputs()
    print("checking volatility")
    avg_volatility = data.avg_volatility()
    if risk_profile == 'low':
        if avg_volatility > 0.05:
            print("volatile market as per your risk profile")
        else:
            buy_option_agent(87, amt=amount_to_invest, duration=duration_of_investment)
    elif risk_profile == 'medium':
        if avg_volatility > 0.2:
            print("volatile market as per your risk profile")
        else:
            buy_option_agent(87, amt=amount_to_invest, duration=duration_of_investment)
    elif risk_profile == 'high':
        buy_option_agent(87, amt=amount_to_invest, duration=duration_of_investment)
    else:
        print("invalid input, try again")