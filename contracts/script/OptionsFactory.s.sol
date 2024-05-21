// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/primary/Factory.sol";

contract NewFactoryScrollSepolia is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        OptionsFactory factory = new OptionsFactory(0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1);
        factory.setPriceOracle(0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841, 0x87dce67002e66C17BC0d723Fe20D736b80CAaFda);
        factory.setPriceOracle(0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E, 0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41);
        factory.setPriceOracle(0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b, 0xaC3E04999aEfE44D508cB3f9B972b0Ecd07c1efb);
        vm.stopBroadcast();
    }
}