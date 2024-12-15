// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract BankDetails {
    struct Customer {
        string name;
        uint256 accountNo;
        uint256 accountBalance;
    }

    Customer[] public customerDetails;
    mapping(uint256 => string) public accountNoToName;
    mapping(uint256 => uint256) public accountNoToAccountbalance;
    mapping(uint256 => bool) public accountExists; 
    mapping(uint256 => uint256) private accountNoToIndex;

    // Store customer details
    function storeCustomerDetails(string memory _name, uint256 _accountNo, uint256 _accountBalance) public {
        require(!accountExists[_accountNo], "Account already exists");

        customerDetails.push(Customer(_name, _accountNo, _accountBalance));
        accountNoToName[_accountNo] = _name;
        accountNoToAccountbalance[_accountNo] = _accountBalance;
        accountExists[_accountNo] = true;

        accountNoToIndex[_accountNo] = customerDetails.length - 1;
    }

    // Deposit funds into a customer's account
    function deposit(uint256 _accountNo, uint256 _depositAmount) public {
        require(accountExists[_accountNo], "Account does not exist");

        // Update the mapping
        accountNoToAccountbalance[_accountNo] += _depositAmount;

        // Update the corresponding Customer struct in the array
        uint256 customerIndex = accountNoToIndex[_accountNo];
        customerDetails[customerIndex].accountBalance += _depositAmount;
    }

    // Fetch customer details
    function getCustomerDetails(uint256 _accountNo) public view returns (Customer memory) {
        require(accountExists[_accountNo], "Account does not exist");

        uint256 customerIndex = accountNoToIndex[_accountNo];
        return customerDetails[customerIndex];
    }
}
