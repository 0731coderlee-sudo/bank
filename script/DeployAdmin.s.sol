// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/Admin.sol";
import "../src/Bank.sol";
import "../src/BigBank.sol";

contract DeployAdminScript is Script {
    
    function run() external {
        // 开始广播交易
        vm.startBroadcast();
        
        console.log("Starting Admin contract deployment...");
        console.log("Deployer address:", msg.sender);
        
        // 部署 Admin 合约
        Admin admin = new Admin();
        console.log("Admin contract deployed at:", address(admin));
        
        // 停止广播
        vm.stopBroadcast();
        
        // 输出部署信息
        console.log("================================");
        console.log("Admin Deployment Summary:");
        console.log("================================");
        console.log("Admin Contract Address:", address(admin));
        console.log("Deployer Address:", msg.sender);
        console.log("================================");
        
        // 如果需要，也可以重新部署所有合约
        console.log("\nNote: If you want to deploy all contracts together, use the full deployment script.");
    }
}