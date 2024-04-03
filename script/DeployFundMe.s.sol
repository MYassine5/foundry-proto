//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {helpconfig} from "../script/HelpConfig.s.sol";

contract DeployFundMe is Script {
    function run() public returns (FundMe) {
        helpconfig config = new helpconfig();
        address ethprice = config.activeNetwork();
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethprice);
        vm.stopBroadcast();
        return fundme;
    }
}
