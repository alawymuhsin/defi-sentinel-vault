const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const deployment = JSON.parse(fs.readFileSync("deployment.json", "utf8"));
  const [signer] = await hre.ethers.getSigners();
  const addr = await signer.getAddress();

  const vault = await hre.ethers.getContractAt("DeFiSentinelVault", deployment.contract);

  console.log("\n📊 DeFi Sentinel Vault - Status");
  console.log("================================");
  console.log("Contract:", deployment.contract);
  console.log("Owner:", await vault.owner());
  console.log("Total Staked:", hre.ethers.formatEther(await vault.totalStaked()), "IOPN");
  console.log("Reward Rate:", (await vault.rewardRate()).toString(), "basis points (5%)");
  console.log("Staker Count:", (await vault.getStakerCount()).toString());
  console.log("Contract Balance:", hre.ethers.formatEther(await vault.getContractBalance()), "IOPN");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
