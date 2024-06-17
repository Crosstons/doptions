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
        OptionsFactory factory = new OptionsFactory(0x7A9294c8305F9ee1d245E0f0848E00B1149818C7);
        vm.stopBroadcast();
    }
}
