// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./AggregatorV3Interface.sol";

contract CallBasketOption {
    struct Asset {
        address assetAddress;
        uint256 quantity;
    }

    Asset[] public assets;
    address public creator;
    uint256 public premium;
    uint256 public strikeValue;
    uint256 public expiration;
    address public buyer;
    bool public inited;
    bool public bought;
    bool public executed;
    IERC20 public premiumToken;
    mapping(address => address) public priceOracles;

    constructor(
        address _creator,
        address[] memory _assets,
        address[] memory _priceOracles,
        uint256[] memory _quantities,
        uint256 _premium,
        uint256 _strikeValue,
        uint256 _expiration,
        address _premiumToken
    ) {
        require(_assets.length == _quantities.length, "Assets and quantities length mismatch");
        require(_assets.length == _priceOracles.length, "Assets and price oracles length mismatch");

        creator = _creator;
        premium = _premium;
        strikeValue = _strikeValue;
        expiration = _expiration;
        buyer = address(0);
        bought = false;
        executed = false;
        premiumToken = IERC20(_premiumToken);

        for (uint256 i = 0; i < _assets.length; i++) {
            assets.push(Asset({assetAddress: _assets[i], quantity: _quantities[i]}));
            priceOracles[_assets[i]] = _priceOracles[i];
        }
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
        for (uint256 i = 0; i < assets.length; i++) {
            require(
                IERC20(assets[i].assetAddress).transferFrom(creator, address(this), assets[i].quantity),
                "Transfer failed"
            );
        }
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
        require(_checkPosition(), "Option is out of the money");

        for (uint256 i = 0; i < assets.length; i++) {
            require(IERC20(assets[i].assetAddress).transfer(buyer, assets[i].quantity), "Asset transfer failed");
        }
        require(premiumToken.transferFrom(buyer, creator, strikeValue), "Payment failed");

        executed = true;
    }

    function _checkPosition() internal view returns (bool) {
        uint256 currentValue = 0;
        for (uint256 i = 0; i < assets.length; i++) {
            currentValue += _getAssetValue(assets[i].assetAddress, assets[i].quantity);
        }
        return currentValue >= strikeValue;
    }

    function _getAssetValue(address asset, uint256 quantity) internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(priceOracles[asset]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return (uint256(price) * quantity) / (10 ** priceFeed.decimals());
    }

    function cancel() external onlyCreator notBought isInited notExpired {
        for (uint256 i = 0; i < assets.length; i++) {
            require(IERC20(assets[i].assetAddress).transfer(creator, assets[i].quantity), "Asset transfer failed");
        }
        executed = true;
    }

    function withdraw() external onlyCreator isInited {
        require(block.timestamp > expiration, "Option not expired yet");
        require(!executed, "Option already executed");

        for (uint256 i = 0; i < assets.length; i++) {
            require(IERC20(assets[i].assetAddress).transfer(creator, assets[i].quantity), "Asset transfer failed");
        }
        executed = true;
    }

    function adjustPremium(uint256 newPremium) external onlyCreator notBought notExpired {
        premium = newPremium;
    }
}
