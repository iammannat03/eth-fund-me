// SPDX-License-Identifier: MIT
// FUND
// WITHDRAW

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
  function fundFundMe(address mostRecentlyDeployed) public {
    vm.startBroadcast();
  }

  function run() external {
    address mostRecentlyDeployed = DevOpsTools
      .get_most_recent_deployment("FundMe", block.chainid);
  }
}

contract WithdrawFundMe is Script {}
