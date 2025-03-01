// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
  FundMe fundMe;

  address USER = makeAddr("user");
  uint256 constant STARTING_BALANCE = 10 ether;
  uint256 constant SEND_VALUE = 0.1 ether;

  function setUp() external {
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(USER, STARTING_BALANCE);
  }

  function testMinimumDollarIsFive() public view {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testOwnerIsMsgSender() public view {
    assertEq(fundMe.getOwner(), msg.sender);
  }

  function testPriceFeedVersionIsAccurate() public view {
    uint256 version = fundMe.getVersion();
    console.log("version is: ", version);
    assertEq(version, 4);
  }

  function testFundFailsWithoutEnoughtEth() public {
    vm.expectRevert();
    fundMe.fund();
  }

  function testFundUpdatesFundedDataStructure() public {
    vm.prank(USER); // the next tx will be sent by USER
    fundMe.fund{value: SEND_VALUE}();
    uint256 amountFunded = fundMe.getAddressToAmountFunded(
      USER
    );
    assertEq(amountFunded, SEND_VALUE);
  }

  function testAddsFunderToArrayOfFunders() public funded {
    address funder = fundMe.getFunders(0);
    assertEq(funder, USER);
  }

  function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    vm.prank(USER);
    fundMe.withdraw();
  }

  modifier funded() {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
  }

  function testWithdrawWithASingleFunder() public funded {
    // Arrange
    uint256 startingOwnerBalance = fundMe
      .getOwner()
      .balance;
    uint256 startingContractBalance = address(fundMe)
      .balance;

    // Act
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();

    // Assert
    assertEq(address(fundMe).balance, 0);
    assertEq(
      fundMe.getOwner().balance,
      startingOwnerBalance + startingContractBalance
    );
  }

  function testWithdrawFromMultipleFunders() public {
    // Arrange
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (
      uint160 i = startingFunderIndex;
      i < numberOfFunders;
      i++
    ) {
      // vm.prank new address
      // vm.deal new address
      // address()

      hoax(address(i), SEND_VALUE);
      fundMe.fund{value: SEND_VALUE}();
    }

    // Act
    uint256 startingOwnerBalance = fundMe
      .getOwner()
      .balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();
    // Assert
    assert(address(fundMe).balance == 0);
    assert(
      fundMe.getOwner().balance ==
        startingOwnerBalance + startingFundMeBalance
    );
  }
}
