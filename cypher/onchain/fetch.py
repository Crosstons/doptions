import os
from ape import Contract, networks
from datetime import datetime
from dotenv import load_dotenv, find_dotenv
from .addresses import FACTORY

load_dotenv(find_dotenv())

network_url = os.environ.get("INFURA_URL")
networks.parse_network_choice(network_url).__enter__()

def get_call_options(premium, max_expiration):
    try:
        options = []
        factory = Contract(FACTORY, abi="abi/factory.json")
        res = factory.getCallOptions()
        for i in res:
            option = Contract(address=i, abi="abi/callOption.json")
            inited = option.inited()
            if inited:
                executed = option.executed()
                if not executed:
                    bought = option.bought()
                    if not bought:
                        _expiration = option.expiration()
                        current_time = datetime.now()
                        expiration_time = datetime.fromtimestamp(_expiration)
                        if expiration_time > current_time and expiration_time < max_expiration:
                            _prem = option.premium() / 10**18
                            if _prem <= premium:
                                _strikePrice = option.strikePrice() / 10**8
                                options.append([i, _strikePrice])
        return options
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def get_put_options(premium, max_expiration):
    try:
        options = []
        factory = Contract(FACTORY, abi="abi/factory.json")
        res = factory.getPutOptions()
        for i in res:
            option = Contract(address=i, abi="abi/putOption.json")
            inited = option.inited()
            if inited:
                executed = option.executed()
                if not executed:
                    bought = option.bought()
                    if not bought:
                        _expiration = option.expiration()
                        current_time = datetime.now()
                        expiration_time = datetime.fromtimestamp(_expiration)
                        if expiration_time > current_time and expiration_time < max_expiration:
                            _prem = option.premium() / 10**18
                            if _prem <= premium:
                                _strikePrice = option.strikePrice() / 10**8
                                options.append([i, _strikePrice])
        return options
    except Exception as e:
        print(f"An error occurred: {str(e)}")