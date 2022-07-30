//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract TokenReceiver is ERC721Holder, Ownable {

    // 接收ETH
    event ValueReceived(address user, uint amount);

    receive() external payable {
        emit ValueReceived(msg.sender, msg.value);
    }

    // 接收erc721 token由ERC721Holder实现

                                                                                                                                        
    // 提取erc20 token
    function _withdrawERC20(address _token) private{
        uint balance = IERC20(_token).balanceOf(address(this));
        require(balance > 0);
        IERC20(_token).transfer(msg.sender, balance);
    }

    function withdrawERC20Tokens(address[] calldata contractAddresses) external onlyOwner{
        for(uint i=0; i< contractAddresses.length;){
            _withdrawERC20(contractAddresses[i]);
            unchecked {
                ++i; // save gas
            }
        }
    }
}
