const { ethers } = require("hardhat");

async function main() {
  // obtain the deployer account
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying Crowdfunding contract with the account:",
    deployer.address
  );
  console.log(
    "Balance of the account:",
    (await deployer.getBalance()).toString()
  );

  // deploy the Crowdfunding contract
  const Crowdfunding = await ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy(100, 3600); // adjust the values according to your needs

  console.log("Address of Crowdfunding contract:", crowdfunding.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
