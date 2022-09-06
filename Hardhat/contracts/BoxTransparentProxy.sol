// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import './BoxStorageProxy.sol';

contract BoxTransparentProxy is BoxStorageProxy, Initializable, OwnableUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __Ownable_init();
        __Box_init();
    }

    function __Box_init() internal onlyInitializing {
        _secretValue = 1;
        name = "V1";
    }
}
