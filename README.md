# 🛡️ DeFi Sentinel Vault — OPN Chain Testnet

> Staking vault DeFi untuk IOPN Builders Programme Season 1 (DeFi & Open Finance)

## 📋 Overview

| Item | Detail |
|------|--------|
| Project | DeFi Sentinel Vault |
| Chain | OPN Chain Testnet |
| Chain ID | 984 |
| Currency | IOPN |
| RPC | https://testnet-rpc.iopn.tech |
| Explorer | https://testnet.iopn.tech |
| Features | Stake, Withdraw, Claim Rewards, 5% APR |

---

## 🚀 Step-by-Step Guide

### Step 1: Prerequisites

```bash
# Install Node.js (v18+)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify
node --version
npm --version
```

### Step 2: Setup Project

```bash
cd /root/.hermes/projects/iopn-defi-sentinel

# Install dependencies
npm install

# Copy env template
cp .env.example .env
```

### Step 3: Setup Wallet

1. Buka MetaMask / Rabby Wallet
2. Tambahkan OPN Chain Testnet:
   - Network Name: `OPN Chain Testnet`
   - RPC URL: `https://testnet-rpc.iopn.tech`
   - Chain ID: `984`
   - Currency Symbol: `IOPN`
   - Explorer: `https://testnet.iopn.tech`
3. Export private key dari wallet kamu
4. Edit `.env` file:
   ```
   PRIVATE_KEY=your_private_key_here
   ```

### Step 4: Get Testnet IOPN

Cek faucet OPN Chain testnet di:
- https://builders.iopn.tech (connect wallet dulu)
- Atau cek apakah ada faucet link di Discord IOPN

Minimal butuh ~0.5 IOPN untuk deploy + gas.

### Step 5: Compile Contract

```bash
npx hardhat compile
```

Output:
```
Compiled 1 Solidity file successfully
```

### Step 6: Deploy Contract

```bash
npx hardhat run scripts/deploy.js --network opn_testnet
```

Output:
```
🚀 Deploying DeFiSentinelVault to OPN Chain Testnet...
Deployer: 0xYourWallet
Balance: 1.0 IOPN

✅ DeFiSentinelVault deployed to: 0xContractAddress

📄 Deployment info saved to deployment.json
```

**SAVE the contract address!** Kamu butuh ini untuk verify dan frontend.

### Step 7: Verify Contract di Explorer

**Option A — Hardhat Verify (recommended):**
```bash
npx hardhat verify --network opn_testnet 0xContractAddress
```

**Option B — Manual Verify di OPNScan:**
1. Buka https://testnet.iopn.tech
2. Search contract address kamu
3. Klik tab "Contract" → "Verify & Publish"
4. Pilih:
   - Compiler Type: `Solidity (Single file)`
   - Compiler Version: `v0.8.20+commit.a1b79de6`
   - Open Source License: `MIT`
5. Paste isi file `contracts/DeFiSentinelVault.sol`
6. Klik "Verify & Publish"

**Option C — Flatten & Verify:**
```bash
# Flatten contract jadi single file
npx hardhat flatten > flattened.sol

# Lalu paste ke OPNScan manual verify
```

### Step 8: Fund Vault (untuk Rewards)

```bash
npx hardhat run scripts/fund.js --network opn_testnet
```

Ini mengirim 1 IOPN ke vault sebagai reward pool.

### Step 9: Test Interaksi

```bash
npx hardhat run scripts/interact.js --network opn_testnet
```

Ini akan:
- Stake 0.1 IOPN
- Cek pending rewards
- Print explorer link

### Step 10: Deploy Frontend (GRATIS)

**Option A — GitHub Pages (paling gampang):**

```bash
# 1. Update CONTRACT_ADDRESS di frontend/index.html
#    Ganti "0xYOUR_CONTRACT_ADDRESS_HERE" dengan address asli

# 2. Push ke GitHub
cd /root/.hermes/projects/iopn-defi-sentinel
git init
git add .
git commit -m "DeFi Sentinel Vault - OPN Chain"
git remote add origin https://github.com/alawymuhsin/defi-sentinel-vault.git
git push -u origin main

# 3. Enable GitHub Pages:
#    - Buka repo → Settings → Pages
#    - Source: Deploy from branch
#    - Branch: main, folder: /frontend
#    - Save

# 4. URL: https://alawymuhsin.github.io/defi-sentinel-vault
```

**Option B — Vercel (juga gratis):**

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel

# Ikuti prompts, URL: https://defi-sentinel-vault.vercel.app
```

### Step 11: Submit ke IOPN Builders

1. Buka https://builders.iopn.tech/dashboard/submit
2. Connect wallet (yang sama dengan deployer)
3. Isi form:
   - Project Name: `DeFi Sentinel Vault`
   - Description: `Security-first staking vault on OPN Chain. Multi-chain DeFi security & analytics toolkit with automated vulnerability scanning, rug pull detection, and real-time monitoring.`
   - Demo URL: `https://alawymuhsin.github.io/defi-sentinel-vault` (atau Vercel URL)
   - GitHub: `https://github.com/alawymuhsin/defi-sentinel-vault`
   - Contract: `0xContractAddress` (otomatis terdeteksi dari chain)
   - Season: `Season 1 · DeFi & Open Finance`
   - Theme: `DeFi & Open Finance`

---

## 📁 Project Structure

```
iopn-defi-sentinel/
├── contracts/
│   └── DeFiSentinelVault.sol    # Smart contract
├── scripts/
│   ├── deploy.js                # Deploy script
│   ├── fund.js                  # Fund vault script
│   └── interact.js              # Test interaction script
├── frontend/
│   └── index.html               # Web frontend (single file)
├── hardhat.config.js            # Hardhat config
├── package.json                 # Dependencies
├── .env.example                 # Environment template
└── README.md                    # This file
```

---

## ⚠️ Troubleshooting

### "Insufficient funds"
Cek balance wallet kamu. Butuh minimal 0.5 IOPN.

### "Cannot connect to RPC"
```bash
# Test RPC connection
curl -X POST https://testnet-rpc.iopn.tech   -H "Content-Type: application/json"   -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

### Verify gagal
Pastikan compiler version match: `v0.8.20+commit.a1b79de6`

### Frontend tidak bisa connect wallet
- Pastikan MetaMask sudah tambah OPN Chain (Chain ID 984)
- Update `CONTRACT_ADDRESS` di `index.html`

---

## 🔗 Links

- [IOPN Builders](https://builders.iopn.tech)
- [OPN Chain Explorer](https://testnet.iopn.tech)
- [ChainList](https://chainlist.org/chain/984)
- [DeFi Sentinel GitHub](https://github.com/alawymuhsin/defi-sentinel)

---

Built with 🛡️ DeFi Sentinel
