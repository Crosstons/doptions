// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CallOption} from "./Call.sol";
import {PutOption} from "./Put.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OptionsFactory is Ownable {
    address[] public callOptions;
    address[] public putOptions;
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

    function getCallOptions() external view returns (address[] memory) {
        return callOptions;
    }

    function getPutOptions() external view returns (address[] memory) {
        return putOptions;
    }
}