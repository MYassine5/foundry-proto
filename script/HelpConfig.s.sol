//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3.sol";

contract helpconfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant PRICE = 2000e8;
    networkconfig public activeNetwork;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getsepoliaeth();
        } else if (block.chainid == 1) {
            activeNetwork = getmethprice();
        } else {
            activeNetwork = getanvileth();
        }
    }

    struct networkconfig {
        address priceFeed;
    }

    function getsepoliaeth() public pure returns (networkconfig memory) {
        networkconfig memory sepoliaconfig = networkconfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaconfig;
    }

    function getmethprice() public pure returns (networkconfig memory) {
        networkconfig memory ethconfig = networkconfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethconfig;
    }

    function getanvileth() public returns (networkconfig memory) {
        if (activeNetwork.priceFeed != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, PRICE);
        vm.stopBroadcast();
        networkconfig memory anvilconfig = networkconfig({
            priceFeed: address(mock)
        });
        return anvilconfig;
    }
}
