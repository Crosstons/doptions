// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Offer} from "./Offer.sol";
import "./OfferInterface.sol";

contract OfferFactory {
    address public premiumToken;
    address[] public offers;

    event OfferCreated(address indexed optionContract, uint256 indexed ask, address seller);

    constructor(address _premiumToken) {
        premiumToken = _premiumToken;
    }

    function createOffer(address _optionContract, uint256 _ask) external {
        require(
            OptionContract(_optionContract).buyer() == msg.sender, "The offer contract has not been authorized yet!"
        );
        Offer newOffer = new Offer(_optionContract, msg.sender, premiumToken, _ask);
        offers.push(address(newOffer));
        emit OfferCreated(_optionContract, _ask, msg.sender);
    }

    function getOffers() external view returns (address[] memory) {
        return offers;
    }
}
