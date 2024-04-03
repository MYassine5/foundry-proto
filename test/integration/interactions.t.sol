//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, Withdrawfundme} from "../../script/interactions.s.sol";

contract FundMeTestInteractions is Test {
    uint256 constant amount = 0.1 ether;
    uint256 constant dealtAmount = 10 ether;
    uint256 constant gasprice = 1;
    address alice = makeAddr("Alice");
    FundMe fundme;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(alice, dealtAmount);
    }

    function testusercanfundinteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));

        Withdrawfundme withdrawfundme = new Withdrawfundme();
        withdrawfundme.withdrawfundme(address(fundme));
        assert(address(fundme).balance == 0);
    }
}
