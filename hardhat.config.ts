import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy";
import { config as dotenvConfig } from "dotenv";
dotenvConfig();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      accounts: [process.env.SEPOLIA_PRIVATE_KEY!],
      chainId: 11155111,
      url: process.env.ALCHEMY_URL!,
    },
  },
  etherscan: { apiKey: process.env.ETHERSCAN_API_KEY! },
  namedAccounts: {
    deployer: 0,
  },
};

export default config;
