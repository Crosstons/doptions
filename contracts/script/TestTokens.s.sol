// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}

contract TokenScript is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        address account = vm.addr(privateKey);

        vm.startBroadcast(privateKey);
        Token token = new Token("zkSync USDT", "sUSDT");
        token.mint(account, 100e18);

        Token token2 = new Token("zkSync BTC", "sBTC");
        token2.mint(account, 10e18);

        Token token3 = new Token("zkSync ETH", "sETH");
        token3.mint(account, 10e18);

        Token token4 = new Token("zkSync LINK", "sLINK");
        token4.mint(account, 10e18);

        vm.stopBroadcast();
    }
}