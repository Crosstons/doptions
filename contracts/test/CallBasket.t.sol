// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/BasketFactory.sol";
import "../src/primary/CallBasket.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CallBasketTest is Test {
    BasketFactory public factory;
    address daiToken = 0xDc61d022126ccB074cE31f4cF66E847d0086a58E;
    address btcToken = 0x56Ef60eec47Fcd38D48c7b693972aE29D6efFcED;
    address btcPriceOracle = 0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f;
    address solToken = 0x13F793FAadA9b42BeFEF18048658813CF6FE790F;
    address solPriceOracle = 0xF8e2648F3F157D972198479D5C7f0D721657Af67;
    CallBasketOption callBasket;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new BasketFactory(daiToken);
        factory.setPriceOracle(btcToken, btcPriceOracle);
        factory.setPriceOracle(solToken, solPriceOracle);
        address[] memory assets = new address[](2);
        assets[0] = btcToken;
        assets[1] = solToken;
        address[] memory priceOracles = new address[](2);
        priceOracles[0] = btcPriceOracle;
        priceOracles[1] = solPriceOracle;
        uint256[] memory quantities = new uint256[](2);
        quantities[0] = 1e17;
        quantities[1] = 1e18;

        uint256 premium = 100e18;
        uint256 strikeValue = 6780e18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallBasketOption(assets, priceOracles, quantities, premium, strikeValue, expiration);

        address[] memory callBaskets = factory.getCallBaskets();
        callBasket = CallBasketOption(callBaskets[0]);
    }

    function testBuyAndExecute() public {
        assertEq(callBasket.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(btcToken, creator, 1e17);
        deal(solToken, creator, 1e18);

        vm.startPrank(creator);
        solERC20.approve(address(callBasket), 1e18);
        btcERC20.approve(address(callBasket), 1e17);
        callBasket.init();
        vm.stopPrank();

        assertEq(callBasket.inited(), true);
        assertEq(callBasket.bought(), false);

        deal(daiToken, buyer, 6880e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(callBasket), 100e18);
        callBasket.buy();

        assertEq(callBasket.bought(), true);
        assertEq(callBasket.executed(), false);
        assertEq(callBasket.buyer(), buyer);

        daiERC20.approve(address(callBasket), callBasket.strikeValue());
        callBasket.execute();
        vm.stopPrank();

        assertEq(solERC20.balanceOf(buyer), 1e18);
        assertEq(btcERC20.balanceOf(buyer), 1e17);
        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(daiERC20.balanceOf(creator), 6880e18);
        assertEq(callBasket.executed(), true);
    }

    function testCancel() public {
        assertEq(callBasket.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 solERC20 = ERC20(solToken);

        deal(btcToken, creator, 1e17);
        deal(solToken, creator, 1e18);

        vm.startPrank(creator);
        solERC20.approve(address(callBasket), 1e18);
        btcERC20.approve(address(callBasket), 1e17);
        callBasket.init();

        assertEq(callBasket.inited(), true);
        assertEq(callBasket.executed(), false);
        assertEq(solERC20.balanceOf(address(callBasket)), 1e18);
        assertEq(btcERC20.balanceOf(address(callBasket)), 1e17);

        skip(5 days);
        callBasket.cancel();
        vm.stopPrank();

        assertEq(callBasket.executed(), true);
        assertEq(solERC20.balanceOf(address(callBasket)), 0);
        assertEq(btcERC20.balanceOf(address(callBasket)), 0);
        assertEq(solERC20.balanceOf(creator), 1e18);
        assertEq(btcERC20.balanceOf(creator), 1e17);
    }

    function testWithdraw() public {
        assertEq(callBasket.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(btcToken, creator, 1e17);
        deal(solToken, creator, 1e18);

        vm.startPrank(creator);
        solERC20.approve(address(callBasket), 1e18);
        btcERC20.approve(address(callBasket), 1e17);
        callBasket.init();
        vm.stopPrank();

        assertEq(callBasket.inited(), true);
        assertEq(callBasket.bought(), false);

        deal(daiToken, buyer, 6880e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(callBasket), 100e18);
        callBasket.buy();
        vm.stopPrank();

        assertEq(callBasket.bought(), true);
        assertEq(callBasket.executed(), false);
        assertEq(callBasket.buyer(), buyer);

        vm.warp(block.timestamp + 8 days);
        vm.prank(creator);
        callBasket.withdraw();

        assertEq(btcERC20.balanceOf(creator), 1e17);
        assertEq(solERC20.balanceOf(creator), 1e18);
        assertEq(daiERC20.balanceOf(buyer), 6780e18);
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(callBasket.executed(), true);
    }
}