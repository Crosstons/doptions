import time
import json
from web3 import Web3
from web3.middleware import geth_poa_middleware
from eth_account import Account
from datetime import datetime, timedelta

"""
    add your private key below to start using the automated strategy
"""
PRIVATE_KEY = ""

with open('automation/abi/chainlink.json', 'r') as abi_file:
    chainlink_abi = json.load(abi_file)

with open('automation/abi/factory.json', 'r') as abi_file:
    factory_abi = json.load(abi_file)

with open('automation/abi/callOption.json', 'r') as abi_file:
    call_abi = json.load(abi_file)

with open('automation/abi/putOption.json', 'r') as abi_file:
    put_abi = json.load(abi_file)

with open('automation/abi/erc20.json', 'r') as abi_file:
    erc20_abi = json.load(abi_file)

alchemy_url = "https://rpc-amoy.polygon.technology/"
web3 = Web3(Web3.HTTPProvider(alchemy_url))

FACTORY = "0x4633BFBb343F131deF95ac1fd518Ed4495092063"
USDT = "0xB1b104D79dE24513338bdB6CB9Df468110010E5F"

account = Account.from_key(PRIVATE_KEY)

web3.eth.default_account = account.address
web3.middleware_onion.inject(geth_poa_middleware, layer=0)

token_address = {
    "BTCUSD": "0x7A9294c8305F9ee1d245E0f0848E00B1149818C7",
    "ETHUSD": "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841",
    "LINKUSD": "0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1",
    "MATICUSD": "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b",
    "SOLUSD": "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E",
    "SANDUSD": "0xAB5aBA3B6ABB3CdaF5F2176A693B3C012663B6c3"
}

def get_price(asset: str) -> float:
    asset_addresses = {
        "BTCUSD": "0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f",
        "ETHUSD": "0xF0d50568e3A7e8259E16663972b11910F89BD8e7",
        "LINKUSD": "0xc2e2848e28B9fE430Ab44F55a8437a33802a219C",
        "MATICUSD": "0x001382149eBa3441043c1c66972b4772963f5D43",
        "SOLUSD": "0xF8e2648F3F157D972198479D5C7f0D721657Af67",
        "SANDUSD": "0xeA8C8E97681863FF3cbb685e3854461976EBd895"
    }
    
    addr = asset_addresses.get(asset)
    if not addr:
        raise ValueError("Invalid asset")
    
    contract = web3.eth.contract(address=addr, abi=chainlink_abi)
    latestData = contract.functions.latestRoundData().call()
    return latestData[1] / 10**8

def days_until_expiration(expiration_timestamp):
    current_time = datetime.now()
    expiration_time = datetime.fromtimestamp(expiration_timestamp)
    delta = expiration_time - current_time
    return delta.days

def days_to_unix_timestamp(days_from_now: int) -> int:
    future_time = datetime.now() + timedelta(days=days_from_now)
    return int(future_time.timestamp())

def buy_option(option_type: str, asset: str, premium_range: tuple, strike_price_range: tuple, expiration_range: tuple) -> bool:
    try:
        factory = web3.eth.contract(address=FACTORY, abi=factory_abi)
        ausdt = web3.eth.contract(address=USDT, abi=erc20_abi)

        if option_type == "CALL":
            options = factory.functions.getCallOptions().call()
        else:
            options = factory.functions.getPutOptions().call()

        for _opt in options:
            _optContract = web3.eth.contract(address=_opt, abi=call_abi if option_type == "CALL" else put_abi)
            _asset = _optContract.functions.asset().call()

            if _asset == token_address.get(asset):
                _expiration = days_until_expiration(_optContract.functions.expiration().call())
                _premium = web3.from_wei(_optContract.functions.premium().call(), 'ether')
                _strike_price = _optContract.functions.strikePrice().call() / 10**8

                if (expiration_range[0] <= _expiration <= expiration_range[1] and
                    premium_range[0] <= _premium <= premium_range[1] and
                    strike_price_range[0] <= _strike_price <= strike_price_range[1]):
                    
                    appr = ausdt.functions.approve(_opt, int(web3.to_wei(_premium, 'ether'))).build_transaction({ 'from': account.address, 'nonce': web3.eth.get_transaction_count(account.address), 'gas': 200000,'gasPrice': web3.to_wei('2', 'gwei') })
                    signed_appr = web3.eth.account.sign_transaction(appr, private_key=PRIVATE_KEY)
                    appr_hash = web3.eth.send_raw_transaction(signed_appr.rawTransaction)
                    web3.eth.wait_for_transaction_receipt(appr_hash)
                    print(f"Aprrove Tx: {appr_hash.hex()}")

                    tx = _optContract.functions.buy().build_transaction({ 'from': account.address, 'nonce': web3.eth.get_transaction_count(account.address),'gas': 200000, 'gasPrice': web3.to_wei('2', 'gwei') })
                    signed_tx = web3.eth.account.sign_transaction(tx, private_key=PRIVATE_KEY)
                    tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
                    web3.eth.wait_for_transaction_receipt(tx_hash)
                    print(f"Buy Option Tx: {tx_hash.hex()}")
                    print(f"Bought {option_type} option for {asset} with premium {_premium}, strike price {_strike_price}, and expiration {_expiration}")
                    return True
        print(f"No suitable {option_type} option found for {asset}")
        return False
    except Exception as e:
        return f"An error occurred: {str(e)}"

