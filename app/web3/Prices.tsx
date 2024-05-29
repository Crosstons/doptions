import Web3 from "web3";
import {aggregatorV3InterfaceABI} from './ChainlinkInterfaceABI';
const web3 = new Web3("https://rpc-amoy.polygon.technology/");

export const priceBTC = async () => {
    const _addr = "0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    const _decimals = await _priceFeed.methods.decimals().call();
    return (Number(_price[1])/ 10**Number(_decimals));
}

export const priceETH = async () => {
    const _addr = "0xF0d50568e3A7e8259E16663972b11910F89BD8e7"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    const _decimals = await _priceFeed.methods.decimals().call();
    return (Number(_price[1])/ 10**Number(_decimals));
}

export const priceLINK = async () => {
    const _addr = "0xc2e2848e28B9fE430Ab44F55a8437a33802a219C"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    const _decimals = await _priceFeed.methods.decimals().call();
    return (Number(_price[1])/ 10**Number(_decimals));
}

export const priceMATIC = async () => {
    const _addr = "0x001382149eBa3441043c1c66972b4772963f5D43"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    const _decimals = await _priceFeed.methods.decimals().call();
    return (Number(_price[1])/ 10**Number(_decimals));
}

export const priceSOL = async () => {
    const _addr = "0xF8e2648F3F157D972198479D5C7f0D721657Af67"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    const _decimals = await _priceFeed.methods.decimals().call();
    return (Number(_price[1])/ 10**Number(_decimals));
}

export const priceSAND = async () => {
    const _addr = "0xeA8C8E97681863FF3cbb685e3854461976EBd895"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    const _decimals = await _priceFeed.methods.decimals().call();
    return (Number(_price[1])/ 10**Number(_decimals));
}

export const priceMulti = async (token : string) => {
    if(token == "solana") {
        return await priceSOL();
    } else if(token == "bitcoin") {
        return await priceBTC();
    } else if(token == "sand") {
        return await priceSAND();
    } else if(token == "ethereum") {
        return await priceETH();
    } else if(token == "link") {
        return await priceLINK();
    } else if(token == "matic") {
        return await priceMATIC();
    } else {
        return 0;
    }
}