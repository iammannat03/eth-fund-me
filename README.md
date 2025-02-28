# FundMe Smart Contract

A decentralized funding contract built with Solidity that allows users to send ETH and keeps track of funders. The contract ensures a minimum USD value for contributions using Chainlink Price Feeds.

## Overview

The FundMe contract is a crowdfunding smart contract with the following features:

- Accepts ETH payments with a minimum USD value threshold
- Tracks all funders and their contribution amounts
- Only the owner can withdraw the collected funds
- Uses Chainlink Price Feeds for accurate ETH/USD conversion
- Supports multiple network deployments (Mainnet, Sepolia, Local)

## Contract Details

### Key Features

- Minimum funding amount: 5 USD
- Automatic ETH/USD price conversion
- Owner-only withdrawal function
- Fallback and receive functions for direct ETH transfers
- Gas-optimized storage variables

### Smart Contracts

- `FundMe.sol`: Main contract for handling funds
- `PriceConverter.sol`: Library for ETH/USD price conversions
- `HelperConfig.s.sol`: Network configuration management
- `DeployFundMe.s.sol`: Deployment script

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/) installed on your machine

### Installation

1. Clone the repository
2. Install dependencies:

```shell
forge install
```

### Build

```shell
forge build
```

### Testing

Run the full test suite:

```shell
forge test
```

Run tests with gas reporting:

```shell
forge test --gas-report
```

### Deployment

Deploy to local network (Anvil):

```shell
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --private-key <your_private_key>
```

Deploy to Sepolia testnet:

```shell
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Network Configuration

The project supports multiple networks through the `HelperConfig.s.sol`:

- Ethereum Mainnet
- Sepolia Testnet
- Local Anvil Chain (with automated mock deployment)

## Testing

The test suite (`FundMeTest.t.sol`) includes:

- Unit tests for funding operations
- Withdrawal functionality tests
- Owner-only access control tests
- Multi-user funding scenarios
- Price feed integration tests

## License

This project is licensed under the MIT License.
