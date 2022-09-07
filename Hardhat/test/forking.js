/*
https://hardhat.org/hardhat-chai-matchers/docs/migrate-from-waffle
使用Hardhat的chai-matchers插件，可以使用chai的expect语法，而不是waffle的断言语法。

npm install --save-dev @nomicfoundation/hardhat-chai-matchers

require("@nomicfoundation/hardhat-chai-matchers");
*/

const {
    loadFixture, impersonateAccount
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
require("@nomicfoundation/hardhat-chai-matchers");

describe('forking', function () {
    async function setupFixture() {
        await resetToBlock(14390000)
    }

    async function resetToBlock(number) {
        await network.provider.request({
            method: "hardhat_reset",
            params: [
                {
                    forking: {
                        jsonRpcUrl: "https://rpc.ankr.com/eth",
                        blockNumber: number,
                    },
                },
            ],
        });
    }

    describe('queryBlance', function () {
        it('should get less balance than before', async function () {
            const vitalik_address = '0xd8da6bf26964af9d7eed9e03e53415d37aa96045'
            await resetToBlock(14488678);
            // vitalik.eth
            // 模拟其他钱包地址调用的两种方式 ethers.getImpersonatedSigner / helpers.impersonateAccount
            const vitalikSigner = await ethers.getImpersonatedSigner(vitalik_address)
            const vitalikBalance = await vitalikSigner.getBalance();
            // await helpers.impersonateAccount('0xd8da6bf26964af9d7eed9e03e53415d37aa96045');
            // const vitalikSigner = await ethers.getSigner(address);
            console.log(`before: ${vitalikBalance / 1e18} ETH`);

            await resetToBlock(15488678);
            await impersonateAccount(vitalik_address);
            const vitalikSigner2 = await ethers.getSigner(vitalik_address);
            const vitalikBalance_after = await vitalikSigner2.getBalance();
            console.log(`after : ${vitalikBalance_after / 1e18} ETH`);

            expect(vitalikBalance_after).to.be.lessThan(vitalikBalance);
        })
    })
})