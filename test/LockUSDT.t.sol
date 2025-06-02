// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { Lock } from "../src/Lock.sol";
import { USDT } from "../src/USDT.sol";

contract LockUSDTTest is Test {
  USDT public usdt;
  Lock public lock;

  function setUp() public {
    usdt = new USDT();
    lock = new Lock();
  }

  function test_Deposit() public {
    usdt.mint(0x015a239874606A99Edb2dcAB3025fBCd286731b4, 500);
    vm.startPrank(0x015a239874606A99Edb2dcAB3025fBCd286731b4);

    usdt.approve(address(lock), 500);
    lock.deposit(usdt, 500);
    assertEq(lock.balance(usdt), 500);

    lock.withdraw(usdt, 300);
    assertEq(usdt.balanceOf(0x015a239874606A99Edb2dcAB3025fBCd286731b4), 300);
    assertEq(usdt.balanceOf(address(lock)), 200);
  }
}
