-include .env

deploy-sepolia: 
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(S_RPC_URL) --account myassine --broadcast --verify --etherscan-api-key 