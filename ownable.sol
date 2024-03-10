// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ownable {
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the contract owner can call this function");
    _;
  }
}
