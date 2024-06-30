# dOptions

*Your Gateway to Truly Decentralized Options Trading*

- **[Video Demo](https://youtu.be/pI34tALAlQc)**
- **[Automation Demo](https://youtu.be/ZQf8cjNT3h0?si=6WNDQa5Ld4NJLhTd)**
- **[Code Walkthrough](https://youtu.be/anJyjkQ6W0g)**
- **[Live Website](https://doptions-plum.vercel.app/)**

## Overview
dOptions is a decentralized options protocol allowing users to create and trade options contracts with full customizability. It supports both CALL and PUT Options, offering unique features like Basket Options.

## Problem
Traditional financial markets have seen a significant increase in the volume of options traded, often surpassing the volume of equities. However, the current on-chain options protocols lack true decentralization and flexibility. Most existing solutions do not allow individual users to write their own options, and none offer the level of customizability that traders seek. This gap hinders the adoption and innovation of decentralized finance (DeFi) solutions in the options trading market.

## Solution
dOptions provides a comprehensive solution by enabling users to create and trade options on their own terms, thus ensuring true decentralization and customizability. Our protocol supports the creation and trading of both CALL and PUT Options along with Basket Options, allowing users to define their own strike prices, premiums, expiration dates, and quantities. This flexibility empowers users to tailor options contracts to their specific needs and trading strategies.

Additionally, dOptions plans to introduce advanced options types such as Rainbow Options and Barrier Options, further enhancing the trading experience. Our integration with Chainlink Price Feeds will ensure reliable and accurate price data, both on-chain and off-chain. This integration guarantees that all transactions are based on trustworthy and tamper-proof price information.

To cater to the growing demand for automated trading strategies, dOptions includes support for AI-driven automation clients. These clients enable users to implement and execute automated trading strategies, optimizing their trading activities and maximizing their returns. Our current basic automation client is available for users to try, with more advanced versions planned for future releases.

### Project Highlights
- **Fully Customizable Options**: Users can create CALL and PUT options with custom parameters.
- **Advanced Option Types**: Supports advanced options like Basket Options.
- **Automated Strategies**: Basic AI agent for automated trading strategies.
- **Cross-Chain Support**: Deployable on multiple EVM and non-EVM chains.

### Oracle Integration
- **Price Feeds**: Utilizes DIA Price Feed for accurate and reliable on-chain and off-chain price data on Linea Sepolia. We will migrate to ChainLink for Linea Mainnet.

## Team
We are experienced web3 developers with a history of building DeFi primitives across various chains. Our team, PsyCode Labs, is dedicated to creating next-gen, multi-chain products. Our lead developer holds a certificate in Decentralized Finance from Coursera.

## Roadmap
### July-August
- Enhance UI/UX
- Implement Basket Options & Secondary Marketplace frontend
- Support for EVM chains like Canto and Base

### September-October
- Expand option types
- Support for non-EVM chains like Starknet, ICP, Solana
- Fundraising for marketing & incentives

### November
- Soft launch
- Develop AMM-based secondary marketplace (V2)
- TBD

## Tech Stack
- **Foundry**: For smart contract development and testing.
- **NextJS**: For frontend development.
- **Giza**: For the AI Agent utilizing zkML.

## Installation Guide
### app (Next.js Project)
1. Navigate to the `app` directory.
2. Install dependencies: `npm install`
3. Run the development server: `npm run dev`

### cypher (Giza Agent)
1. Navigate to the `cypher` directory.
2. Install dependencies using `pip` listed in the `requirements.txt` file
3. Further steps in the README file inside the folder

### contracts (Foundry Project)
1. Navigate to the `contracts` directory.
2. Install Foundry: Follow [Foundry installation guide](https://book.getfoundry.sh/getting-started/installation.html)
3. Build contracts: `forge build`
4. Run tests: `forge test`

## Contract Addresses
### Linea Sepolia
- **Factory**: 0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b

---

Explore the future of decentralized options trading with dOptions!
