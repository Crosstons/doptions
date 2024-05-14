// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CallOption {

    address public asset;
    address public creator;
    uint256 public premium;
    uint256 public strikePrice;
    uint256 public quantity;
    uint256 public expiration;
    address public buyer;
    bool public bought;
    bool public executed;

    constructor(
        address _asset,
        uint256 _premium,
        uint256 _strikePrice,
        uint256 _quantity,
        uint256 _expiration
    ) {
        asset = _asset;
        premium = _premium;
        strikePrice = _strikePrice;
        quantity = _quantity;
        expiration = _expiration;
        buyer = address(0);
        bought = false;
        executed = false;
    }

    modifier notBought {
        require(bought == false, "contract has been bought!");
        _;
    }

    modifier notExecuted {
        require(executed == false, "contract has been executed!");
        _;
    }
}