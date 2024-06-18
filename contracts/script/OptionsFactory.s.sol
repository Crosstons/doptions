// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/primary/Factory.sol";

contract NewFactoryBaseSepolia is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("DEV_PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        OptionsFactory factory = new OptionsFactory(0x10Cbc80974281fE66f41C26cA69490820432FaA2);
        factory.setPriceOracle(0x01aa350e8A61EF1134773B2c69AcCFD0Eceb6a4F, 0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298);
        factory.setPriceOracle(0xDd5E5A90B2FB4312439Df8ae213FD99D5f1796D9, 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1);
        factory.setPriceOracle(0x214757038fdB549B1E46774d006CFba35667Ff1E, 0xb113F5A928BCfF189C998ab20d753a47F9dE5A61);
        vm.stopBroadcast();
    }
}