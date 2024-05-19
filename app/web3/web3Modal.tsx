"use client"

import { createWeb3Modal, defaultConfig } from '@web3modal/ethers/react'

const projectId = "def43d1c2ec1fb6d4df35ea7325dd752";

const amoy_testnet = {
    chainId: 80002,
    name: 'Polygon Amoy',
    currency: 'MATIC',
    explorerUrl: 'https://amoy.polygonscan.com/',
    rpcUrl: 'https://rpc-amoy.polygon.technology'
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
    chains: [amoy_testnet],
    projectId,
    enableAnalytics: true,
    enableOnramp: true
})

export function Web3Modal({ children }) {
    return children
}

export default function ConnectButton() {
    return <w3m-button />
}