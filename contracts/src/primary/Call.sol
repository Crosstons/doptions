// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IDIAOracleV2} from "./Dia.sol";

contract CallOption {
    address public asset;
    address public creator;
    uint256 public premium;
    uint256 public strikePrice;
    uint256 public quantity;
    uint256 public expiration;
    address public buyer;
    bool public inited;
    bool public bought;
    bool public executed;
    IERC20 public premiumToken;
    string public assetString;
    IDIAOracleV2 public oracle;

    constructor(
        address _asset,
        address _creator,
        uint256 _premium,
        uint256 _strikePrice,
        uint256 _quantity,
        uint256 _expiration,
        address _premiumToken,
        address _priceOracle,
        string memory _assetString
    ) {
        asset = _asset;
        creator = _creator;
        premium = _premium;
        strikePrice = _strikePrice;
        quantity = _quantity;
        expiration = _expiration;
        buyer = address(0);
        bought = false;
        executed = false;
        inited = false;
        premiumToken = IERC20(_premiumToken);
        oracle = IDIAOracleV2(_priceOracle);
        assetString = _assetString;
    }

    modifier isInited() {
        require(inited, "Contract has not been inited by the creator!");
        _;
    }

    modifier notBought() {
        require(!bought, "Contract has been bought!");
        _;
    }

    modifier notExecuted() {
        require(!executed, "Contract has been executed!");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function!");
        _;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can call this function!");
        _;
    }

    modifier notExpired() {
        require(block.timestamp <= expiration, "Option expired");
        _;
    }

    function init() external onlyCreator {
        require(inited == false, "Option contract has already been initialized");
        require(IERC20(asset).transferFrom(creator, address(this), quantity), "Transfer failed");
        inited = true;
    }

    function buy() external notBought isInited notExpired {
        require(msg.sender != creator, "Creator cannot buy their own option");
        require(premiumToken.transferFrom(msg.sender, creator, premium), "Premium transfer failed");
        buyer = msg.sender;
        bought = true;
    }

    function transfer(address newBuyer) external onlyBuyer isInited notExpired {
        buyer = newBuyer;
    }

    function execute() external onlyBuyer notExecuted isInited notExpired {
        (uint128 latestPrice,) = oracle.getValue(assetString);
        uint256 _price = uint256(latestPrice);

        require(_price >= strikePrice, "Option is out of the money");

        uint256 amountToPay = strikeValue();
        require(premiumToken.transferFrom(buyer, creator, amountToPay), "Payment failed");
        require(IERC20(asset).transfer(buyer, quantity), "Asset transfer failed");

        executed = true;
    }

    function cancel() external onlyCreator notBought isInited notExpired {
        require(IERC20(asset).transfer(creator, quantity), "Asset transfer failed");
        executed = true;
    }

    function withdraw() external onlyCreator isInited {
        require(block.timestamp > expiration, "Option not expired yet");
        require(!executed, "Option already executed");

        require(IERC20(asset).transfer(creator, quantity), "Asset transfer failed");
        executed = true;
    }

    function adjustPremium(uint256 newPremium) external onlyCreator notBought notExpired {
        premium = newPremium;
    }

    function strikeValue() public view returns (uint256) {
        return (strikePrice * quantity) / (10 ** 8);
    }
}
