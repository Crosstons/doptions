import { BrowserProvider, Contract, parseEther } from 'ethers';
import { erc20ABI } from '@/web3/ERC20ABI';

const tokenArray = [
    '0x10Cbc80974281fE66f41C26cA69490820432FaA2',
    '0x01aa350e8A61EF1134773B2c69AcCFD0Eceb6a4F',
    '0xDd5E5A90B2FB4312439Df8ae213FD99D5f1796D9',
    '0x214757038fdB549B1E46774d006CFba35667Ff1E'
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