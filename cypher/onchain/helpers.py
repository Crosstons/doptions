import os
from ape import Contract, networks
from dotenv import load_dotenv, find_dotenv
from web3 import Web3

load_dotenv(find_dotenv())

network_url = os.environ.get("PUBLIC_RPC")
networks.parse_network_choice(network_url).__enter__()

def approve_tokens(token_addr: str, spender: str, amt: int):
    try:
        erc20 = Contract(token_addr, abi="abi/erc20.json")
        tx = erc20.approve(spender, Web3.to_wei(amt, 'ether'))
        print("approve tx successful : ", tx)
        return True
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return False