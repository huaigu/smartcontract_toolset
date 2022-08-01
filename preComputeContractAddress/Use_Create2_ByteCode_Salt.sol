//SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

// borrowed from https://github.com/Vbhaskar125
// Create2 只需要合约ByteCode与Salt就可以确定地址

/// @title 构造函数带有参数的合约
contract simpleContract {
    uint256 public element;

    constructor(uint256 initValue) payable {
        element = initValue;
    }
}


/// @title 构造函数没有参数的合约
contract simpleContractWithoutConstructor {
    uint256 storedNumber;

    function increment() public {
        storedNumber++;
    }
}

contract preComputeAddress {
    uint256 constructorParameter = 0x12;

    
    /// @dev 使用sale通过new方式部署合约。
    function deploy(uint256 _salt) public returns (address) {
        // 传递salt参数，代替内联汇编的create2方法
        return
            address(
                new simpleContract{salt: bytes32(_salt)}(constructorParameter)
            );
    }

    /// @dev 使用内联汇编的方式部署合约
    function deployUseAssembly(bytes memory code, uint256 salt)
        public
        returns (address)
    {
        address addr;
        assembly {
            addr := create2(0, add(code, 0x20), mload(code), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        return addr;
    }

    function getBytecode() public pure returns (bytes memory) {
        return type(simpleContractWithoutConstructor).creationCode;
    }

    function getBytecodeWithParameters() public view returns (bytes memory) {
        bytes memory bytecode = type(simpleContract).creationCode;
        // 构造函数带有参数
        return abi.encodePacked(bytecode, abi.encode(constructorParameter));
    }

    /// @dev compute the deployment address
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
                keccak256(_byteCode) //getBytecodeWithParameters()
            )
        );
        return address(uint160(uint256(hash_)));
    }

}

