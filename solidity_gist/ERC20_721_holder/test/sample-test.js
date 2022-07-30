const chai = require("chai");
const { solidity } = require("ethereum-waffle");
const { ethers } = require("hardhat");

chai.use(solidity);
const { expect } = chai;

describe("Transfer token to smart contract", function () {

  let hardhatToken;
  let erc20Token;

  let owner;
  let hardhatOwner;
  let user1;
  let user2;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const erc20 = await ethers.getContractFactory("SimpleToken");
    erc20Token = await erc20.deploy("SimpleToken", "ST", 10000);

    [owner, hardhatOwner, user1, user2] = await ethers.getSigners();

    const TokenReceiver = 
    (await ethers.getContractFactory("TokenReceiver")).connect(hardhatOwner);

    hardhatToken = await TokenReceiver.deploy();
  });

  it("Should success when transfer erc20 to contract address", async function () {
    await erc20Token.transfer(hardhatToken.address, 100);
    expect(await erc20Token.balanceOf(hardhatToken.address)).to.equal(100);
  });

  it("Should failed transfer erc20 token from smart contract directly", async function () {
    await erc20Token.transfer(hardhatToken.address, 100);
    expect(await erc20Token.balanceOf(hardhatToken.address)).to.equal(100);

    // 使用holder合约的onwer地址去调用erc20代币的transferFrom方法
    // erc20代币在是在Receiver合约地址上，Owner并没有权限调用。
    // 如果不小心打给没有针对这种情况处理的合约，那么代币就取不回来了。比如之前的PeopleDAO事件
    await expect(erc20Token.connect(hardhatOwner)
      .transferFrom(hardhatToken.address, user1.address, 100)).to.be.reverted;
  });

  it("Should success withdraw tokens by withdrawerc20tokens function", async function () {
    await erc20Token.transfer(hardhatToken.address, 100);

    await hardhatToken.connect(hardhatOwner).withdrawERC20Tokens([erc20Token.address]);
    expect(await erc20Token.balanceOf(hardhatOwner.address)).to.equal(100);
    expect(await erc20Token.balanceOf(hardhatToken.address)).to.equal(0);
  })
});
