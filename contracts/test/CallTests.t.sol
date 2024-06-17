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
    address daiToken = 0x7A9294c8305F9ee1d245E0f0848E00B1149818C7; // 18 decimals random token
    address btcToken = 0x817BB339d55A0a66EA680EE849a931416b575Ff2; // 18 decimals random token
    address priceOracle = 0x533D3c1df8D238374065FB3341c34754e4BFCE8E; // 8 decimals
    CallOption callOption;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new OptionsFactory(daiToken);
        uint256 premium = 100e18;
        uint256 strikePrice = 70000e8;
        uint256 quantity = 1e15;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallOption(btcToken, premium, strikePrice, quantity, expiration);

        address[] memory callOptions = factory.getCallOptions();
        callOption = CallOption(callOptions[0]);
    }

    function testBuyAndExecute() public {
        assertEq(callOption.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(btcToken, creator, 2e18);

        vm.startPrank(creator);
        btcERC20.approve(address(callOption), 1e18);
        callOption.init();
        vm.stopPrank();

        assertEq(callOption.inited(), true);
        assertEq(callOption.bought(), false);

        deal(daiToken, buyer, 300e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(callOption), 100e18);
        callOption.buy();

        assertEq(callOption.bought(), true);
        assertEq(callOption.executed(), false);
        assertEq(callOption.buyer(), buyer);
        assertEq(callOption.strikeValue(), 70e18);

        daiERC20.approve(address(callOption), callOption.strikeValue());
        callOption.execute();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(buyer), callOption.quantity());
        assertEq(daiERC20.balanceOf(buyer), 130e18);
        assertEq(daiERC20.balanceOf(creator), 170e18);
        assertEq(callOption.executed(), true);
    }

    function testCancel() public {
        assertEq(callOption.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);

        deal(btcToken, creator, 2e18);

        vm.startPrank(creator);
        btcERC20.approve(address(callOption), 1e18);
        callOption.init();

        assertEq(callOption.inited(), true);
        assertEq(callOption.executed(), false);
        assertEq(btcERC20.balanceOf(address(callOption)), 1e15);

        skip(5 days);
        callOption.cancel();
        vm.stopPrank();

        assertEq(callOption.executed(), true);
        assertEq(btcERC20.balanceOf(address(callOption)), 0);
        assertEq(btcERC20.balanceOf(creator), 2e18);
    }

    function testWithdraw() public {
        assertEq(callOption.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(btcToken, creator, 2e18);

        vm.startPrank(creator);
        btcERC20.approve(address(callOption), 1e18);
        callOption.init();
        vm.stopPrank();

        assertEq(callOption.inited(), true);
        assertEq(callOption.bought(), false);

        deal(daiToken, buyer, 300e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(callOption), 100e18);
        callOption.buy();
        vm.stopPrank();

        assertEq(callOption.bought(), true);
        assertEq(callOption.executed(), false);
        assertEq(callOption.buyer(), buyer);
        assertEq(callOption.strikeValue(), 70e18);

        vm.warp(block.timestamp + 8 days);
        vm.prank(creator);
        callOption.withdraw();

        assertEq(btcERC20.balanceOf(creator), 2e18);
        assertEq(daiERC20.balanceOf(buyer), 200e18);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(callOption.executed(), true);
    }

    function testExecuteFails() public {
        uint256 _premium = 100e18;
        uint256 _strikePrice = 80000e8;
        uint256 _quantity = 1e15;
        uint256 _expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallOption(btcToken, _premium, _strikePrice, _quantity, _expiration);

        address[] memory _callOptions = factory.getCallOptions();
        CallOption callOption2 = CallOption(_callOptions[1]);

        assertEq(callOption2.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(btcToken, creator, 2e18);

        vm.startPrank(creator);
        btcERC20.approve(address(callOption2), 1e18);
        callOption2.init();
        vm.stopPrank();

        assertEq(callOption2.inited(), true);
        assertEq(callOption2.bought(), false);

        deal(daiToken, buyer, 300e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(callOption2), 100e18);
        callOption2.buy();

        assertEq(callOption2.bought(), true);
        assertEq(callOption2.executed(), false);
        assertEq(callOption2.buyer(), buyer);
        assertEq(callOption2.strikeValue(), 80e18);

        daiERC20.approve(address(callOption2), callOption2.strikeValue());
        vm.expectRevert();
        callOption2.execute();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(buyer), 0);
        assertEq(daiERC20.balanceOf(buyer), 200e18);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(callOption2.executed(), false);
    }
}
