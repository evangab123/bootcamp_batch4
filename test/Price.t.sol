// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Price} from "../src/Price.sol";

contract PriceTest is Test {
    Price public price;

    function setUp() public {
        vm.createSelectFork("https://arb-mainnet.g.alchemy.com/v2/JNO4ojiS0GbXZimXOBWO1Ji4KKXWxtWo", 151362128);
        price = new Price();
    }

    function test_getPrice() public {
        uint256 priceValue = price.getPrice();
        console.log("Price: ", priceValue);
        assertGt(priceValue, 0);
    }
}
