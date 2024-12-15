// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; // this is the solidity version

contract SimpleStorage {
    // A simple smart contract to store user's favorite number.

    uint256 myFavoriteNumber; // this gets intialized to 0 if no value is given 
    uint256[] listOfFavouriteNumbers; // here we try to save list of people's favourite number not just one.




    function store(uint256 _favouriteNumber) public virtual {
        myFavoriteNumber = _favouriteNumber;
    }

    function retrive() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function storeList(uint256[] memory _listOfFavouriteNumbers) public {
        listOfFavouriteNumbers = _listOfFavouriteNumbers;
    }

    function retriveList() public view returns (uint256[] memory) {
        return listOfFavouriteNumbers;
    }
}