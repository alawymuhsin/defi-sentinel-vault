# 🛡️ DeFi Sentinel Vault — OPN Chain Testnet

> A non-custodial staking vault built for the IOPN Builders Programme Season 1 (DeFi & Open Finance)

## Live Demo

**Web App:** [alawymuhsin.github.io/defi-sentinel-vault](https://alawymuhsin.github.io/defi-sentinel-vault/)

**Contract:** [0x74D35B307c0652762669b351AD208a3538239A9e](https://testnet.iopn.tech/address/0x74D35B307c0652762669b351AD208a3538239A9e#code) (Verified)

---

## Overview

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

## Features

- **Stake IOPN** — deposit tokens into the vault and start earning
- **Withdraw** — withdraw staked tokens at any time
- **Claim Rewards** — accumulated rewards claimable per block
- **5% APR** — configurable by owner (up to 50%)
- **Reward Pool** — owner can fund the vault with IOPN for reward distribution
- **Web Frontend** — MetaMask/Rabby wallet integration with auto network switching

---

## Quick Start

### Prerequisites

- Node.js v18+
- MetaMask or Rabby Wallet
- IOPN testnet tokens (for gas)

### Install & Deploy

```bash
# Clone the repository
git clone https://github.com/alawymuhsin/defi-sentinel-vault.git
cd defi-sentinel-vault

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env and add your private key (without 0x prefix)

# Compile
npx hardhat compile

# Deploy to OPN Chain Testnet
npx hardhat run scripts/deploy.js --network opn_testnet

# Verify contract on OPNScan
npx hardhat verify --network opn_testnet <CONTRACT_ADDRESS>

# Fund vault with rewards
npx hardhat run scripts/fund.js --network opn_testnet
```

### Add OPN Chain to Wallet

| Field | Value |
|-------|-------|
| Network Name | OPN Chain Testnet |
| RPC URL | https://testnet-rpc.iopn.tech |
| Chain ID | 984 |
| Currency Symbol | IOPN |
| Explorer | https://testnet.iopn.tech |

---

## Project Structure

```
defi-sentinel-vault/
├── contracts/
│   └── DeFiSentinelVault.sol    # Solidity smart contract
├── scripts/
│   ├── deploy.js                # Deployment script
│   ├── fund.js                  # Fund reward pool
│   └── interact.js              # Test interactions
├── frontend/
│   └── index.html               # Web frontend (single file)
├── docs/
│   └── index.html               # GitHub Pages deployment
├── hardhat.config.js            # Hardhat configuration
├── package.json
├── .env.example                 # Environment template
└── README.md
```

---

## Smart Contract

**DeFiSentinelVault.sol** — Solidity 0.8.20

### Core Functions

| Function | Description |
|----------|-------------|
| `stake()` | Stake IOPN tokens (payable) |
| `withdraw(amount)` | Withdraw staked tokens |
| `claimReward()` | Claim accumulated rewards |
| `pendingReward(address)` | View pending rewards |
| `totalStaked()` | Total tokens staked in vault |
| `getStakerCount()` | Number of active stakers |
| `getContractBalance()` | Vault IOPN balance |
| `fundRewards()` | Owner funds reward pool |

### Events

- `Staked(address indexed user, uint256 amount)`
- `Withdrawn(address indexed user, uint256 amount)`
- `RewardClaimed(address indexed user, uint256 reward)`
- `RewardRateUpdated(uint256 newRate)`

---

## Roadmap

**Phase 1 — Launch (May 2026)**
- Deploy staking vault on OPN Chain Testnet
- Web frontend with wallet integration
- Contract verified on OPNScan

**Phase 2 — Expansion (Q3 2026)**
- Multi-token staking support (ERC-20)
- Tiered pools with flexible lock periods (7d, 30d, 90d)
- Analytics dashboard: TVL history, reward projections, APY calculator

**Phase 3 — Security Suite (Q4 2026)**
- Integrate DeFi Sentinel scanner: token safety, honeypot detection, rug pull alerts
- On-chain audit reports from the vault UI
- MEV protection for staking transactions

**Phase 4 — Ecosystem (Q1 2027)**
- Governance module for staker voting
- Cross-chain bridge integration (Ethereum, Base, Arbitrum → OPN Chain)
- SDK for OPN Chain builders to integrate DeFi Sentinel security checks

---

## Troubleshooting

**"Insufficient funds"**
Check wallet balance. Minimum 0.5 IOPN required for deploy + gas.

**"Cannot connect to RPC"**
```bash
curl -X POST https://testnet-rpc.iopn.tech \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

**Verify failed**
Ensure compiler version matches: `v0.8.20+commit.a1b79de6`

**Frontend won't connect wallet**
- Add OPN Chain to MetaMask (Chain ID 984)
- Update `CONTRACT_ADDRESS` in `index.html`

---

## Links

- [IOPN Builders Programme](https://builders.iopn.tech)
- [OPN Chain Explorer](https://testnet.iopn.tech)
- [ChainList — OPN Chain](https://chainlist.org/chain/984)
- [DeFi Sentinel Toolkit](https://github.com/alawymuhsin/defi-sentinel)

---

Built with 🛡️ [DeFi Sentinel](https://github.com/alawymuhsin/defi-sentinel)
