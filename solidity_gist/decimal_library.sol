pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

/// @title convert decimal value to string with fixed precision
/// @author Unkown
/// copy from https://etherscan.io/address/0x39b56602a01f41e2b603bcc257f0f9ef9524dfe3#code
/// basically it separates the decimal into two parts and combine it into a string
contract ValueToStringLibrary {
    function _valueString(uint256 value) private pure returns (string memory) {
        uint256 eth = value / 10**18;
        uint256 decimal4 = value / 10**14 - eth * 10**4;
        return
            string(
                abi.encodePacked(
                    eth.toString(),
                    ".",
                    _decimal4ToString(decimal4)
                )
            );
    }

    function _decimal4ToString(uint256 decimal4)
        private
        pure
        returns (string memory)
    {
        bytes memory decimal4Characters = new bytes(4);
        for (uint256 i = 0; i < 4; i++) {
            // 0x30 ascii code for 0
            decimal4Characters[3 - i] = bytes1(uint8(0x30 + (decimal4 % 10)));
            decimal4 /= 10;
        }
        return string(abi.encodePacked(decimal4Characters));
    }
}
