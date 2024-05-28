import { BrowserProvider, Contract, formatUnits } from 'ethers';
import { optionFactoryABI } from '@/web3/OptionFactoryABI';

const factoryAddress = '0x4633BFBb343F131deF95ac1fd518Ed4495092063';

const addressTokenMapping : { [key : string] : string } = {
    "bitcoin" : "0x7A9294c8305F9ee1d245E0f0848E00B1149818C7",
    "ethereum" : "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841",
    "link" : "0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1",
    "matic" : "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b",
    "solana" : "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E",
    "sand" : "0xAB5aBA3B6ABB3CdaF5F2176A693B3C012663B6c3"
}

export const createOptionCall = (formData : any) => {
    if(formData.type == "CALL") {
        alert("Call Option Created!");
    } else if(formData.type == "PUT") {
        alert("Put Option Created!");
    } else {
        alert("Invalid Interaction!");
        return "Invalid Interaction";
    }
}