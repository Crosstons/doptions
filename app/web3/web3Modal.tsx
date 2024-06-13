"use client"

import { createWeb3Modal, defaultConfig } from '@web3modal/ethers/react'

const projectId = "def43d1c2ec1fb6d4df35ea7325dd752";

const base_testnet = {
    chainId: 84532,
    name: 'Base Sepolia',
    currency: 'ETH',
    explorerUrl: 'https://sepolia.basescan.org/',
    rpcUrl: 'https://sepolia.base.org'
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
    chains: [base_testnet],
    projectId,
    enableAnalytics: true,
    enableOnramp: true
})

export function Web3Modal({ children } : any) {
    return children
}