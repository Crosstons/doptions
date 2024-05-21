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

    function testBuyAndExecute() public {
        assertEq(callOption.inited(), false);

        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(solToken, creator, 2e18);

        vm.startPrank(creator);
        solERC20.approve(address(callOption), 1e18);
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
        assertEq(callOption.strikeValue(), 180e18);

        daiERC20.approve(address(callOption), callOption.strikeValue());
        callOption.execute();
        vm.stopPrank();

        assertEq(solERC20.balanceOf(buyer), callOption.quantity());
        assertEq(daiERC20.balanceOf(buyer), 20e18);
        assertEq(daiERC20.balanceOf(creator), 280e18);
        assertEq(callOption.executed(), true);
    }

    function testCancel() public {
        assertEq(callOption.inited(), false);

        ERC20 solERC20 = ERC20(solToken);

        deal(solToken, creator, 2e18);

        vm.startPrank(creator);
        solERC20.approve(address(callOption), 1e18);
        callOption.init();

        assertEq(callOption.inited(), true);
        assertEq(callOption.executed(), false);
        assertEq(solERC20.balanceOf(address(callOption)), 1e18);

        skip(5 days);
        callOption.cancel();
        vm.stopPrank();

        assertEq(callOption.executed(), true);
        assertEq(solERC20.balanceOf(address(callOption)), 0);
        assertEq(solERC20.balanceOf(creator), 2e18);
    }

    function testWithdraw() public {
        assertEq(callOption.inited(), false);

        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(solToken, creator, 2e18);

        vm.startPrank(creator);
        solERC20.approve(address(callOption), 1e18);
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
        assertEq(callOption.strikeValue(), 180e18);

        vm.warp(block.timestamp + 8 days);
        vm.prank(creator);
        callOption.withdraw();

        assertEq(solERC20.balanceOf(creator), 2e18);
        assertEq(daiERC20.balanceOf(buyer), 200e18);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(callOption.executed(), true);
    }

    function testExecuteFails() public {
        uint256 _premium = 100e18;
        uint256 _strikePrice = 300e8;
        uint256 _quantity = 1e18;
        uint256 _expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallOption(solToken, _premium, _strikePrice, _quantity, _expiration);

        address[] memory _callOptions = factory.getCallOptions();
        CallOption callOption2 = CallOption(_callOptions[1]);

        assertEq(callOption2.inited(), false);

        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(solToken, creator, 2e18);

        vm.startPrank(creator);
        solERC20.approve(address(callOption2), 1e18);
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
        assertEq(callOption2.strikeValue(), 300e18);

        daiERC20.approve(address(callOption2), callOption2.strikeValue());
        vm.expectRevert();
        callOption2.execute();
        vm.stopPrank();

        assertEq(solERC20.balanceOf(buyer), 0);
        assertEq(daiERC20.balanceOf(buyer), 200e18);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(callOption2.executed(), false);
    }
}
