/*
npx hardhat run scripts/deployUUPS.js --network rinkeby
deployed to 0x22192f8F076837Fa549C7873Af0E5Ac00424dAcd

npx hardhat verify --network rinkeby 0x22192f8F076837Fa549C7873Af0E5Ac00424dAcd "BoxUUPS"

Successfully verified contract BoxUUPS on Etherscan.
https://rinkeby.etherscan.io/address/0xA0B282899Df1a5300614Aa73BA75Dd180DA9fbF4#code
Verifying proxy: 0x22192f8F076837Fa549C7873Af0E5Ac00424dAcd
Contract at 0x22192f8F076837Fa549C7873Af0E5Ac00424dAcd already verified.
Linking proxy 0x22192f8F076837Fa549C7873Af0E5Ac00424dAcd with implementation
Successfully linked proxy to implementation.


实现合约: 0xA0B282899Df1a5300614Aa73BA75Dd180DA9fbF4
代理合约：0x22192f8F076837Fa549C7873Af0E5Ac00424dAcd

代理合约：ERC1967Proxy.sol 继承自Proxy.sol，本身没有什么逻辑，只用来转发调用
实现合约：通过继承UUPSUpgradeable实现了合约的升级功能。

跟Transparent相比，少了一个Admin合约，将合约升级的权限交给了实现合约本身。
*/


const hre = require("hardhat");

async function main() {
  const boxUUPS = await hre.ethers.getContractFactory("BoxUUPS");
  const boxContract = await hre.upgrades.deployProxy(boxUUPS, {kind: 'uups'});

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
