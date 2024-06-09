import os
from ape import Contract, networks
from datetime import datetime
from dotenv import load_dotenv, find_dotenv
from .addresses import FACTORY
from twelveData import data

load_dotenv(find_dotenv())

network_url = os.environ.get("INFURA_URL")
networks.parse_network_choice(network_url).__enter__()

def get_call_option(premium, max_expiration):
    try:
        curr_price = data.get_curr_btc()
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
                                _quantity = option.quantity() / 10**18
                                _cost = ((_strikePrice - curr_price) * _quantity) + _prem
                                options.append([i, _prem, _cost])
        for i in options:
            _min = 0
            temp = []
            if i[2] < _min:
                _min = i[2]
                temp = i
        return temp
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def get_put_option(premium, max_expiration):
    try:
        curr_price = data.get_curr_btc()
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
                                _quantity = option.quantity() / 10**18
                                _cost = ((curr_price - _strikePrice) * _quantity) + _prem
                                options.append([i, _strikePrice, _prem, _quantity])
        for i in options:
            _min = 0
            temp = []
            if i[2] < _min:
                _min = i[2]
                temp = i
        return temp
    except Exception as e:
        print(f"An error occurred: {str(e)}")