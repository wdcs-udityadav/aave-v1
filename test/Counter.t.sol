// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;

import {Test, console} from "forge-std/Test.sol";
import {AaveV1} from "../src/AaveV1.sol";

contract AaveV1Test is Test {
    AaveV1 public aaveV1;

    function setUp() public {
        aaveV1 = new AaveV1();
    }
}
