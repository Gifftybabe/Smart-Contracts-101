// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    // Declaring a contract variable;
    SimpleStorage[] public simpleStrageContracts;

    // Deploying the simple storage contract and pushing each address to the variable array declared above:
    function createStorageContract() public {
        SimpleStorage mystorageContract = new SimpleStorage();
        simpleStrageContracts.push(mystorageContract);
    }

    // Interacting with the simple storage contract from the factory contract(calling the store function)
    // To interact with a contract from another contract, we need the deployed contract Address and it's ABI - Application Binary Interface
    function sfStore(uint256 _mystorageContractIndex, uint256 _mystorageContractNumber) public {
        SimpleStorage mySimpleStorage = simpleStrageContracts[_mystorageContractIndex]; // We assign a contract variable to the contract address and Abi gotten after deployment at a particular index.
        mySimpleStorage.store(_mystorageContractNumber);
        //  simpleStrageContracts[_mystorageContractIndex].store(_mystorageContractNumber);
    }

    function sfGet(uint256 _mystorageContractIndex) public view returns (uint256) {
        // SimpleStorage mySimpleStorage = simpleStrageContracts[_mystorageContractIndex];
        // return mySimpleStorage.retrive();
        return simpleStrageContracts[_mystorageContractIndex].retrive();
    }
}