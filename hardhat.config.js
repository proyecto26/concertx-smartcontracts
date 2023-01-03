require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-waffle");
require("dotenv").config()

const MUMBAI_RPC_URL =
  process.env.MUMBAI_RPC_URL

const PRIVATE_KEY = 
  process.env.PRIVATE_KEY

module.exports = {
  solidity: "0.8.17",
  paths: {
    artifacts: "./src/smartcontracts-solidity/artifacts",
    sources: "./src/smartcontracts-solidity/contracts",
    cache: "./src/smartcontracts-solidity/cache",
    tests: "./src/smartcontracts-solidity/test"
    },
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
    chainId: 1337 // We set 1337 to make interacting with MetaMask simpler
    },
    mumbai: {
    url: MUMBAI_RPC_URL,
    accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
  },
};