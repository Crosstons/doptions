// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface OptionContract {
    function buyer() external view returns (address);

    function transfer(address newBuyer) external;
}
