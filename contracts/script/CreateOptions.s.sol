// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/primary/Factory.sol";
import "../src/primary/Call.sol";
import "../src/primary/Put.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TestTokens.s.sol";

contract CreateOption is Script {

    OptionsFactory factory;
    address asset;

    function setUp() public {
        factory = OptionsFactory(0x4633BFBb343F131deF95ac1fd518Ed4495092063);
        asset = 0x7A9294c8305F9ee1d245E0f0848E00B1149818C7;
    }

    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");

        uint256 premium = 10e18;
        uint256 strikePrice = 65000e8;
        uint256 quantity = 1e16;
        uint256 expiration = block.timestamp + 2 weeks;

        vm.startBroadcast(privateKey);
        factory.createPutOption(asset, premium, strikePrice, quantity, expiration);
        vm.stopBroadcast();

    }
}

contract InitOption is Script {

    PutOption putOption;
    Token aUSDT;

    function setUp() public {
        putOption = PutOption(0x2DE7f048E4D99784983CfE24193B6e8818F91503);
        aUSDT = Token(0xB1b104D79dE24513338bdB6CB9Df468110010E5F);
    }

    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        aUSDT.approve(address(putOption), putOption.strikeValue());
        putOption.init();
        vm.stopBroadcast();
    }

}