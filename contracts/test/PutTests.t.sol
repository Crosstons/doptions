// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/primary/AggregatorV3Interface.sol";

contract PutOptionTest is Test {
    OptionsFactory public factory;
    address daiToken = 0xDc61d022126ccB074cE31f4cF66E847d0086a58E; // 18 decimals random token
    address solToken = 0x13F793FAadA9b42BeFEF18048658813CF6FE790F; // 18 decimals random token
    address priceOracle = 0xF8e2648F3F157D972198479D5C7f0D721657Af67; // 8 decimals
    PutOption putOption;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new OptionsFactory(daiToken);
        factory.setPriceOracle(solToken, priceOracle);
        uint256 premium = 100e18;
        uint256 strikePrice = 185e8;
        uint256 quantity = 1e18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutOption(solToken, premium, strikePrice, quantity, expiration);

        address[] memory putOptions = factory.getPutOptions();
        putOption = PutOption(putOptions[0]);
    }

    function testBuyAndExecute() public {
        assertEq(putOption.inited(), false);
        assertEq(putOption.strikeValue(), 185e18);

        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption), putOption.strikeValue());
        putOption.init();
        vm.stopPrank();

        assertEq(putOption.inited(), true);
        assertEq(putOption.bought(), false);

        deal(daiToken, buyer, 100e18);
        deal(solToken, buyer, 1e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(putOption), 100e18);
        putOption.buy();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putOption.bought(), true);
        assertEq(putOption.executed(), false);
        assertEq(putOption.buyer(), buyer);

        solERC20.approve(address(putOption), putOption.strikeValue());
        putOption.execute();
        vm.stopPrank();

        assertEq(solERC20.balanceOf(creator), putOption.quantity());
        assertEq(daiERC20.balanceOf(buyer), putOption.strikeValue());
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(putOption.executed(), true);
    }

    function testCancel() public {
        assertEq(putOption.inited(), false);
        assertEq(putOption.strikeValue(), 185e18);

        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption), 185e18);
        putOption.init();

        assertEq(putOption.inited(), true);
        assertEq(putOption.executed(), false);
        assertEq(daiERC20.balanceOf(address(putOption)), 185e18);

        skip(5 days);
        putOption.cancel();
        vm.stopPrank();

        assertEq(putOption.executed(), true);
        assertEq(daiERC20.balanceOf(address(putOption)), 0);
        assertEq(daiERC20.balanceOf(creator), 185e18);
    }

    function testWithdraw() public {
        assertEq(putOption.inited(), false);
        assertEq(putOption.strikeValue(), 185e18);

        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putOption.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putOption), 185e18);
        putOption.init();
        vm.stopPrank();

        assertEq(putOption.inited(), true);
        assertEq(putOption.bought(), false);
        assertEq(daiERC20.balanceOf(address(putOption)), 185e18);

        deal(daiToken, buyer, 100e18);
        deal(solToken, buyer, 1e18);

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

        assertEq(solERC20.balanceOf(buyer), 1e18);
        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(daiERC20.balanceOf(creator), 285e18);
        assertEq(putOption.executed(), true);
    }

    function testExecuteFails() public {
        uint256 _premium = 100e18;
        uint256 _strikePrice = 180e8;
        uint256 _quantity = 1e18;
        uint256 _expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutOption(solToken, _premium, _strikePrice, _quantity, _expiration);

        address[] memory _putOptions = factory.getPutOptions();
        PutOption putOption2 = PutOption(_putOptions[1]);

        assertEq(putOption2.inited(), false);
        assertEq(putOption2.strikeValue(), 180e18);

        ERC20 solERC20 = ERC20(solToken);
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
        deal(solToken, buyer, 1e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(putOption2), 100e18);
        putOption2.buy();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putOption2.bought(), true);
        assertEq(putOption2.executed(), false);
        assertEq(putOption2.buyer(), buyer);

        solERC20.approve(address(putOption2), putOption2.strikeValue());
        vm.expectRevert();
        putOption2.execute();
        vm.stopPrank();

        assertEq(solERC20.balanceOf(buyer), 1e18);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(putOption2.executed(), false);
    }
}
