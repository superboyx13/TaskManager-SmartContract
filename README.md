# TaskManager Smart Contract

A decentralized task management system built on Ethereum.

## Features

- ✅ Multi-user task management
- ✅ Priority levels (Low, Medium, High)
- ✅ CRUD operations
- ✅ Timestamp tracking
- ✅ Access control
- ✅ Comprehensive test suite

## Tech Stack

- Solidity ^0.8.19
- Foundry
- Sepolia Testnet

## Deployed Contract

[View on Etherscan](https://sepolia.etherscan.io/address/0xF764a40d2872Af0D84b012246D00214d19F72C18)

## Running Tests
```bash
forge test
```

## Deployment
```bash
forge create --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY src/TaskManager.sol:TaskManager --broadcast
```

## Coming Soon

- React frontend
- Enhanced UI/UX
- Additional features

## Author

[Divine Mensah] - [https://www.linkedin.com/in/divine-mensah-95503b314/] - [https://x.com/DivineMensah_]