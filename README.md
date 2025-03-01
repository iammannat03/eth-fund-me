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

Or using Make:

```shell
make build
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

### Deployment & Interaction Commands

The project includes several Make commands for easy deployment and interaction:

#### Local Development (Anvil)

```shell
make anvil                    # Start local Anvil chain
```

On a separate terminal,

```shell
make deploy-anvil            # Deploy to Anvil
make fund-fundMe-anvil      # Fund the contract on Anvil
make withdraw-fundMe-anvil  # Withdraw from the contract on Anvil
```

#### Sepolia Testnet

```shell
make deploy-sepolia            # Deploy to Sepolia
make fund-fundMe-sepolia      # Fund the contract on Sepolia
make withdraw-fundMe-sepolia  # Withdraw from the contract on Sepolia
```

#### Mainnet

```shell
make deploy-mainnet            # Deploy to Mainnet
make fund-fundMe-mainnet      # Fund the contract on Mainnet
make withdraw-fundMe-mainnet  # Withdraw from the contract on Mainnet
```

Note: Make sure to set up your environment variables in `.env` file before using these commands.

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
