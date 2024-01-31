import { ethers } from "hardhat";

export const networkConfig: Record<number, any> = {
  11155111: {
    name: "sepolia",
  },
  31337: {
    name: "hardhat",
  },
};

export const developmentChains = ["hardhat", "localhost"];
