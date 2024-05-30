import { BrowserProvider, Contract, formatUnits } from 'ethers';
import { optionFactoryABI } from '@/web3/OptionFactoryABI';
import { callOptionABI } from '@/web3/CallOptionABI';
import { putOptionABI } from '@/web3/PutOptionABI';
import { erc20ABI } from '@/web3/ERC20ABI';

const amoyFactory = '0x4633BFBb343F131deF95ac1fd518Ed4495092063';
const scrollSepFactory = '0x6fA6089c99D07769c30dD0966315ea7C80ECe6FD';
const cardonaFactory = '0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1';

export const usdtMapping : { [key : number] : string } = {
    80002 : "0xB1b104D79dE24513338bdB6CB9Df468110010E5F",
    2442 : "0x7A9294c8305F9ee1d245E0f0848E00B1149818C7",
    534351 : "0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1"
}

const amoyTokenMapping : { [key : string] : string } = {
    "0x7A9294c8305F9ee1d245E0f0848E00B1149818C7": "BTC",
    "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841": "ETH",
    "0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1": "LINK",
    "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b": "MATIC",
    "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E": "SOL",
    "0xAB5aBA3B6ABB3CdaF5F2176A693B3C012663B6c3": "SAND"
}

const cardonaTokenMapping : { [key : string] : string } = {
    "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841": "BTC",
    "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E": "ETH",
    "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b": "LINK"
}

const scrollSepTokenMapping : { [key : string] : string } = {
    "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841": "BTC",
    "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E": "ETH",
    "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b": "LINK"
}

export interface OptionData {
    contractAddr: string;
    tokenImg: string;
    strikePrice: string;
    premium: string;
    expirationDate: string;
    quantity: string;
}

const formatTimestamp = (timestamp: bigint): string => {
    const date = new Date(Number(timestamp) * 1000);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${day}/${month}/${year} ${hours}:${minutes}`;
}

export const getOptions = async (walletProvider : any, chainId : any) => {
    console.log(chainId);
//    if (!isConnected) throw Error('User disconnected')
    if (!walletProvider) throw new Error('No wallet provider found')
    
    let factoryAddress : string;
    let addressTokenMapping : { [key : string] : string };

    if(chainId == 80002) {
        factoryAddress = amoyFactory;
        addressTokenMapping = amoyTokenMapping;
    } else if(chainId == 2442) {
        factoryAddress = cardonaFactory;
        addressTokenMapping = cardonaTokenMapping;
    } else {
        factoryAddress = scrollSepFactory;
        addressTokenMapping = scrollSepTokenMapping;
    }

    const ethersProvider = new BrowserProvider(walletProvider)
    const signer = await ethersProvider.getSigner()

    const factoryContract = new Contract(factoryAddress, optionFactoryABI, signer)
    const callOptions = await factoryContract.getCallOptions()
    const putOptions = await factoryContract.getPutOptions()

    let data: { calls: OptionData[], puts: OptionData[] } = {
        calls: [],
        puts: []
    };

    for(const i in callOptions) {
        const _callContract = new Contract(callOptions[i], callOptionABI, signer)
        const _bought = await _callContract.bought()
        const _inited = await _callContract.inited()
        if(_inited && !_bought) { 
            const _asset = await _callContract.asset()
            let _strikePrice = await _callContract.strikePrice()
            _strikePrice = formatUnits(_strikePrice, 8)
            let _premium = await _callContract.premium()
            _premium = formatUnits(_premium, 18)
            let _expiration = await _callContract.expiration()
            _expiration = formatTimestamp(_expiration)
            let _quantity = await _callContract.quantity()
            _quantity = formatUnits(_quantity, 18)
            data.calls.push({contractAddr: callOptions[i], tokenImg: addressTokenMapping[_asset], strikePrice: _strikePrice, premium: _premium, expirationDate: _expiration, quantity: _quantity})
        }
    }

    for(const i in putOptions) {
        const _putContract = new Contract(putOptions[i], putOptionABI, signer)
        const _bought = await _putContract.bought()
        const _inited = await _putContract.inited()
        if(_inited && !_bought) { 
            const _asset = await _putContract.asset()
            let _strikePrice = await _putContract.strikePrice()
            _strikePrice = formatUnits(_strikePrice, 8)
            let _premium = await _putContract.premium()
            _premium = formatUnits(_premium, 18)
            let _expiration = await _putContract.expiration()
            _expiration = formatTimestamp(_expiration)
            let _quantity = await _putContract.quantity()
            _quantity = formatUnits(_quantity, 18)
            data.puts.push({contractAddr: putOptions[i], tokenImg: addressTokenMapping[_asset], strikePrice: _strikePrice, premium: _premium, expirationDate: _expiration, quantity: _quantity})
        }
    }

    return data
}

export const onBuy = async (walletProvider : any, chainId : any, optionAddr : string, call : boolean) => {
    try {
        if (!walletProvider) throw new Error('No wallet provider found');

        const ethersProvider = new BrowserProvider(walletProvider)
        const signer = await ethersProvider.getSigner()

        let optionContract : Contract;
        if(call) {
            optionContract = new Contract(optionAddr, callOptionABI, signer);
        } else {
            optionContract = new Contract(optionAddr, putOptionABI, signer);
        }

        let _premium = await optionContract.premium()
        
        const usdtContract = new Contract(usdtMapping[chainId], erc20ABI, signer);

        const _approve = await usdtContract.approve(optionAddr, _premium);
        console.log(_approve);
        await _approve.wait();

        const _buy = await optionContract.buy();
        console.log(_buy);
        await _buy.wait();
        alert("Option Bought Successfully!");
    } catch (error) {
        console.log(error);
        alert("Error, check console for details");
    }
  }