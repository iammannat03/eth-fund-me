// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
  uint256 constant SEND_VALUE = 0.1 ether;

  function fundFundMe(address mostRecentlyDeployed) public {
    vm.startBroadcast();
    FundMe(payable(mostRecentlyDeployed)).fund{
      value: SEND_VALUE
    }();
    vm.stopBroadcast();
    console.log(
      "Funded the 'FundMe' contract with %s",
      SEND_VALUE
    );
  }

  function run() external {
    address mostRecentlyDeployed = DevOpsTools
      .get_most_recent_deployment("FundMe", block.chainid);
    fundFundMe(mostRecentlyDeployed);
  }
}

contract WithdrawFundMe is Script {
  function withdrawFundMe(
    address mostRecentlyDeployed
  ) public {
    FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
    address owner = fundMe.getOwner();
    
    // Check balances before withdrawal
    uint256 contractBalanceBefore = address(fundMe).balance;
    uint256 ownerBalanceBefore = owner.balance;
    
    console.log("=== Before Withdrawal ===");
    console.log("Contract Balance (wei):", contractBalanceBefore);
    console.log("Owner Balance (wei):", ownerBalanceBefore);
    console.log("");
    
    // Perform withdrawal
    console.log("Withdrawing funds...");
    vm.startBroadcast();
    fundMe.withdraw();
    vm.stopBroadcast();
    
    // Check balances after withdrawal
    uint256 contractBalanceAfter = address(fundMe).balance;
    uint256 ownerBalanceAfter = owner.balance;
    
    console.log("=== After Withdrawal ===");
    console.log("Contract Balance (wei):", contractBalanceAfter);
    console.log("Owner Balance (wei):", ownerBalanceAfter);
    console.log("");
    console.log("=== Summary ===");
    console.log("Amount withdrawn (wei):", contractBalanceBefore);
    uint256 withdrawnInTenths = (contractBalanceBefore * 10) / 1e18;
    uint256 withdrawnWhole = withdrawnInTenths / 10;
    uint256 withdrawnTenths = withdrawnInTenths % 10;
    console.log("Amount withdrawn (ETH whole):", withdrawnWhole);
    console.log("Amount withdrawn (ETH tenths):", withdrawnTenths);
    console.log("Owner balance increase (wei):", ownerBalanceAfter - ownerBalanceBefore);
    console.log("Withdrawal successful!");
  }

  function run() external {
    address mostRecentlyDeployed = DevOpsTools
      .get_most_recent_deployment("FundMe", block.chainid);
    console.log("Withdrawing from FundMe contract at:", mostRecentlyDeployed);
    console.log("");
    withdrawFundMe(mostRecentlyDeployed);
  }
}

contract CheckFundMe is Script {
  function checkFundMe(address mostRecentlyDeployed) public view {
    FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
    
    // Check contract ETH balance
    uint256 contractBalance = address(fundMe).balance;
    console.log("Contract ETH Balance:", contractBalance);
    console.log("Contract ETH Balance (ether):", contractBalance / 1e18);
    
    // Check owner
    address owner = fundMe.getOwner();
    console.log("Contract Owner:", owner);
    
    // List all funders
    console.log("\n=== Funders ===");
    uint256 funderIndex = 0;
    bool hasMoreFunders = true;
    
    while (hasMoreFunders) {
      try fundMe.getFunders(funderIndex) returns (address funder) {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(funder);
        console.log("Funder %s:", funderIndex);
        console.log("  Address:", funder);
        console.log("  Amount funded:", amountFunded);
        console.log("  Amount funded (ether):", amountFunded / 1e18);
        funderIndex++;
      } catch {
        hasMoreFunders = false;
      }
    }
    
    console.log("\nTotal number of funders:", funderIndex);
  }

  function run() external view {
    address mostRecentlyDeployed = DevOpsTools
      .get_most_recent_deployment("FundMe", block.chainid);
    console.log("Checking FundMe contract at:", mostRecentlyDeployed);
    checkFundMe(mostRecentlyDeployed);
  }
}
