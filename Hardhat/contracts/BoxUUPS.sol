// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


import './BoxStorageProxy.sol';

/// @dev UUPS模式，将合约升级的逻辑封装在UUPSUpgradeable中，
/// 代理合约
/// refer to: https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786
contract BoxUUPS is BoxStorageProxy, Initializable, UUPSUpgradeable, OwnableUpgradeable {
     /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        /// @dev 当合约的构造函数被调用，设置initialized为false, 因为modifier存在，下面的initialize
        /// 将不会被调用。
        /// ? 事实上，当initialize被调用一次后，也就不能被调用了（通过initializer修饰符实现），
        /// 只要按照规范调用，并不需要在构造函数中调用这个方法。
        _disableInitializers();
    }

    /// @dev 作为逻辑合约，不能使用构造函数初始化，只能使用initialize方法初始化，
    /// 同样的，继承的父合约也不能使用构造函数初始化，所以需要调用父类的init相关方法。
    function initialize() public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init();
        __Box_init();
    }

    /// @dev see: https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786
    /* This is because, as we mentioned at the beginning of the tutorial, 
    UUPS proxies do not contain an upgrade mechanism on the proxy, 
    and it has to be included in the implementation. 
    We can add this mechanism by inheriting UUPSUpgradeable, 
    and this will also require that we implement an authorization function to define who should be allowed to upgrade the contract. 
    For the example we will use Ownable. */
    /// 由于UUPS没有包含一个upgrade逻辑合约的机制，为了实现这个机制，引入了UUPSUpgradeable
    /// 同时，需要实现一个授权函数，来定义谁可以升级合约。在这个例子中，我们使用Ownable。
    /// 通过一个onlyOwner的修饰符来实现，也可以自定义，比如在合约中定义一个管理员，判断msg.sender
    /// 是不是管理员，如果不是就revert，来达到相同的效果。
    ///  ==> _authorizeUpgrade(newImplementation);  <==
    ///  _upgradeToAndCallUUPS(newImplementation, data, true);

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {
        
    }

    function __Box_init() internal onlyInitializing {
        _secretValue = 1;
        name = "uups";
    }
}