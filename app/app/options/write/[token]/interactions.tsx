import { BrowserProvider, Contract, parseEther } from 'ethers';
import { optionFactoryABI } from '@/web3/OptionFactoryABI';
import { erc20ABI } from '@/web3/ERC20ABI';
import { putOptionABI } from '@/web3/PutOptionABI';
import { callOptionABI } from '@/web3/CallOptionABI';
import { usdtMapping } from '../../buy/interactions';

const amoyFactory = '0x4633BFBb343F131deF95ac1fd518Ed4495092063';
const scrollSepFactory = '0x6fA6089c99D07769c30dD0966315ea7C80ECe6FD';
const cardonaFactory = '0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1';

const amoyTokenMapping : { [key : string] : string } = {
    "bitcoin" : "0x7A9294c8305F9ee1d245E0f0848E00B1149818C7",
    "ethereum" : "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841",
    "link" : "0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1",
    "matic" : "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b",
    "solana" : "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E",
    "sand" : "0xAB5aBA3B6ABB3CdaF5F2176A693B3C012663B6c3"
}

const cardonaTokenMapping : { [key : string] : string } = {
    "bitcoin" : "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841",
    "ethereum" : "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E",
    "link" : "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b",
}

const scrollSepTokenMapping : { [key : string] : string } = {
    "bitcoin" : "0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841",
    "ethereum" : "0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E",
    "link" : "0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b",
}

export const createOptionCall = async (formData : any, walletProvider : any, chainId : any) => {
    if (!walletProvider) throw new Error('No wallet provider found');

    let factoryAddress : string;
    let addressTokenMapping : { [key : string] : string };

    const ethersProvider = new BrowserProvider(walletProvider);
    const signer = await ethersProvider.getSigner();

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

    const factoryContract = new Contract(factoryAddress, optionFactoryABI, signer);

    if(formData.type == "CALL") {

        const create = await factoryContract.createCallOption(addressTokenMapping[formData.token], parseEther(formData.premium), formData.strike, parseEther(formData.quantity), formData.unixExpiration);
        console.log(create);
        await create.wait();

        const callOptions = await factoryContract.getCallOptions();

        const assetContract = new Contract(addressTokenMapping[formData.token], erc20ABI, signer);
        const callContract = new Contract(callOptions[callOptions.length-1], callOptionABI, signer);
        
        const _approve = await assetContract.approve(callOptions[callOptions.length-1], parseEther(formData.quantity));
        console.log(_approve);
        await _approve.wait();

        const init = await callContract.init();
        console.log(init);
        await init.wait();
        
        alert("Call Option Created!");
    } else if(formData.type == "PUT") {
        const create = await factoryContract.createPutOption(addressTokenMapping[formData.token], parseEther(formData.premium), formData.strike, parseEther(formData.quantity), formData.unixExpiration);
        console.log(create);
        await create.wait();

        const callOptions = await factoryContract.getPutOptions();

        const assetContract = new Contract(usdtMapping[chainId], erc20ABI, signer);
        const putContract = new Contract(callOptions[callOptions.length-1], putOptionABI, signer);

        let _strikeValue = await putContract.strikeValue();
        
        const _approve = await assetContract.approve(callOptions[callOptions.length-1], _strikeValue);
        console.log(_approve);
        await _approve.wait();

        const init = await putContract.init();
        console.log(init);
        await init.wait();        

        alert("Put Option Created!");
    } else {
        alert("Invalid Interaction!");
        return "Invalid Interaction";
    }
}