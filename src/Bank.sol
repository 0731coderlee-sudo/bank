// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IBank.sol";

contract Bank is IBank {

    mapping(address => uint256)  public depositors;
    address internal owner; // 合约所有者地址
    address[3] public top3Depositors;
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }         
    constructor() payable {
        owner = msg.sender; 
    }

    function _deposit() internal {
        require(msg.value > 0, "Deposit amount must greater than 0");
        // 将发送者地址和金额存入mapping
        depositors[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function deposit() public payable virtual {
        _deposit();
    }

    receive() external payable virtual {
        _deposit(); 
    }

    function withdraw() public onlyOwner{
        uint256 amount = address(this).balance;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdraw failed");
        emit Withdrawal(msg.sender, amount);
    }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}