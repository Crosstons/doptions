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

contract NewFactoryAmoy is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        OptionsFactory factory = new OptionsFactory(0xB1b104D79dE24513338bdB6CB9Df468110010E5F);
        factory.setPriceOracle(0x7A9294c8305F9ee1d245E0f0848E00B1149818C7, 0xe7656e23fE8077D438aEfbec2fAbDf2D8e070C4f);
        factory.setPriceOracle(0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841, 0xF0d50568e3A7e8259E16663972b11910F89BD8e7);
        factory.setPriceOracle(0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E, 0xF8e2648F3F157D972198479D5C7f0D721657Af67);
        factory.setPriceOracle(0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b, 0x001382149eBa3441043c1c66972b4772963f5D43);
        factory.setPriceOracle(0x19Ed533D9f274DC0d1b59FB9C0d5D1C27cba8bb1, 0xc2e2848e28B9fE430Ab44F55a8437a33802a219C);
        factory.setPriceOracle(0xAB5aBA3B6ABB3CdaF5F2176A693B3C012663B6c3, 0xeA8C8E97681863FF3cbb685e3854461976EBd895);
        vm.stopBroadcast();
    }
}

contract NewFactoryCardona is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        OptionsFactory factory = new OptionsFactory(0x7A9294c8305F9ee1d245E0f0848E00B1149818C7);
        factory.setPriceOracle(0x3b5dAAE6d0a1B98EF8B2E6B65206c93c8cE55841, 0xa24A68DD788e1D7eb4CA517765CFb2b7e217e7a3);
        factory.setPriceOracle(0xc302BD52985e75C1f563a47f2b5dfC4e2b5C6C7E, 0xd94522a6feF7779f672f4C88eb672da9222f2eAc);
        factory.setPriceOracle(0x5934C2Ca4c4F7b22526f6ABfD63bB8075a62e65b, 0x1AdDb2368414B3b4cF1BCe7A887d2De7Bfb6886f);

        vm.stopBroadcast();
    }
}