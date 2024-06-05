import Web3 from "web3";
import {diaABI} from './DiaInterfaceABI';
const web3 = new Web3("https://rpc.sepolia.linea.build/");

const diaContract = "0x533D3c1df8D238374065FB3341c34754e4BFCE8E";

export const priceBTC = async () => {
    const _priceFeed = new web3.eth.Contract(diaABI, diaContract)

    const _price : any = await _priceFeed.methods.getValue("BTC/USD").call();
    return (Number(_price[0]) / 10**8);
}

export const priceDIA = async () => {
    const _priceFeed = new web3.eth.Contract(diaABI, diaContract)

    const _price : any = await _priceFeed.methods.getValue("DIA/USD").call();
    return (Number(_price[0])/ 10**8);
}

export const priceMulti = async (token : string) => {
    if(token == "bitcoin") {
        return await priceBTC();
    } else if(token == "dia") {
        return await priceDIA();
    } else {
        return 0;
    }
}