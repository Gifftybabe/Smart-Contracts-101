// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveToStorage is SimpleStorage {
    function store(uint256 _favouriteNumber) public override {
        myFavoriteNumber = _favouriteNumber + 5;
    }
}