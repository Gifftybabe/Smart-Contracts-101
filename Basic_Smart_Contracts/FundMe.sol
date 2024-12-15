// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// What this contract does is to: - Get funds from users, - Withdraw funds, - Set a minmum funding value in USD, -Keep track of the funders that sends the money

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 5e18;
    address[] public funders;
    address public owner;

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable  {
        // Allow users to send $
        // Have a minimum $ sent

        //q1: How do we send ETH to this contract? - by the payable keyword on the function makes it possible to send and receive ETH
        //q2 How do we convert the amount of ethereum(msg.value) to it's price in dollars(minimumUsd)?

        // require(msg.value >= minimumUsd, "Please send enough ETH"); // Here we want the fund that the user sends to be greater than $5 but our msg.value is measured in ETH
        require(getConversionRate(msg.value) >= minimumUsd, "Please Send Enough ETH"); // Here we pass in the value that the user sends to the getConversionRate, eliminating the first require statement and also add the 18 decimal places our getConversionRate function returns to the minimumUsd variable for update
        funders.push(msg.sender);

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;  // This sets the sender's address to whatever they have previously funded plus whatever they are additionally adding.

    }

            //a2 we need a function to get the price of the blockchain token we are working with in terms of the USD and also a function to convert a value to his converted value based on the set price.


     function getPrice() public view returns(uint256) {
        // To get the price of an eth in usd, we need to interact with a deployed chainlink contract taking the address e.g sepolia testnet and an ABI e.g going to the chainlink github account and getting the interface of the contract
        // Get the interface of the contract using the interface keyword, compile it and get the ABI from the compiler and then wrap an address around the contract interface and you can call any function at that address.

        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI gotten already from the interface

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price,,,) = priceFeed.latestRoundData(); // where the price is the Price of ETH in terms of USD which can be positive or negative and returns without decimal but whole number which is why it's in int and we have to figure out the decimals to get the real USD format.

        // To check how many decimals are in a price field, we can go to the interface on github abd check out the decimal function
        // We know that msg.value is going to have 18 decimal places because 1ETh is 1*10^18 wei and price has 8 decimal places, so we need to get them to match up
        // Also price is an int256 and msg.value is a uint256, we need to get that to match up too

        return uint256(price) * 1e10; // Here we added additional 10 zeros to the initial 8zeros of price to be same with the msg.value decimal places and we also type cast the initial type of int256 of the price variable to uint256 of the msg.value to match each other      
        }

        function getConversionRate(uint256 ethAmount) public view returns(uint256) {
            uint256 ethPrice = getPrice();
            uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // we divide by 1e18 because both the eth price and amount has 18 decimal places and if we multiply by each other, we get a massive number with 38 decimal places so we divide to get it down to what it shld actually be.

            return ethAmountInUsd;
        }
    function withdraw() public onlyOwner{
        // Ensure that only the owner of the contract can call the withdraw function
        // When we withdraw the fund, we need to reset all the mapping back down to zero by using a for loop which is a way to loop through or sometyhing in a repeated amount of time
        // for loop
        for(/* starting index, ending index, step amount*/ uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex]; // This returns an array of addresses
            addressToAmountFunded[funder] = 0; // used to reset the mapping address to zero
        }

         // We still need to reset the array and withdraw the funds
        funders = new address[](0); // this is used to reset the funders array to a brand new blank address array and we could also use the rest method used for the mapping where we reset the amount individually by their indices.
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    
    }

    modifier onlyOwner () {
        require(msg.sender == owner, 'You ar not the owner!');
        _;
    }
   
}