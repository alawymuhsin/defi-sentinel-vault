import hre from "hardhat";
import fs from "fs";

async function main() {
  console.log("🚀 Deploying DeFiSentinelVault to OPN Chain Testnet...");
  console.log("Chain ID:", (await hre.ethers.provider.getNetwork()).chainId.toString());

  const [deployer] = await hre.ethers.getSigners();
  if (!deployer) {
    console.error("❌ No signer found! Check PRIVATE_KEY in .env");
    process.exit(1);
  }

  const addr = await deployer.getAddress();
  const balance = await hre.ethers.provider.getBalance(addr);
  console.log("Deployer:", addr);
  console.log("Balance:", hre.ethers.formatEther(balance), "IOPN");

  const Vault = await hre.ethers.getContractFactory("DeFiSentinelVault");
  const vault = await Vault.deploy();
  await vault.waitForDeployment();

  const address = await vault.getAddress();
  console.log("\n✅ DeFiSentinelVault deployed to:", address);
  console.log("\n📋 Next steps:");
  console.log("1. Fund the vault with IOPN for rewards:");
  console.log(`   npx hardhat run scripts/fund.js --network opn_testnet`);
  console.log("2. Verify on explorer:");
  console.log(`   npx hardhat verify --network opn_testnet ${address}`);
  console.log("\n🔗 Explorer:", `https://testnet.iopn.tech/address/${address}`);

  const deployment = {
    network: "opn_testnet",
    chainId: 984,
    contract: address,
    deployer: addr,
    timestamp: new Date().toISOString(),
    explorer: `https://testnet.iopn.tech/address/${address}`,
  };
  fs.writeFileSync("deployment.json", JSON.stringify(deployment, null, 2));
  console.log("\n📄 Deployment info saved to deployment.json");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
