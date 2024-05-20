// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/primary/AggregatorV3Interface.sol";

contract CallOptionTest is Test {
    OptionsFactory public factory;
    address daiToken = 0xDc61d022126ccB074cE31f4cF66E847d0086a58E; // 18 decimals random token
    address solToken = 0x13F793FAadA9b42BeFEF18048658813CF6FE790F; // 18 decimals random token
    address priceOracle = 0xF8e2648F3F157D972198479D5C7f0D721657Af67; // 8 decimals
    CallOption callOption;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new OptionsFactory(daiToken);
        factory.setPriceOracle(solToken, priceOracle);
        uint256 premium = 100e18;
        uint256 strikePrice = 180e8;
        uint256 quantity = 1e18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallOption(solToken, premium, strikePrice, quantity, expiration);

        address[] memory callOptions = factory.getCallOptions();
        callOption = CallOption(callOptions[0]);
    }

    function testBuy() public {
        assertEq(callOption.inited(), false);

        deal(solToken, creator, 2e18);
        ERC20 btcERC20 = ERC20(solToken);

        vm.startPrank(creator);
        btcERC20.approve(address(callOption), 1e18);
        callOption.init();
        vm.stopPrank();

        assertEq(callOption.inited(), true);
        assertEq(callOption.bought(), false);

        deal(daiToken, buyer, 100e18);
        ERC20 daiERC20 = ERC20(daiToken);

        vm.startPrank(buyer);
        daiERC20.approve(address(callOption), 100e18);
        callOption.buy();
        vm.stopPrank();

        assertEq(callOption.bought(), true);
        assertEq(callOption.buyer(), buyer);
    }
}
