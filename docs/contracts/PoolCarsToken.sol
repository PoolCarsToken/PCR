
// ---------- contracts/PoolCarsToken.sol ----------
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PoolCarsToken is ERC20, Ownable {
    uint256 public maxTransferAmount;
    mapping(address => bool) private _isExcludedFromMaxTransfer;

    event MaxTransferUpdated(uint256 newMax);
    event ExcludedFromMaxTransfer(address indexed account, bool isExcluded);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        uint256 maxTransfer_,
        address owner_
    ) ERC20(name_, symbol_) Ownable(owner_) {
        require(owner_ != address(0), "Invalid owner");
        _mint(owner_, totalSupply_ * 10 ** decimals());
        require(maxTransfer_ > 0, "Invalid max");
        maxTransferAmount = maxTransfer_ * 10 ** decimals();
        _isExcludedFromMaxTransfer[owner_] = true;
    }

    function setMaxTransferAmount(uint256 newMax) external onlyOwner {
        require(newMax > 0, "Invalid max");
        maxTransferAmount = newMax * 10 ** decimals();
        emit MaxTransferUpdated(maxTransferAmount);
    }

    function excludeFromMaxTransfer(address account, bool excluded) external onlyOwner {
        require(account != address(0), "Invalid addr");
        _isExcludedFromMaxTransfer[account] = excluded;
        emit ExcludedFromMaxTransfer(account, excluded);
    }

    function isExcludedFromMaxTransfer(address account) external view returns (bool) {
        return _isExcludedFromMaxTransfer[account];
    }

    function _update(address from, address to, uint256 amount) internal override {
        super._update(from, to, amount);
        if (from != address(0) && to != address(0)) {
            if (!_isExcludedFromMaxTransfer[from] && !_isExcludedFromMaxTransfer[to]) {
                require(amount <= maxTransferAmount, "Max exceeded");
            }
        }
    }
}


// ---------- scripts/deploy.js ----------
// Deploy script para Hardhat (node.js)

const hre = require("hardhat");
  async function main() { ... } // {}
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  const PoolCars = await hre.ethers.getContractFactory("PoolCarsToken");

  // Ajuste os argumentos abaixo antes do deploy
  
  const name = "PoolCars";
  const symbol = "PCR";
  const totalSupply = hre.ethers.BigNumber.from("100000000000000"); // 100 trilhões (sem decimais)
  const maxTransfer = hre.ethers.BigNumber.from("1000000000"); // ex: 1.000.000.000 (sem decimais)
  const owner = deployer.address;
  const token = await PoolCars.deploy(name, symbol, totalSupply, maxTransfer, owner);
  await token.deployed();
  console.log("PoolCarsToken deployed to:", token.address);
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
{}


// ---------- hardhat.config.js ----------
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.20",
  networks: {
    localhost: {},
    hardhat: {},
    polygon: {
      url: process.env.POLYGON_RPC_URL || "",
      accounts: process.env.DEPLOYER_PRIVATE_KEY ? [process.env.DEPLOYER_PRIVATE_KEY] : [],
    },
    bsc: {
      url: process.env.BSC_RPC_URL || "",
      accounts: process.env.DEPLOYER_PRIVATE_KEY ? [process.env.DEPLOYER_PRIVATE_KEY] : [],
    }
  }
};


// ---------- package.json ----------
{
  "name": "poolcars-token",
  "version": "1.0.0",
  "description": "PoolCarsToken - smart contract e scripts",
  "scripts": {
    "compile": "npx hardhat compile",
    "deploy:localhost": "npx hardhat run scripts/deploy.js --network localhost",
    "deploy:hardhat": "npx hardhat run scripts/deploy.js --network hardhat",
    "deploy:polygon": "npx hardhat run scripts/deploy.js --network polygon",
    "deploy:bsc": "npx hardhat run scripts/deploy.js --network bsc",
    "test": "npx hardhat test"
  },
  "devDependencies": {
    "@nomiclabs/hardhat-ethers": "^3.0.0",
    "ethers": "^6.0.0",
    "hardhat": "^2.19.0",
    "dotenv": "^16.0.0"
  }
}


// ---------- .gitignore ----------
node_modules/
.env
cache/
artifacts/
coverage/


// ---------- .env.example ----------
# RPC endpoints and private key for deploy
POLYGON_RPC_URL=https://polygon-rpc.com
BSC_RPC_URL=https://bsc-dataseed.binance.org/
DEPLOYER_PRIVATE_KEY=0xYOUR_PRIVATE_KEY_HERE


// ---------- docs/PoolCarsToken.md (resumido) ----------
# PoolCarsToken

Token PoolCars (PCR) — documentação rápida.

## Deploy
- Contrato: contracts/PoolCarsToken.sol
- Script de deploy: scripts/deploy.js
- Compilador: Solidity 0.8.20

## Parâmetros sugeridos (ajuste antes do deploy)
- Nome: PoolCars
- Símbolo: PCR
- Fornecimento: 100000000000000 (100 trilhões)
- maxTransfer: 1000000000


// ---------- README.md (sugestão curta) ----------
# PoolCarsToken

Repositório com o contrato PoolCarsToken e scripts de deploy.

## Como usar
1. Copie `.env.example` para `.env` e preencha suas chaves.
2. `npm install`
3. `npm run compile`
4. `npm run deploy:polygon` (ou `deploy:bsc`)

---

# Instruções finais

1. Copie cada seção acima para os respectivos arquivos no seu repositório (mantenha a estrutura de pastas `contracts/`, `scripts/`, `docs/`).
2. No GitHub, adicione esses arquivos, commit e push.
3. Antes do deploy, **substitua** `DEPLOYER_PRIVATE_KEY` no `.env` pelo valor real (nunca compartilhe publicamente).
4. Se quiser, gero eu mesmo o arquivo `.zip` pronto para upload ou faço os commits se você me der instruções. 

Boa — quer que eu gere o `.zip` com esses arquivos agora? (Posso fornecer link para download).
