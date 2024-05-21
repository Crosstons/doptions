// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/primary/AggregatorV3Interface.sol";

contract OptionsFactoryTest is Test {
    OptionsFactory public factory;
    address usdcToken = 0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582;
    address btcToken = 0xCa54e7376675e2c2B5943E06b1B0E029236D2A6A;
    address priceOracle = 0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new OptionsFactory(usdcToken);
        factory.setPriceOracle(btcToken, priceOracle);
    }

    function testCreateCallOption() public {
        uint256 premium = 100e18;
        uint256 strikePrice = 66000e8;
        uint256 quantity = 1e18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallOption(btcToken, premium, strikePrice, quantity, expiration);

        address[] memory callOptions = factory.getCallOptions();
        assertEq(callOptions.length, 1);

        CallOption callOption = CallOption(callOptions[0]);
        assertEq(callOption.asset(), address(btcToken));
        assertEq(callOption.premium(), premium);
        assertEq(callOption.strikePrice(), strikePrice);
        assertEq(callOption.quantity(), quantity);
        assertEq(callOption.expiration(), expiration);
    }

    function testCreatePutOption() public {
        uint256 premium = 100e18;
        uint256 strikePrice = 66000e8;
        uint256 quantity = 1e18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutOption(btcToken, premium, strikePrice, quantity, expiration);

        address[] memory putOptions = factory.getPutOptions();
        assertEq(putOptions.length, 1);

        PutOption putOption = PutOption(putOptions[0]);
        assertEq(putOption.asset(), btcToken);
        assertEq(putOption.premium(), premium);
        assertEq(putOption.strikePrice(), strikePrice);
        assertEq(putOption.quantity(), quantity);
        assertEq(putOption.expiration(), expiration);
    }
}
