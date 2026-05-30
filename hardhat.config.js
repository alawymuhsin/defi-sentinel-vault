import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-verify";
import "dotenv/config";

const config = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    opn_testnet: {
      url: "https://testnet-rpc.iopn.tech",
      chainId: 984,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      gasPrice: "auto",
    },
  },
  etherscan: {
    apiKey: {
      opn_testnet: "empty",
    },
    customChains: [
      {
        network: "opn_testnet",
        chainId: 984,
        urls: {
          apiURL: "https://testnet.iopn.tech/api",
          browserURL: "https://testnet.iopn.tech",
        },
      },
    ],
  },
};

export default config;
