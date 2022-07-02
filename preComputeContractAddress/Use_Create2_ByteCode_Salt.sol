//SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

// borrowed from https://github.com/Vbhaskar125
// Create2 只需要合约ByteCode与Salt就可以确定地址

contract preComputeAddress {
    //compute the deployment address
    function computeAddress(bytes memory _byteCode, uint256 _salt)
        public
        view
        returns (address)
    {
        bytes32 hash_ = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(_byteCode)
            )
        );
        return address(uint160(uint256(hash_)));
    }

    function getBytecode() public pure returns (bytes memory) {
        return type(TestContract).creationCode;
    }
}

contract TestContract {
    uint256 storedNumber;

    function increment() public {
        storedNumber++;
    }
}
