// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/primary/Dia.sol";

contract OptionsFactoryTest is Test {
    OptionsFactory public factory;
    address usdcToken = 0x7A9294c8305F9ee1d245E0f0848E00B1149818C7;
    address btcToken = 0x817BB339d55A0a66EA680EE849a931416b575Ff2;
    address priceOracle = 0x533D3c1df8D238374065FB3341c34754e4BFCE8E;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new OptionsFactory(usdcToken, priceOracle);
        factory.setPairId(btcToken, "BTC/USD");
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
