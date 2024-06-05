import { BrowserProvider, Contract, parseEther } from 'ethers';
import { erc20ABI } from '@/web3/ERC20ABI';

const tokenArray = [
    '0x7A9294c8305F9ee1d245E0f0848E00B1149818C7',
    '0x817BB339d55A0a66EA680EE849a931416b575Ff2',
]

export const getTokens = async (address : any, walletProvider: any) => {
    if (!walletProvider) throw new Error('No wallet provider found');
    
    const ethersProvider = new BrowserProvider(walletProvider);
    const signer = await ethersProvider.getSigner();

    for(const i in tokenArray) {
        const erc20Contract = new Contract(tokenArray[i], erc20ABI, signer);
        const drip = await erc20Contract.mint(address, parseEther("1000"));
        await drip.wait();
    }

    alert("Claimed Tokens From Faucet Successfully!");
}