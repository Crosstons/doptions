// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/primary/BasketFactory.sol";
import "../src/primary/CallBasket.sol";
import "../src/primary/PutBasket.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BasketFactoryTest is Test {
    BasketFactory public factory;
    address usdcToken = 0xDc61d022126ccB074cE31f4cF66E847d0086a58E;
    address btcToken = 0x56Ef60eec47Fcd38D48c7b693972aE29D6efFcED;
    address btcPriceOracle = 0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f;
    address solToken = 0x13F793FAadA9b42BeFEF18048658813CF6FE790F;
    address solPriceOracle = 0xF8e2648F3F157D972198479D5C7f0D721657Af67;

    address creator = makeAddr("creator");
    address buyer = makeAddr("buyer");

    function setUp() public {
        factory = new BasketFactory(usdcToken);
        factory.setPriceOracle(btcToken, btcPriceOracle);
        factory.setPriceOracle(solToken, solPriceOracle);
    }

    function testCreateCallBasket() public {
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
        assertEq(callBaskets.length, 1);

        CallBasketOption callOption = CallBasketOption(callBaskets[0]);
        assertEq(callOption.premium(), premium);
        assertEq(callOption.strikeValue(), strikeValue);
        assertEq(callOption.expiration(), expiration);
    }

    function testCreatePutBasket() public {
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
        factory.createPutBasketOption(assets, priceOracles, quantities, premium, strikeValue, expiration);

        address[] memory putBaskets = factory.getPutBaskets();
        assertEq(putBaskets.length, 1);

        PutBasketOption callOption = PutBasketOption(putBaskets[0]);
        assertEq(callOption.premium(), premium);
        assertEq(callOption.strikeValue(), strikeValue);
        assertEq(callOption.expiration(), expiration);
    }
}