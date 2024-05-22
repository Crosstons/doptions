// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/BasketFactory.sol";
import "../src/primary/PutBasket.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PutBasketTest is Test {
    BasketFactory public factory;
    address daiToken = 0xDc61d022126ccB074cE31f4cF66E847d0086a58E;
    address btcToken = 0x56Ef60eec47Fcd38D48c7b693972aE29D6efFcED;
    address btcPriceOracle = 0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f;
    address solToken = 0x13F793FAadA9b42BeFEF18048658813CF6FE790F;
    address solPriceOracle = 0xF8e2648F3F157D972198479D5C7f0D721657Af67;
    PutBasketOption putBasket;

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
        uint256 strikeValue = 7780e18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutBasketOption(assets, priceOracles, quantities, premium, strikeValue, expiration);

        address[] memory putBaskets = factory.getPutBaskets();
        putBasket = PutBasketOption(putBaskets[0]);
    }

    function testBuyAndExecute() public {
        assertEq(putBasket.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putBasket.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putBasket), putBasket.strikeValue());
        putBasket.init();
        vm.stopPrank();

        assertEq(putBasket.inited(), true);
        assertEq(putBasket.bought(), false);

        deal(daiToken, buyer, 100e18);
        deal(btcToken, buyer, 1e17);
        deal(solToken, buyer, 1e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(putBasket), 100e18);
        putBasket.buy();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putBasket.bought(), true);
        assertEq(putBasket.executed(), false);
        assertEq(putBasket.buyer(), buyer);

        btcERC20.approve(address(putBasket), 1e17);
        solERC20.approve(address(putBasket), 1e18);
        putBasket.execute();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(creator), 1e17);
        assertEq(solERC20.balanceOf(creator), 1e18);
        assertEq(daiERC20.balanceOf(buyer), putBasket.strikeValue());
        assertEq(daiERC20.balanceOf(creator), 100e18);
        assertEq(putBasket.executed(), true);
    }

    function testCancel() public {
        assertEq(putBasket.inited(), false);

        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putBasket.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putBasket), putBasket.strikeValue());
        putBasket.init();

        assertEq(putBasket.inited(), true);
        assertEq(putBasket.executed(), false);
        assertEq(daiERC20.balanceOf(address(putBasket)), putBasket.strikeValue());

        skip(5 days);
        putBasket.cancel();
        vm.stopPrank();

        assertEq(putBasket.executed(), true);
        assertEq(daiERC20.balanceOf(address(putBasket)), 0);
        assertEq(daiERC20.balanceOf(creator), putBasket.strikeValue());
    }

    function testWithdraw() public {
        assertEq(putBasket.inited(), false);

        ERC20 btcERC20 = ERC20(btcToken);
        ERC20 solERC20 = ERC20(solToken);
        ERC20 daiERC20 = ERC20(daiToken);

        deal(daiToken, creator, putBasket.strikeValue());

        vm.startPrank(creator);
        daiERC20.approve(address(putBasket), putBasket.strikeValue());
        putBasket.init();
        vm.stopPrank();

        assertEq(putBasket.inited(), true);
        assertEq(putBasket.bought(), false);

        deal(daiToken, buyer, 100e18);
        deal(btcToken, buyer, 1e17);
        deal(solToken, buyer, 1e18);

        vm.startPrank(buyer);
        daiERC20.approve(address(putBasket), 100e18);
        putBasket.buy();
        vm.stopPrank();

        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(putBasket.bought(), true);
        assertEq(putBasket.executed(), false);
        assertEq(putBasket.buyer(), buyer);

        vm.warp(block.timestamp + 8 days);
        vm.prank(creator);
        putBasket.withdraw();
        vm.stopPrank();

        assertEq(btcERC20.balanceOf(creator), 0);
        assertEq(solERC20.balanceOf(creator), 0);
        assertEq(daiERC20.balanceOf(buyer), 0);
        assertEq(daiERC20.balanceOf(creator), putBasket.strikeValue() + 100e18);
        assertEq(putBasket.executed(), true);
    }
}