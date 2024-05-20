// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CallOption} from "./Call.sol";
import {PutOption} from "./Put.sol";
import {CallBasketOption} from "./CallBasket.sol";
import {PutBasketOption} from "./PutBasket.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OptionsFactory is Ownable {
    address[] public callOptions;
    address[] public putOptions;
    address[] public basketOptions;
    address public premiumToken;
    mapping(address => address) public priceOracles;

    event CallOptionCreated(
        address indexed optionAddress,
        address indexed asset,
        uint256 premium,
        uint256 strikePrice,
        uint256 quantity,
        uint256 expiration
    );

    event PutOptionCreated(
        address indexed optionAddress,
        address indexed asset,
        uint256 premium,
        uint256 strikePrice,
        uint256 quantity,
        uint256 expiration
    );

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

    function createCallOption(
        address _asset,
        uint256 _premium,
        uint256 _strikePrice,
        uint256 _quantity,
        uint256 _expiration
    ) external {
        address priceOracle = priceOracles[_asset];
        require(priceOracle != address(0), "Price oracle not set for this asset");

        CallOption _newCallOption = new CallOption(
            _asset, msg.sender, _premium, _strikePrice, _quantity, _expiration, premiumToken, priceOracle
        );
        callOptions.push(address(_newCallOption));

        emit CallOptionCreated(address(_newCallOption), _asset, _premium, _strikePrice, _quantity, _expiration);
    }

    function createPutOption(
        address _asset,
        uint256 _premium,
        uint256 _strikePrice,
        uint256 _quantity,
        uint256 _expiration
    ) external {
        address priceOracle = priceOracles[_asset];
        require(priceOracle != address(0), "Price oracle not set for this asset");

        PutOption _newPutOption =
            new PutOption(_asset, msg.sender, _premium, _strikePrice, _quantity, _expiration, premiumToken, priceOracle);
        putOptions.push(address(_newPutOption));

        emit PutOptionCreated(address(_newPutOption), _asset, _premium, _strikePrice, _quantity, _expiration);
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
        basketOptions.push(address(_newBasketOption));

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
        basketOptions.push(address(_newBasketOption));

        emit PutBasketOptionCreated(
            address(_newBasketOption), _assets, _premium, _strikeValue, _quantities, _expiration
        );
    }

    function getCallOptions() external view returns (address[] memory) {
        return callOptions;
    }

    function getPutOptions() external view returns (address[] memory) {
        return putOptions;
    }

    function getBasketOptions() external view returns (address[] memory) {
        return basketOptions;
    }
}
