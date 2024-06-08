from ape import Contract, networks
from datetime import datetime
from .addresses import FACTORY

def get_open_options():
    networks.parse_network_choice(f"https://rpc.sepolia.linea.build/").__enter__()
    try:
        temp = []
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
                        if expiration_time > current_time:
                            temp.append([i, "PUT"])
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
                        if expiration_time > current_time:
                            temp.append([i, "CALL"])
        print(temp)
    except Exception as e:
        print(f"An error occurred: {str(e)}")