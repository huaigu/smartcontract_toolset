/*
npx hardhat run scripts/deployTransparentProxy.js --network rinkeby
deployed to 0xb5Bc82cDeA6DE981973949f40316F4f0E1901600

npx hardhat verify --network rinkeby 0xb5Bc82cDeA6DE981973949f40316F4f0E1901600 "BoxTransparentProxy"

Successfully verified contract BoxTransparentProxy on Etherscan.
https://rinkeby.etherscan.io/address/0xB4b419340303486BcE74e73BcEF7c55531F8aD8d#code

Verifying proxy: 0xb5Bc82cDeA6DE981973949f40316F4f0E1901600
Contract at 0xb5Bc82cDeA6DE981973949f40316F4f0E1901600 already verified.
Linking proxy 0xb5Bc82cDeA6DE981973949f40316F4f0E1901600 with implementation

Successfully linked proxy to implementation.
Verifying proxy admin: 0x69cf464a9fE47D312ede2C525051B33d8E2b7273
Contract at 0x69cf464a9fE47D312ede2C525051B33d8E2b7273 already verified.


实现合约: 0xB4b419340303486BcE74e73BcEF7c55531F8aD8d
Proxy合约: 0xb5Bc82cDeA6DE981973949f40316F4f0E1901600
Admin合约: 0x69cf464a9fE47D312ede2C525051B33d8E2b7273

Admin合约： ProxyAdmin.sol 继承自TransparentUpgradeableProxy.sol 用来管理admin的变更逻辑，转发合约升级，delegatecall。
Proxy合约： TransparentUpgradeableProxy.sol 继承自ERC1967Proxy.sol, 用来实现透明代理的逻辑，delegatecall到实现合约，以及实现合约的升级逻辑。他没有external的方法对外暴露，只允许来自admin的call。
*/
const hre = require("hardhat");

async function main() {
  const boxTransparent = await hre.ethers.getContractFactory("BoxTransparentProxy");
  const boxContract = await hre.upgrades.deployProxy(boxTransparent);

  await boxContract.deployed();

  console.log(
    `deployed to ${boxContract.address}`
  );

  const name = await boxContract.name();
  console.log(
    `box name is ${name}`
  );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
