//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    uint256 constant amount = 0.1 ether;
    uint256 constant dealtAmount = 10 ether;
    uint256 constant gasprice = 1;
    address alice = makeAddr("Alice");
    FundMe fundme;
    uint256 number = 1;

    function setUp() public {
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(alice, dealtAmount);
    }

    function testminimumusd() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testmsgsenderowner() public view {
        console.log(msg.sender);
        console.log(fundme.getowner());
        assertEq(fundme.getowner(), msg.sender);
    }

    function testpriceversion() public view {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testnotEnoughEth() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testEnoughEth() public {
        vm.prank(alice);
        fundme.fund{value: amount}();
        uint256 amountFunded = fundme.getaddresstoamount(alice);
        assertEq(amountFunded, amount);
    }

    function testaddfunders() public {
        vm.prank(alice);
        fundme.fund{value: amount}();
        address funder = fundme.getfunder(0);
        assertEq(funder, alice);
    }

    modifier funded() {
        vm.prank(alice);
        fundme.fund{value: amount}();
        _;
    }

    function testWithdraw() public funded {
        vm.expectRevert();
        vm.prank(alice);
        fundme.withdraw();
    }

    function testWithdrawWorks() public funded {
        // Arrange
        uint256 startingownerbalance = fundme.getowner().balance;
        uint256 startingfundmebalance = address(fundme).balance;
        // Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(gasprice);
        vm.prank(fundme.getowner());
        fundme.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasused = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasused);
        //Assert
        uint256 endingownerbalance = fundme.getowner().balance;
        uint256 endingfundmebalance = address(fundme).balance;
        assertEq(endingfundmebalance, 0);
        assertEq(
            startingfundmebalance + startingownerbalance,
            endingownerbalance
        );
    }

    function testWithdrawBulk() public funded {
        uint160 startingfunderindex = 1;
        uint160 numberoffunders = 10;
        for (uint160 i = startingfunderindex; i < numberoffunders; i++) {
            hoax(address(i), amount);
            fundme.fund{value: amount}();
        }
        uint256 startingfundmebalance = address(fundme).balance;
        uint256 startingownerbalance = fundme.getowner().balance;
        vm.startPrank(fundme.getowner());
        fundme.withdraw();
        vm.stopPrank();
        assert(address(fundme).balance == 0);
        assert(
            startingfundmebalance + startingownerbalance ==
                fundme.getowner().balance
        );
    }

    function testcheaperWithdrawBulk() public funded {
        uint160 startingfunderindex = 1;
        uint160 numberoffunders = 10;
        for (uint160 i = startingfunderindex; i < numberoffunders; i++) {
            hoax(address(i), amount);
            fundme.fund{value: amount}();
        }
        uint256 startingfundmebalance = address(fundme).balance;
        uint256 startingownerbalance = fundme.getowner().balance;
        vm.startPrank(fundme.getowner());
        fundme.cheaperWithdraw();
        vm.stopPrank();
        assert(address(fundme).balance == 0);
        assert(
            startingfundmebalance + startingownerbalance ==
                fundme.getowner().balance
        );
    }

    function testcheaperWithdraw() public funded {
        // Arrange
        uint256 startingownerbalance = fundme.getowner().balance;
        uint256 startingfundmebalance = address(fundme).balance;
        // Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(gasprice);
        vm.prank(fundme.getowner());
        fundme.cheaperWithdraw();
        uint256 gasEnd = gasleft();
        uint256 gasused = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasused);
        //Assert
        uint256 endingownerbalance = fundme.getowner().balance;
        uint256 endingfundmebalance = address(fundme).balance;
        assertEq(endingfundmebalance, 0);
        assertEq(
            startingfundmebalance + startingownerbalance,
            endingownerbalance
        );
    }
}
