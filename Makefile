-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil deployBasicNftAnvil mintBasicNft deployMoodNft

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install openzeppelin-contracts --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deployBasicNftAnvil:
	@forge script script/DeployBasicNft.s.sol --rpc-url $(ANVIL_RPC_URL) --broadcast

mintBasicNft:
	@forge script script/Interactions.s.sol:MintBasicNft --rpc-url $(ANVIL_RPC_URL)

deployMoodNft:
	@forge script script/DeployMoodNft.s.sol:DeployMoodNft --rpc-url $(ANVIL_RPC_URL) --private-key $(DEFAULT_ANVIL_KEY) --broadcast
