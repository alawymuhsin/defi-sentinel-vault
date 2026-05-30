const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const deployment = JSON.parse(fs.readFileSync("deployment.json", "utf8"));
  console.log("💰 Funding vault at:", deployment.contract);

  const vault = await hre.ethers.getContractAt("DeFiSentinelVault", deployment.contract);
  const fundAmount = hre.ethers.parseEther("1.0");
  const tx = await vault.fundRewards({ value: fundAmount });
  await tx.wait();

  console.log("✅ Funded 1 IOPN for rewards!");
  console.log("TX Hash:", tx.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
