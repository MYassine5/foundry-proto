// SPDX-License-Identifier: MIT
// fund
// withdraw
pragma solidity ^0.8.18;
import {Script, console} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostrecent) public {
        vm.startBroadcast();
        FundMe(payable(mostrecent)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("funded with %s", SEND_VALUE);
    }

    function run() external {
        address mostrecent = DevOpsTools.get_most_recent_deployment(
            "fundme",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostrecent);
        vm.stopBroadcast();
    }
}

contract Withdrawfundme is Script {
    function withdrawfundme(address mostrecent) public {
        vm.startBroadcast();
        FundMe(payable(mostrecent)).withdraw();
        vm.stopBroadcast();
        console.log("withdrawn with %s");
    }

    function run() external {
        address mostrecent = DevOpsTools.get_most_recent_deployment(
            "fundme",
            block.chainid
        );
        vm.startBroadcast();
        withdrawfundme(mostrecent);
        vm.stopBroadcast();
    }
}
