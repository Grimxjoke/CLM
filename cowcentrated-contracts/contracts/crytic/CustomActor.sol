// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract CustomActor {
    function proxy(address target, bytes memory data) public returns (bool success, bytes memory retData) {
        return target.call(data);
    }
}