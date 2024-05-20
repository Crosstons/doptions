// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/primary/AggregatorV3Interface.sol";

contract OptionsFactoryTest is Test {
    OptionsFactory public factory;
    ERC20 public premiumToken;
    ERC20 public assetToken;
    address public priceOracle;

    address public creator = address(1);
    address public buyer = address(2);

    function setUp() public {
        premiumToken = ERC20(makeAddr("usdt"));
        assetToken = ERC20(makeAddr("btc"));
        priceOracle = 0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f;

        factory = new OptionsFactory(address(premiumToken));
        factory.setPriceOracle(address(assetToken), address(priceOracle));
    }

    function testCreateCallOption() public {
        uint256 premium = 100 * 10 ** 18;
        uint256 strikePrice = 1500 * 10 ** 18;
        uint256 quantity = 1 * 10 ** 18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createCallOption(address(assetToken), premium, strikePrice, quantity, expiration);

        address[] memory callOptions = factory.getCallOptions();
        assertEq(callOptions.length, 1);

        CallOption callOption = CallOption(callOptions[0]);
        assertEq(callOption.asset(), address(assetToken));
        assertEq(callOption.premium(), premium);
        assertEq(callOption.strikePrice(), strikePrice);
        assertEq(callOption.quantity(), quantity);
        assertEq(callOption.expiration(), expiration);
    }

    function testCreatePutOption() public {
        uint256 premium = 100 * 10 ** 18;
        uint256 strikePrice = 1500 * 10 ** 18;
        uint256 quantity = 1 * 10 ** 18;
        uint256 expiration = block.timestamp + 1 weeks;

        vm.prank(creator);
        factory.createPutOption(address(assetToken), premium, strikePrice, quantity, expiration);

        address[] memory putOptions = factory.getPutOptions();
        assertEq(putOptions.length, 1);

        PutOption putOption = PutOption(putOptions[0]);
        assertEq(putOption.asset(), address(assetToken));
        assertEq(putOption.premium(), premium);
        assertEq(putOption.strikePrice(), strikePrice);
        assertEq(putOption.quantity(), quantity);
        assertEq(putOption.expiration(), expiration);
    }
}
