-include .env

.PHONY: anvil test coverage

build:; forge build

test:
	forge test

coverage:
	forge coverage

snapshot:
	forge snapshot

deploy-anvil:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy-mainnet:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(MAINNET_RPC_URL) --private-key $(MAINNET_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

anvil: 
	anvil

fund-fundMe-anvil:
	forge script script/Interactions.s.sol:FundFundMe --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast

fund-fundMe-sepolia:
	forge script script/Interactions.s.sol:FundFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast

fund-fundMe-mainnet:
	forge script script/Interactions.s.sol:FundFundMe --rpc-url $(MAINNET_RPC_URL) --private-key $(MAINNET_PRIVATE_KEY) --broadcast

withdraw-fundMe-anvil:
	forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast

withdraw-fundMe-sepolia:
	forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast

withdraw-fundMe-mainnet:
	forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(MAINNET_RPC_URL) --private-key $(MAINNET_PRIVATE_KEY) --broadcast

