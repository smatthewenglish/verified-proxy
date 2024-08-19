// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {Counter} from "../src/Counter.sol";
import {TransparentUpgradeableProxy} from "../src/TransparentUpgradeableProxy.sol";

contract CounterTest is Test {

    TransparentUpgradeableProxy public transparentUpgradeableProxy;
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);

        address logic = address(counter);
        address initialOwner = address(this);
        bytes memory data = "";

        transparentUpgradeableProxy = new TransparentUpgradeableProxy(logic, initialOwner, data);
    }

    function test_Increment() public {
        Counter instance = Counter(address(transparentUpgradeableProxy));
        instance.increment();
        assertEq(instance.number(), 1);
        assertEq(counter.number(), 0);
    }

    function testFuzz_SetNumber(uint256 x) public {
        Counter instance = Counter(address(transparentUpgradeableProxy));
        instance.setNumber(x);
        assertEq(instance.number(), x);
        assertEq(counter.number(), 0);
    }
}
