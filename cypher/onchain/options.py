import os
from ape import Contract, networks
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

network_url = os.environ.get("PUBLIC_RPC")
networks.parse_network_choice(network_url).__enter__()

def buy_option(option_type: str, option_addr: str):
    try:
        opt_contract = Contract(option_addr, abi="abi/callOption.json" if option_type == "CALL" else "abi/putOption.json")
        tx = opt_contract.buy()
        print("option bought, tx successful : ", tx)
        return True
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return False