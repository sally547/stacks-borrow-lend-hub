# 📦 Stacks Borrow-Lend Hub

**Stacks Borrow-Lend Hub** is a decentralized borrowing and lending smart contract built with [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview) for the [Stacks Blockchain](https://stacks.co/). This contract allows users to lend STX and SIP-010 tokens to earn interest, or borrow assets using collateral, all without relying on centralized intermediaries.

---

## 🚀 Features

- ✅ **Lending Pools**: Supply STX or SIP-010 tokens to earn yield
- ✅ **Borrowing Mechanism**: Borrow assets by locking collateral
- ✅ **Collateral Management**: Maintain safe collateral ratios
- ✅ **Interest Accrual**: Dynamic interest based on pool utilization
- ✅ **Liquidations**: Automatic liquidation of undercollateralized positions
- ✅ **Admin Controls**: Set interest rates, collateral factors, and more

---

## 📄 Contract Details

- **Contract Name**: `stacks-borrow-lend-hub`
- **Language**: Clarity
- **Chain**: Stacks 2.1+
- **Location**: `contracts/stacks-borrow-lend-hub.clar`

---

## 📁 Project Structure

```bash
├── contracts/
│   └── stacks-borrow-lend-hub.clar      # Main Clarity contract
├── tests/
│   └── borrow-lend-test.ts              # Integration tests with Clarinet
├── README.md                            # Project documentation
├── Clarinet.toml                        # Clarinet configuration
