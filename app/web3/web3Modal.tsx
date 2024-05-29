"use client"

import { createWeb3Modal, defaultConfig } from '@web3modal/ethers/react'

const projectId = "def43d1c2ec1fb6d4df35ea7325dd752";

const amoy_testnet = {
    chainId: 80002,
    name: 'Polygon Amoy Testnet',
    currency: 'MATIC',
    explorerUrl: 'https://amoy.polygonscan.com/',
    rpcUrl: 'https://rpc-amoy.polygon.technology/'
}

const cardona_testnet = {
    chainId: 2442,
    name: 'Polygon zkEVM Cardona Testnet',
    currency: 'ETH',
    explorerUrl: 'https://cardona-zkevm.polygonscan.com/',
    rpcUrl: 'https://rpc.cardona.zkevm-rpc.com/'
}

const scroll_sepolia = {
    chainId: 534351,
    name: 'Scroll Sepolia',
    currency: 'ETH',
    explorerUrl: 'https://sepolia.scrollscan.com/',
    rpcUrl: 'https://sepolia-rpc.scroll.io/'
}

const zkSync_sepolia = {
    chainId: 300,
    name: 'zkSync Era Sepolia Testnet',
    currency: 'ETH',
    explorerUrl: 'https://sepolia.explorer.zksync.io/',
    rpcUrl: 'https://sepolia.era.zksync.dev/'
}

const metadata = {
    name: 'dOptions',
    description: 'A truly decentralized Options marketplace',
    url: 'http://localhost:3000',
    icons: ['https://avatars.localhost:3000/']
}

const ethersConfig = defaultConfig({
    metadata,
    enableEIP6963: true,
    enableInjected: true,
    enableCoinbase: true,
})

createWeb3Modal({
    ethersConfig,
    chains: [amoy_testnet, cardona_testnet, scroll_sepolia, zkSync_sepolia],
    projectId,
    enableAnalytics: true,
    enableOnramp: true
})

export function Web3Modal({ children } : any) {
    return children
}