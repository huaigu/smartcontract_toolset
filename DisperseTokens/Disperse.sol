// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// copy from Disperse.app

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Receiver {
    event ValueReceived(address user, uint amount);

    receive() external payable {
        emit ValueReceived(msg.sender, msg.value);
    }
}


contract GardenDisperse is Receiver, Ownable {

    function withdrawToken(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(msg.sender, amount);
    }

    function withdrawBnb() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function disperseEther(address[] calldata recipients, uint256[] calldata values) external payable {
        for (uint256 i = 0; i < recipients.length; i++)
            payable(recipients[i]).transfer(values[i]);
        uint256 balance = address(this).balance;
        if (balance > 0)
            payable(msg.sender).transfer(balance);
    }

    // 根据白皮书所说，跟disperseTokenSimple方法相比，归集后再disperse会节约gas
    function disperseToken(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++)
            total += values[i];
        require(token.transferFrom(msg.sender, address(this), total));
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transfer(recipients[i], values[i]));
    }

    function disperseTokenSimple(IERC20 token, address[] calldata recipients, uint256[] calldata values) external {
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transferFrom(msg.sender, recipients[i], values[i]));
    }
}