def write_option(option_type: str, asset: str, premium: float, quantity: float, strike_price: float, expiration: int) -> bool:
    try:
        factory = web3.eth.contract(address=FACTORY, abi=factory_abi)
        ausdt = web3.eth.contract(address=USDT, abi=erc20_abi)
        assetContract = web3.eth.contract(address=token_address[asset], abi=erc20_abi)

        if option_type == "CALL":
            create_txn = factory.functions.createCallOption(
                token_address[asset], 
                int(web3.to_wei(premium, 'ether')), 
                int(strike_price * 10**8), 
                int(quantity * 10**18), 
                days_to_unix_timestamp(expiration)
            ).build_transaction({
                'from': account.address, 
                'nonce': web3.eth.get_transaction_count(account.address),
                'gas': 2000000,
                'gasPrice': web3.to_wei('2', 'gwei')
            })

            signed_create_txn = web3.eth.account.sign_transaction(create_txn, private_key=PRIVATE_KEY)
            create_txn_hash = web3.eth.send_raw_transaction(signed_create_txn.rawTransaction)
            web3.eth.wait_for_transaction_receipt(create_txn_hash)
            print(f"Create Option Tx: {create_txn_hash.hex()}")

            created_option_address = factory.functions.getCallOptions().call()[-1]
            optContract = web3.eth.contract(address=created_option_address, abi=call_abi)
            
            appr = assetContract.functions.approve(created_option_address, int(quantity * 10**18)).build_transaction({ 'from': account.address, 'nonce': web3.eth.get_transaction_count(account.address), 'gas': 200000 ,'gasPrice': web3.to_wei('2', 'gwei') })
            signed_appr = web3.eth.account.sign_transaction(appr, private_key=PRIVATE_KEY)
            appr_hash = web3.eth.send_raw_transaction(signed_appr.rawTransaction)
            web3.eth.wait_for_transaction_receipt(appr_hash)
            print(f"Aprrove Tx: {appr_hash.hex()}")

            init_txn = optContract.functions.init().build_transaction({ 'from': account.address, 'nonce': web3.eth.get_transaction_count(account.address),'gas': 200000, 'gasPrice': web3.to_wei('2', 'gwei') })
            signed_init = web3.eth.account.sign_transaction(init_txn, private_key=PRIVATE_KEY)
            init_txn_hash = web3.eth.send_raw_transaction(signed_init.rawTransaction)
            web3.eth.wait_for_transaction_receipt(init_txn_hash)
            print(f"Init Option Tx: {init_txn_hash.hex()}")

        else:
            create_txn = factory.functions.createPutOption(
                token_address[asset], 
                int(web3.to_wei(premium, 'ether')), 
                int(strike_price * 10**8),
                int(quantity * 10**18), 
                days_to_unix_timestamp(expiration)
            ).build_transaction({
                'from': account.address, 
                'nonce': web3.eth.get_transaction_count(account.address),
                'gas': 2000000,
                'gasPrice': web3.to_wei('2', 'gwei')
            })

            signed_create_txn = web3.eth.account.sign_transaction(create_txn, private_key=PRIVATE_KEY)
            create_txn_hash = web3.eth.send_raw_transaction(signed_create_txn.rawTransaction)
            web3.eth.wait_for_transaction_receipt(create_txn_hash)
            print(f"Create Option Tx: {create_txn_hash.hex()}")

            created_option_address = factory.functions.getPutOptions().call()[-1]
            optContract = web3.eth.contract(address=created_option_address, abi=put_abi)

            strikeValue = optContract.functions.strikeValue().call()
            appr = ausdt.functions.approve(created_option_address, strikeValue).build_transaction({ 'from': account.address, 'nonce': web3.eth.get_transaction_count(account.address), 'gas': 200000 ,'gasPrice': web3.to_wei('2', 'gwei') })
            signed_appr = web3.eth.account.sign_transaction(appr, private_key=PRIVATE_KEY)
            appr_hash = web3.eth.send_raw_transaction(signed_appr.rawTransaction)
            web3.eth.wait_for_transaction_receipt(appr_hash)
            print(f"Aprrove Tx: {appr_hash.hex()}")

            init_txn = optContract.functions.init().build_transaction({ 'from': account.address, 'nonce': web3.eth.get_transaction_count(account.address),'gas': 200000, 'gasPrice': web3.to_wei('2', 'gwei') })
            signed_init = web3.eth.account.sign_transaction(init_txn, private_key=PRIVATE_KEY)
            init_txn_hash = web3.eth.send_raw_transaction(signed_init.rawTransaction)
            web3.eth.wait_for_transaction_receipt(init_txn_hash)
            print(f"Init Option Tx: {init_txn_hash.hex()}")

        print(f"Written {option_type} option for {asset} with premium {premium}, strike price {strike_price}, quantity {quantity}, and expiration {expiration}")
        return True
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return False

