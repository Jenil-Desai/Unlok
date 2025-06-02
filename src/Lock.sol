// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lock is Ownable {
    struct LockInfo {
        uint256 amount;
        address tokenAddress;
    }

    mapping(address => LockInfo) private lockedBalances;

    constructor() Ownable(msg.sender) {}

    function deposit(IERC20 _tokenaddress, uint _amount) public returns (bool) {
        require(_amount > 0, "Amount must be greater than zero");
        require(_tokenaddress.allowance(msg.sender, address(this)) >= _amount);
        require(_tokenaddress.transferFrom(msg.sender, address(this), _amount));
        lockedBalances[msg.sender].amount += _amount;
        lockedBalances[msg.sender].tokenAddress = address(_tokenaddress);
        return true;
    }

    function withdraw() public {}

    function balance() public view returns (uint256) {
        return lockedBalances[msg.sender].amount;
    }
}
