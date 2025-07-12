const hre = require("hardhat");

async function main() {
  const ConfidentialERC20 = await hre.ethers.getContractFactory("ConfidentialERC20");
  const contract = await ConfidentialERC20.deploy();
  
  await contract.deployed();
  console.log("ConfidentialERC20 deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
