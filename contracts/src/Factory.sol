// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CallOption} from './Call.sol';
import {PutOption} from './Put.sol';

contract OptionsFactory {
    address[] public callOptions;
    address[] public putOptions;

    function createCallOption(
        address _asset,
        uint256 _premium,
        uint256 _strikePrice,
        uint256 _quantity,
        uint256 _expiration
    ) external {
        CallOption _newCallOption = new CallOption(
            _asset, _premium, _strikePrice, _quantity, _expiration
        );
        callOptions.push(address(_newCallOption));
    }

    function createPutOption(
        address _asset,
        uint256 _premium,
        uint256 _strikePrice,
        uint256 _quantity,
        uint256 _expiration
    ) external {
        PutOption _newPutOption = new PutOption(
            _asset, _premium, _strikePrice, _quantity, _expiration
        );
        putOptions.push(address(_newPutOption));
    }
}
