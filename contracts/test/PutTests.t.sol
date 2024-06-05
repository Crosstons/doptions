// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/primary/Dia.sol";

contract PutOptionTest is Test {
    OptionsFactory public factory;
    address daiToken = 0x7A9294c8305F9ee1d245E0f0848E00B1149818C7; // 18 decimals random token
    address btcToken = 0x817BB339d55A0a66EA680EE849a931416b575Ff2; // 18 decimals random token
    address priceOracle = 0x533D3c1df8D238374065FB3341c34754e4BFCE8E; // 8 decimals
    PutOption putOption;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new OptionsFactory(daiToken, priceOracle);
        factory.setPairId(btcToken, "BTC/USD");
        uint256 premium = 100e18;
        uint256 strikePrice = 80000e8;
        uint256 quantity = 1e15;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutOption(btcToken, premium, strikePrice, quantity, expiration);

        address[] memory putOptions = factory.getPutOptions();
        putOption = PutOption(putOptions[0]);
    }

    function testBuyAndExecute() public {
        assertEq(putOption.inited(), false);
        assertEq(putOption.strikeValue(), 80e18);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption), putOption.strikeValue());
        putOption.init();
        vm.stopPrank();

        assertEq(putOption.inited(), true);
        assertEq(putOption.bought(), false);

        deal(daiToken, buyer, 100e18);
        deal(btcToken, buyer, 1e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(putOption), 100e18);
        putOption.buy();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putOption.bought(), true);
        assertEq(putOption.executed(), false);
        assertEq(putOption.buyer(), buyer);

        btcERC20.approve(address(putOption), putOption.strikeValue());
        putOption.execute();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(creator), putOption.quantity());
        assertEq(daiERC20.balanceOf(buyer), putOption.strikeValue());
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(putOption.executed(), true);
    }

    function testCancel() public {
        assertEq(putOption.inited(), false);
        assertEq(putOption.strikeValue(), 80e18);

        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption), putOption.strikeValue());
        putOption.init();

        assertEq(putOption.inited(), true);
        assertEq(putOption.executed(), false);
        assertEq(daiERC20.balanceOf(address(putOption)), putOption.strikeValue());

        skip(5 days);
        putOption.cancel();
        vm.stopPrank();

        assertEq(putOption.executed(), true);
        assertEq(daiERC20.balanceOf(address(putOption)), 0);
        assertEq(daiERC20.balanceOf(creator), putOption.strikeValue());
    }

    function testWithdraw() public {
        assertEq(putOption.inited(), false);
        assertEq(putOption.strikeValue(), 80e18);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption), putOption.strikeValue());
        putOption.init();
        vm.stopPrank();

        assertEq(putOption.inited(), true);
        assertEq(putOption.bought(), false);
        assertEq(daiERC20.balanceOf(address(putOption)), putOption.strikeValue());

        deal(daiToken, buyer, 100e18);
        deal(btcToken, buyer, 1e15);

        vm.startPrank(buyer);
        daiERC20.approve(address(putOption), 100e18);
        putOption.buy();
        vm.stopPrank();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putOption.bought(), true);
        assertEq(putOption.executed(), false);
        assertEq(putOption.buyer(), buyer);

        vm.warp(block.timestamp + 8 days);
        vm.prank(creator);
        putOption.withdraw();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(buyer), 1e15);
        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(daiERC20.balanceOf(creator), 180e18);
        assertEq(putOption.executed(), true);
    }

    function testExecuteFails() public {
        uint256 _premium = 100e18;
        uint256 _strikePrice = 60000e8;
        uint256 _quantity = 1e15;
        uint256 _expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutOption(btcToken, _premium, _strikePrice, _quantity, _expiration);

        address[] memory _putOptions = factory.getPutOptions();
        PutOption putOption2 = PutOption(_putOptions[1]);

        assertEq(putOption2.inited(), false);
        assertEq(putOption2.strikeValue(), 60e18);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption2.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption2), putOption2.strikeValue());
        putOption2.init();
        vm.stopPrank();

        assertEq(daiERC20.balanceOf(creator), 0);
        assertEq(putOption2.inited(), true);
        assertEq(putOption2.bought(), false);

        deal(daiToken, buyer, 100e18);
        deal(btcToken, buyer, 1e15);

        vm.startPrank(buyer);
        daiERC20.approve(address(putOption2), 100e18);
        putOption2.buy();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putOption2.bought(), true);
        assertEq(putOption2.executed(), false);
        assertEq(putOption2.buyer(), buyer);

        btcERC20.approve(address(putOption2), putOption2.strikeValue());
        vm.expectRevert();
        putOption2.execute();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(buyer), 1e15);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(putOption2.executed(), false);
    }
}
