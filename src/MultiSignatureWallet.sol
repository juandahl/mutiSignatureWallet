// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";

interface ERC20 {
  function transfer(address recipient, uint256 amount) external returns (bool);
  function balanceOf(address account) external view returns (uint256);
}

contract MultiSignatureWallet is Ownable {
  address[] signersWhitelist;
  uint minSignatures;
  ERC20 public token;
  // percentage of total transfered
  uint fee;


  struct RequireTransfer {
    address[] signs;
    address to;
    uint amount;
  }
  RequireTransfer[] private requireTransfers;

  // Events
  event RequestTransferTokens(address indexed requestAddress, address indexed to, uint amount, uint indexed transferId);
  event ApproveTransferTokens(address indexed from, address indexed to, uint amount, uint indexed transferId);

  constructor(address _tokenAddress) {
    token = ERC20(_tokenAddress);
  }

  function inArray(address[] memory array, address value) private pure returns(bool) {
    bool found = false;
    for (uint i = 0; i < array.length; i++) {
      if (array[i] == value) {
        found = true;
        break;
      }
    }
    return found;
  }

  modifier onlyWhitelisted {
    bool isWhitelisted = inArray(signersWhitelist, msg.sender);
    require(isWhitelisted, "Address is not whitelisted");
    _;
  }

  function setMinSignature(uint128 x) public onlyOwner {
    minSignatures = x;
  }

  function addSigner(address newSigner) public onlyOwner {
    signersWhitelist.push(newSigner);
  }

  function removeSigner(address signerToRemove) public onlyOwner {
    for (uint i = 0; i < signersWhitelist.length; i++) {
      if (signersWhitelist[i] == signerToRemove) {
        signersWhitelist[i] = signersWhitelist[signersWhitelist.length - 1];
        signersWhitelist.pop();
        break;
      }
    }
  }
  function transferTokens(address to, uint amount) private {
    uint total = amount + amount * fee;
    require(token.balanceOf(address(this)) >= total, "balance does not enough to transfer");

    token.transfer(to, amount);
  }

  function requestTransferTokens(address to, uint amount) public {
    requireTransfers.push(RequireTransfer({
      signs: new address[](0),
      to: to,
      amount: amount
    }));

    emit RequestTransferTokens(msg.sender, to, amount, requireTransfers.length);
  }

  
  function approveTransferTokens(uint pos) public onlyWhitelisted {
    require(requireTransfers.length > pos, "pos invalid");
    RequireTransfer storage current = requireTransfers[pos];
    require(!inArray(current.signs, msg.sender), "user already sign");
    
    current.signs.push(msg.sender);
    if (current.signs.length >= minSignatures) {
      transferTokens(current.to, current.amount);
    }

    emit ApproveTransferTokens(msg.sender, current.to, current.amount, pos);
  }

  function withdraw() external onlyOwner {
    uint balance = address(this).balance;
    require(balance > 0, "No balance to withdraw");

    payable(owner).transfer(balance);
}
}