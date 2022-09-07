// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IStandardBEP20 is IERC20 {
    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() external view returns (uint256);

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function mint(address to, uint256 amount) external;
}
