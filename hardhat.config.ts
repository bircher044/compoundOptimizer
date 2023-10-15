import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

export default {
  solidity: {
    version: "0.8.20",
  },
  networks: {
    goerli: {
      url: `https://ethereum-goerli.publicnode.com`,
      accounts: process.env.PRIVATE_KEY
        ? [process.env.PRIVATE_KEY]
        : [],
      chainId: 5,
    },
    sepolia: {
      url: `https://ethereum-sepolia.blockpi.network/v1/rpc/public`,
      accounts: process.env.PRIVATE_KEY
        ? [process.env.PRIVATE_KEY]
        : [],
      chainId: 11155111,
    },
    arbitrumOne: {
      url: `https://arbitrum-mainnet.infura.io/v3/932eb986695b4f838d2fb6f011d7dfda`,
      accounts: process.env.PRIVATE_KEY
        ? [process.env.PRIVATE_KEY]
        : [],
      chainId: 42161,
    },
  },
  etherscan: {
    apiKey: {
      goerli: `${process.env.ETHERSCAN_API_KEY}`,
      polygon: `${process.env.POLYGONSCAN_API_KEY}`,
      arbitrumOne: `${process.env.ARBISCAN_API_KEY}`,
    },
  },
};
