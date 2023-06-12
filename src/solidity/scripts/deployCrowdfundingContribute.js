const { ethers } = require("hardhat");

async function main() {
  // Get the deployer account
  const [deployer] = await ethers.getSigners();

  console.log("Deploying Contribute contract with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy Crowdfunding contract
  const Crowdfunding = await ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy();

  // Deploy Contribute contract
  const Contribute = await ethers.getContractFactory("Contribute");
  const contribute = await Contribute.deploy(crowdfunding.address);

  console.log("Crowdfunding contract address:", crowdfunding.address);
  console.log("Contribute contract address:", contribute.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
