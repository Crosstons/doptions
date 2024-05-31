import { BrowserProvider, Contract, parseEther } from 'ethers';
import { erc20ABI } from '@/web3/ERC20ABI';

const amoyTokens = [
    '0xB1b104D79dE24513338bdB6CB9Df468110010E5F',
    '0x7A9294c8305F9ee1d245E0f0848E00B1149818C7',
    '0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841',
    '0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1'
]

const cardonaTokens = [
    '0x7A9294c8305F9ee1d245E0f0848E00B1149818C7',
    '0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841',
    '0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E',
    '0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b'
]

const scrollSepTokens = [
    '0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1',
    '0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841',
    '0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b',
    '0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E'
]

export const getTokens = async (address : any, walletProvider: any, chainId: any) => {
    if (!walletProvider) throw new Error('No wallet provider found');

    let tokenArray : any[];
    if(chainId == 80002) {
        tokenArray = amoyTokens;
    } else if(chainId == 2442) {
        tokenArray = cardonaTokens;
    } else {
        tokenArray = scrollSepTokens;
    }

    const ethersProvider = new BrowserProvider(walletProvider);
    const signer = await ethersProvider.getSigner();

    for(const i in tokenArray) {
        const erc20Contract = new Contract(tokenArray[i], erc20ABI, signer);
        const drip = await erc20Contract.mint(address, parseEther("100"));
        await drip.wait();
    }

    alert("Claimed Tokens From Faucet Successfully!");
}