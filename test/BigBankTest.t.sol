// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Bank.sol";
import "../src/BigBank.sol";
import "../src/IBank.sol";

contract BigBankTest is Test {
    Bank public bank;
    BigBank public bigBank;
    address public user1;
    address public user2;
    address public owner;
    
    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        
        bank = new Bank();
        bigBank = new BigBank();
        
        // 给测试账户一些ETH
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }
    
    // 测试Bank合约实现了IBank接口
    function testBankImplementsIBank() public {
        assertTrue(address(bank) != address(0));
        // Bank合约应该能够调用IBank的方法
        assertEq(bank.getBalance(), 0);
    }
    
    // 测试BigBank继承自Bank
    function testBigBankInheritsBank() public {
        assertTrue(address(bigBank) != address(0));
        assertEq(bigBank.getBalance(), 0);
        assertEq(bigBank.MIN_DEPOSIT(), 0.001 ether);
    }
    
    // 测试BigBank的最小存款限制
    function testBigBankMinDepositRequirement() public {
        vm.startPrank(user1);
        
        // 尝试存款少于0.001 ether，应该失败
        vm.expectRevert("Deposit must be greater than 0.001 ether");
        bigBank.deposit{value: 0.0005 ether}();
        
        // 存款大于0.001 ether，应该成功
        bigBank.deposit{value: 0.002 ether}();
        assertEq(bigBank.depositors(user1), 0.002 ether);
        
        vm.stopPrank();
    }
    
    // 测试BigBank的receive函数最小存款限制
    function testBigBankReceiveMinDeposit() public {
        vm.startPrank(user1);
        
        // 尝试通过receive发送少于0.001 ether，应该失败
        vm.expectRevert("Deposit must be greater than 0.001 ether");
        address(bigBank).call{value: 0.0005 ether}("");
        
        // 通过receive发送大于0.001 ether，应该成功
        (bool success,) = address(bigBank).call{value: 0.002 ether}("");
        assertTrue(success);
        assertEq(bigBank.depositors(user1), 0.002 ether);
        
        vm.stopPrank();
    }
    
    // 测试管理员转移功能
    function testTransferAdmin() public {
        address newAdmin = address(0x999);
        
        // 记录转移前的管理员
        address oldAdmin = bigBank.getAdmin();
        assertEq(oldAdmin, address(this));
        
        // 转移管理员权限
        vm.expectEmit(true, true, false, false);
        emit BigBank.AdminTransferred(oldAdmin, newAdmin);
        bigBank.transferAdmin(newAdmin);
        
        // 验证新管理员
        assertEq(bigBank.getAdmin(), newAdmin);
    }
    
    // 测试非管理员不能转移权限
    function testOnlyOwnerCanTransferAdmin() public {
        vm.startPrank(user1);
        
        vm.expectRevert("You are not the owner");
        bigBank.transferAdmin(user2);
        
        vm.stopPrank();
    }
    
    // 测试不能转移给零地址
    function testCannotTransferToZeroAddress() public {
        vm.expectRevert("New admin cannot be zero address");
        bigBank.transferAdmin(address(0));
    }
    
    // 测试不能转移给当前管理员
    function testCannotTransferToCurrentAdmin() public {
        vm.expectRevert("New admin cannot be current admin");
        bigBank.transferAdmin(address(this));
    }
    
    // 测试存款事件
    function testDepositEvent() public {
        vm.startPrank(user1);
        
        vm.expectEmit(true, false, false, true);
        emit IBank.Deposit(user1, 0.002 ether);
        bigBank.deposit{value: 0.002 ether}();
        
        vm.stopPrank();
    }
}