def get_valid_input(prompt, valid_range):
    while True:
        try:
            value = int(input(prompt))
            if value in valid_range:
                return value
            else:
                print(f"Please enter a number between {valid_range.start} and {valid_range.stop - 1}.")
        except ValueError:
            print("Invalid input. Please enter a number.")

def main():
    assets = ["BTCUSD", "ETHUSD", "LINKUSD"]
    print("Select an asset:")
    for i, asset in enumerate(assets):
        print(f"{i + 1}. {asset}")

    asset_index = get_valid_input("Enter number: ", range(1, len(assets) + 1)) - 1
    selected_asset = assets[asset_index]
    print(f"Selected asset: {selected_asset}")
    print("")
    print("")
    print("Select condition:")
    print("1. Price rises above")
    print("2. Price drops below")
    print("3. Price is in range")

    condition = get_valid_input("Enter number: ", range(1, 4))

    if condition == 3:
        price = float(input("Enter lower price: "))
        price2 = float(input("Enter higher price: "))
        print(f"Selected condition: Range ({price}, {price2})")
        print("")
        print("")
    else:
        price = float(input("Enter price: "))
        if condition == 1:
            print(f"Selected condition: Price rises above {price}")
        else:
            print(f"Selected condition: Price drops below {price}")
        print("")
        print("")

    print("Do you want to buy or write an option?")
    print("1. Buy")
    print("2. Write")

    action = get_valid_input("Enter number: ", range(1, 3))

    option_type = input("Enter option type (CALL/PUT): ").upper()

    if action == 1:
        premium_range = tuple(map(float, input("Enter premium range (min max): ").split()))
        strike_price_range = tuple(map(float, input("Enter strike price range (min max): ").split()))
        expiration_range = tuple(map(int, input("Enter expiration range (days) (min max): ").split()))
    else:
        premium = float(input("Enter premium: "))
        quantity = float(input("Enter quantity: "))
        strike_price = float(input("Enter strike price: "))
        expiration = int(input("Enter expiration (days): "))

    while True:
        try:
            current_price = get_price(selected_asset)
            print(f"Current price: {current_price}")

            if condition == 1 and current_price > price:
                if action == 1:
                    result = buy_option(option_type, selected_asset, premium_range, strike_price_range, expiration_range)
                else:
                    result = write_option(option_type, selected_asset, premium, quantity, strike_price, expiration)
                if result:
                    print("---------------------------------------------------------------------------")
                    print("Task Completed!")
                    break
            elif condition == 2 and current_price < price:
                if action == 1:
                    result = buy_option(option_type, selected_asset, premium_range, strike_price_range, expiration_range)
                else:
                    result = write_option(option_type, selected_asset, premium, quantity, strike_price, expiration)
                if result:
                    print("---------------------------------------------------------------------------")
                    print("Task Completed!")
                    break
            elif condition == 3 and price <= current_price <= price2:
                if action == 1:
                    result = buy_option(option_type, selected_asset, premium_range, strike_price_range, expiration_range)
                else:
                    result = write_option(option_type, selected_asset, premium, quantity, strike_price, expiration)
                if result:
                    print("---------------------------------------------------------------------------")
                    print("Task Completed!")
                    break

            time.sleep(30)
        except ValueError as e:
            print(e)

if __name__ == "__main__":
    main()