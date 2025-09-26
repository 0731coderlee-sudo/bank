// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Bank.sol";

contract BigBank is Bank {
    
    // 管理员转移事件
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
    
    // 最小存款金额 0.001 ether
    uint256 public constant MIN_DEPOSIT = 0.001 ether;
    
    // 权限控制modifier：存款金额必须大于0.001 ether
    modifier minDepositRequired() {
        require(msg.value > MIN_DEPOSIT, "Deposit must be greater than 0.001 ether");
        _;
    }
    
    // 重写deposit函数，添加最小存款限制
    function deposit() public payable override minDepositRequired {
        _deposit();
    }
    
    // 重写receive函数，添加最小存款限制
    receive() external payable override {
        require(msg.value > MIN_DEPOSIT, "Deposit must be greater than 0.001 ether");
        _deposit();
    }
    
    // 转移管理员权限函数
    function transferAdmin(address newAdmin) public onlyOwner {
        require(newAdmin != address(0), "New admin cannot be zero address");
        require(newAdmin != owner, "New admin cannot be current admin");
        
        address previousAdmin = owner;
        owner = newAdmin;
        
        emit AdminTransferred(previousAdmin, newAdmin);
    }
    
    // 获取当前管理员地址
    function getAdmin() public view returns(address) {
        return owner;
    }
}