// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/primary/Factory.sol";

contract NewFactoryLineaSepolia is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("DEV_PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        OptionsFactory factory = new OptionsFactory(0x7A9294c8305F9ee1d245E0f0848E00B1149818C7, 0x533D3c1df8D238374065FB3341c34754e4BFCE8E);
        factory.setPairId(0x817BB339d55A0a66EA680EE849a931416b575Ff2, "BTC/USD");
        vm.stopBroadcast();
    }
}
