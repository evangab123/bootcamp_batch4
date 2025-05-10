// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MockUSDC} from "../src/MockUSDC.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    MockUSDC public usdc;
    Vault public vault;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");
    
    function setUp() public {
        usdc = new MockUSDC();
        vault = new Vault(address(usdc));
    }

    function test_Deposit() public {
        //alice
        vm.startPrank(alice);
        usdc.mint(alice,1000);
        usdc.approve(address(vault),1000);
        vault.deposit(1000);
        assertEq(vault.balanceOf(alice),1000);
        vm.stopPrank();

        //bob
        vm.startPrank(bob);
        usdc.mint(bob, 2000);
        usdc.approve(address(vault),2000);
        vault.deposit(2000);
        assertEq(vault.balanceOf(bob),2000);
        vm.stopPrank();

    }

    function test_Scenario() public {

        usdc.mint(alice,1_000_000);
        usdc.mint(bob,2_000_000);
        usdc.mint(charlie,1_000_000);


        vm.startPrank(alice);
        usdc.approve(address(vault),1_000_000);
        vault.deposit(1_000_000);

        assertEq(vault.balanceOf(alice),1_000_000);
        vm.stopPrank();

        vm.startPrank(bob);
        usdc.approve(address(vault),2_000_000);
        vault.deposit(2_000_000);
        assertEq(vault.balanceOf(bob),2_000_000);
        vm.stopPrank();

        usdc.mint(address(this), 1_000_000);
        usdc.approve(address(vault), 1_000_000);
        vault.distributeYield(1_000_000);

        vm.startPrank(charlie);
        usdc.approve(address(vault), 1_000_000);
        vault.deposit(1_000_000);
        assertEq(vault.balanceOf(charlie), 750_000);
        vm.stopPrank();


        vm.startPrank(alice);
        vault.withdraw(1_000_000);
        assertEq(usdc.balanceOf(alice), 1_333_333);
        vm.stopPrank();

        vm.startPrank(bob);
        vault.withdraw(2_000_000);
        assertEq(usdc.balanceOf(bob), 2_666_666);
        vm.stopPrank();
    }
}


