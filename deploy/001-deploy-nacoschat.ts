import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { developmentChains } from "../helper-hardhat-config";
import { ethers, network } from "hardhat";
import verify from "../utils/verify";

const deployFunc: DeployFunction = async ({
  getNamedAccounts,
  deployments,
}: HardhatRuntimeEnvironment) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId!;
  const args: any = [];
  console.log(deployer);
  const nacoschat = await deploy("NacosChat", {
    from: deployer,
    args,
    log: true,
    waitConfirmations: 2,
  });
  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    log("Verifying...");
    await verify(nacoschat.address, args);
  }

  log("__________________________________");
};

export const tags = ["all", "nacoschat"];
export default deployFunc;
