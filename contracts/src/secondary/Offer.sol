// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./OfferInterface.sol";

contract Offer {
    OptionContract public optionContract;
    address public seller;
    bool public executed;
    uint256 public ask;
    IERC20 public premiumToken;

    event OfferBought(address indexed optionAddress, uint256 indexed ask, address buyer, address seller);

    event OfferCancelled(address indexed optionAddress, uint256 indexed ask);

    constructor(address _optionContract, address _seller, address _premiumToken, uint256 _ask) {
        optionContract = OptionContract(_optionContract);
        seller = _seller;
        ask = _ask;
        premiumToken = IERC20(_premiumToken);
        executed = false;
    }

    modifier isAuthorized() {
        require(optionContract.buyer() == address(this), "The offer contract has not been authorized yet!");
        _;
    }

    modifier isExecutable() {
        require(executed == false, "The offer contract has already been executed!");
        _;
    }

    function buy() external isAuthorized isExecutable {
        require(msg.sender != seller, "The seller should call the cancel function instead");
        require(premiumToken.transferFrom(msg.sender, seller, ask), "Ask transfer failed");
        optionContract.transfer(msg.sender);
        executed = true;

        emit OfferBought(address(optionContract), ask, msg.sender, seller);
    }

    function cancel() external isAuthorized isExecutable {
        require(msg.sender == seller, "Only the seller can call this function!");
        optionContract.transfer(seller);
        executed = true;

        emit OfferCancelled(address(optionContract), ask);
    }
}
