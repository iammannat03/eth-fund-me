// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "./DeployFundMe.s.sol";

contract DemoFundMe is Script {
    uint256 constant FUND_AMOUNT = 0.1 ether;


    function run() external {
        // Get deployer address
        address deployer = msg.sender;
        console.log("=== FundMe Demo Script ===");
        console.log("Deployer:", deployer);
        console.log("");

        // Step 1: Deploy the contract
        console.log("Step 1: Deploying FundMe contract...");
        DeployFundMe deployerScript = new DeployFundMe();
        FundMe fundMe = deployerScript.run();
        console.log("FundMe deployed at:", address(fundMe));
        console.log("Contract owner:", fundMe.getOwner());
        console.log("");

        // Step 2: Fund from deployer account (multiple times to simulate multiple funders)
        console.log("Step 2: Funding contract from deployer...");
        vm.startBroadcast();
        
        // First funding
        fundMe.fund{value: FUND_AMOUNT}();
        console.log("Funding #1: Funded with", FUND_AMOUNT, "wei");
        console.log("Funding #1: That's 0.1 ETH (100000000000000000 wei = 0.1 ether)");
        
        // Second funding (same account can fund multiple times)
        fundMe.fund{value: FUND_AMOUNT}();
        console.log("Funding #2: Funded with", FUND_AMOUNT, "wei");
        console.log("Funding #2: That's 0.1 ETH");
        
        vm.stopBroadcast();
        console.log("");

        // Step 3: Check contract status
        console.log("Step 3: Checking contract status...");
        uint256 contractBalance = address(fundMe).balance;
        console.log("Contract ETH Balance (wei):", contractBalance);
        // Calculate ETH properly: multiply by 10 first to show one decimal
        uint256 balanceInTenths = (contractBalance * 10) / 1e18;
        uint256 wholeEth = balanceInTenths / 10;
        uint256 tenths = balanceInTenths % 10;
        console.log("Contract ETH Balance:", wholeEth);
        console.log("Contract ETH Balance (tenths):", tenths);
        console.log("Contract Owner:", fundMe.getOwner());
        console.log("");

        // Step 4: List all funders
        console.log("Step 4: Listing all funders...");
        uint256 funderIndex = 0;
        bool hasMoreFunders = true;

        while (hasMoreFunders) {
            try fundMe.getFunders(funderIndex) returns (address funder) {
                uint256 amountFunded = fundMe.getAddressToAmountFunded(funder);
                uint256 amountInTenths = (amountFunded * 10) / 1e18;
                uint256 wholeAmount = amountInTenths / 10;
                uint256 amountTenths = amountInTenths % 10;
                console.log("Funder", funderIndex);
                console.log("  Address:", funder);
                console.log("  Amount (wei):", amountFunded);
                console.log("  Amount (ETH whole):", wholeAmount);
                console.log("  Amount (ETH tenths):", amountTenths);
                funderIndex++;
            } catch {
                hasMoreFunders = false;
            }
        }
        console.log("Total funders:", funderIndex);
        console.log("");

        // Step 5: Check deployer's total funding
        console.log("Step 5: Checking deployer's total funding...");
        uint256 deployerFunded = fundMe.getAddressToAmountFunded(deployer);
        uint256 deployerInTenths = (deployerFunded * 10) / 1e18;
        uint256 deployerWhole = deployerInTenths / 10;
        uint256 deployerTenths = deployerInTenths % 10;
        console.log("Deployer funded (wei):", deployerFunded);
        console.log("Deployer funded (ETH whole):", deployerWhole);
        console.log("Deployer funded (ETH tenths):", deployerTenths);
        console.log("");

        // Step 6: Summary
        console.log("=== Demo Summary ===");
        console.log("Contract Address:", address(fundMe));
        console.log("Total ETH in contract (wei):", contractBalance);
        console.log("Total ETH in contract (ETH whole):", wholeEth);
        console.log("Total ETH in contract (ETH tenths):", tenths);
        console.log("Total funders:", funderIndex);
        console.log("Contract Owner:", fundMe.getOwner());
        console.log("");
        console.log("Demo completed successfully!");
        console.log("");
        console.log("Next steps:");
        console.log("  - To fund from other accounts, use: make fund-fundMe-anvil");
        console.log("  - To check funds: make check-fundMe-anvil");
        console.log("  - To withdraw funds: make withdraw-fundMe-anvil");
    }
}
