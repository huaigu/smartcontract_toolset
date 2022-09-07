/*
https://hardhat.org/hardhat-network-helpers/docs/reference#

Hardhat Network Helpers
介绍几个常用的方法
*/

const {
    time, loadFixture, takeSnapshot
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
require("@nomicfoundation/hardhat-chai-matchers");

describe('hardhat_network_helper', function () {
    async function deployContractsFixture() {
        const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
        const ONE_GWEI = 1_000_000_000;

        const lockedAmount = ONE_GWEI;
        const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

        const [owner] = await ethers.getSigners();

        const Lock = await ethers.getContractFactory("Lock");
        const lockContract = await Lock.deploy(unlockTime, { value: lockedAmount });

        return { lockContract, owner, unlockTime }
    }

    describe('deployContractsFixture', function () {
        it('Should set the right owner', async function () {
            const { lockContract, owner } = await loadFixture(deployContractsFixture);
            expect(await lockContract.owner()).to.equal(owner.address);
        })

        it('should restore successfully', async function () {
            const { lockContract, owner, unlockTime } = await loadFixture(deployContractsFixture);

            const snapshot = await takeSnapshot();
            await time.increaseTo(unlockTime);
            await lockContract.connect(owner).withdraw();

            const beforeRestore = await ethers.provider.getBalance(lockContract.address)
            console.log(`beforeRestore: ${beforeRestore}`);

            await snapshot.restore();

            const afterRestore = await ethers.provider.getBalance(lockContract.address)
            console.log(`afterRestore: ${afterRestore}`);

        })
    })
})