// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IBank {
    // 存款事件
    event Deposit(address indexed user, uint256 amount);
    
    // 提取事件
    event Withdrawal(address indexed user, uint256 amount);
    
    // 存款函数
    function deposit() external payable;
    
    // 提取函数
    function withdraw() external;
    
    // 获取合约余额
    function getBalance() external view returns(uint256);
    
    // 获取用户存款余额
    function depositors(address user) external view returns(uint256);
}