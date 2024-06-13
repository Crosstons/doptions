import Web3 from "web3";
import {aggregatorV3InterfaceABI} from './ChainLinkInterface';
const web3 = new Web3("https://sepolia.base.org");

export const priceBTC = async () => {
    const _addr = "0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    return (Number(_price[1])/ 10**8);
}

export const priceETH = async () => {
    const _addr = "0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    return (Number(_price[1])/ 10**8);
}

export const priceLINK = async () => {
    const _addr = "0xb113F5A928BCfF189C998ab20d753a47F9dE5A61"
    const _priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, _addr)

    const _price : any = await _priceFeed.methods.latestRoundData().call();
    return (Number(_price[1])/ 10**8);
}

export const priceMulti = async (token : string) => {
    if(token == "bitcoin") {
        return await priceBTC();
    } else if(token == "ethereum") {
        return await priceETH();
    } else if(token == "link") {
        return await priceLINK();
    } else {
        return 0;
    }
}