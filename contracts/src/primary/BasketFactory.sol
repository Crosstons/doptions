// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CallBasketOption} from "./CallBasket.sol";
import {PutBasketOption} from "./PutBasket.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasketFactory is Ownable {

    address[] public callBasketOptions;
    address[] public putBasketOptions;
    address public premiumToken;
    mapping(address => address) public priceOracles;


    event CallBasketOptionCreated(
        address indexed optionAddress,
        address[] indexed assets,
        uint256 premium,
        uint256 strikeValue,
        uint256[] quantities,
        uint256 expiration
    );

    event PutBasketOptionCreated(
        address indexed optionAddress,
        address[] indexed assets,
        uint256 premium,
        uint256 strikeValue,
        uint256[] quantities,
        uint256 expiration
    );

    constructor(address _premiumToken) Ownable(msg.sender) {
        premiumToken = _premiumToken;
    }

    function setPriceOracle(address _asset, address _priceOracle) external onlyOwner {
        priceOracles[_asset] = _priceOracle;
    }

    function createCallBasketOption(
        address[] memory _assets,
        address[] memory _priceOracles,
        uint256[] memory _quantities,
        uint256 _premium,
        uint256 _strikeValue,
        uint256 _expiration
    ) external {
        for (uint256 i = 0; i < _assets.length; i++) {
            require(priceOracles[_assets[i]] != address(0), "Price oracle not set for one or more assets");
            require(priceOracles[_assets[i]] == _priceOracles[i], "Invalid price oracle is being passed as input");
        }

        CallBasketOption _newBasketOption = new CallBasketOption(
            msg.sender, _assets, _priceOracles, _quantities, _premium, _strikeValue, _expiration, premiumToken
        );
        callBasketOptions.push(address(_newBasketOption));

        emit CallBasketOptionCreated(
            address(_newBasketOption), _assets, _premium, _strikeValue, _quantities, _expiration
        );
    }

    function createPutBasketOption(
        address[] memory _assets,
        address[] memory _priceOracles,
        uint256[] memory _quantities,
        uint256 _premium,
        uint256 _strikeValue,
        uint256 _expiration
    ) external {
        for (uint256 i = 0; i < _assets.length; i++) {
            require(priceOracles[_assets[i]] != address(0), "Price oracle not set for one or more assets");
            require(priceOracles[_assets[i]] == _priceOracles[i], "Invalid price oracle is being passed as input");
        }

        PutBasketOption _newBasketOption = new PutBasketOption(
            msg.sender, _assets, _priceOracles, _quantities, _premium, _strikeValue, _expiration, premiumToken
        );
        putBasketOptions.push(address(_newBasketOption));

        emit PutBasketOptionCreated(
            address(_newBasketOption), _assets, _premium, _strikeValue, _quantities, _expiration
        );
    }

    function getCallBaskets() external view returns (address[] memory) {
        return callBasketOptions;
    }

    function getPutBaskets() external view returns (address[] memory) {
        return putBasketOptions;
    }

}