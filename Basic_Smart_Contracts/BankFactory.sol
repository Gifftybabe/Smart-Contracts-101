// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {BankDetails} from "./BankDetails.sol";

contract BankFactory {
    BankDetails public BankContract;

    function deployBankContract() public {
        BankContract = new BankDetails();
    }

    function bfStoreDetails(string memory _name, uint256 _accountNo, uint256 _accountBalance) public {
        BankContract.storeCustomerDetails(_name, _accountNo, _accountBalance);
    }

    function bfDepositFund(uint256 _accountNo, uint256 _depositAmount) public {
        BankContract.deposit(_accountNo, _depositAmount);
    }

    function bfGet(uint256 _accountNo) public view returns (BankDetails.Customer memory) {
        return BankContract.getCustomerDetails(_accountNo);
    }
}