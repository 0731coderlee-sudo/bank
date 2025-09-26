// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./IBank.sol";

contract Admin {
    address internal owner; 
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Admin: You are not the owner");
        _;
    }

    function adminWithdraw(IBank bank) public onlyOwner {
        bank.withdraw();
    }
    
    function getOwner() public view returns(address) {
        return owner;
    }

    receive() external payable {
        // 接收ETH
    }
}