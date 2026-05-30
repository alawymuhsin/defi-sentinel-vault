import hre from "hardhat";
import fs from "fs";

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

  console.log("\n🥩 Staking 0.1 IOPN...");
  const stakeTx = await vault.stake({ value: hre.ethers.parseEther("0.1") });
  await stakeTx.wait();
  console.log("✅ Staked! TX:", stakeTx.hash);

  const pending = await vault.pendingReward(addr);
  console.log("\n💎 Pending Reward:", hre.ethers.formatEther(pending), "IOPN");

  console.log("\n🔗 View on Explorer:");
  console.log(`https://testnet.iopn.tech/address/${deployment.contract}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
