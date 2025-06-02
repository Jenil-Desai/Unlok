// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lock is Ownable {
    mapping(address => mapping(IERC20 => uint256)) private lockedBalances;

    constructor() Ownable(msg.sender) {}

    function deposit(IERC20 _tokenaddress, uint256 _amount) public returns (bool) {
        require(_amount > 0, "Amount must be greater than zero");
        require(_tokenaddress.allowance(msg.sender, address(this)) >= _amount);
        require(_tokenaddress.transferFrom(msg.sender, address(this), _amount));
        lockedBalances[msg.sender][_tokenaddress] += _amount;
        return true;
    }

    function withdraw(IERC20 _tokenaddress, uint256 _amount) public returns (bool) {
        require(_amount > 0, "Amount must be greater than zero");
        require(lockedBalances[msg.sender][_tokenaddress] >= _amount, "Insufficient balance");
        lockedBalances[msg.sender][_tokenaddress] -= _amount;
        require(_tokenaddress.transfer(msg.sender, _amount), "Transfer failed");
        return true;
    }

    function balance(IERC20 _tokenaddress) public view returns (uint256) {
        return lockedBalances[msg.sender][_tokenaddress];
    }
}
