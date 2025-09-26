// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/Bank.sol";
import "../src/BigBank.sol";

contract DeployScript is Script {
    
    function run() external {
        // 开始广播交易
        vm.startBroadcast();
        
        console.log("Starting contract deployment...");
        console.log("Deployer address:", msg.sender);
        
        // Deploy Bank contract
        Bank bank = new Bank();
        console.log("Bank contract deployed at:", address(bank));
        
        // Deploy BigBank contract
        BigBank bigBank = new BigBank();
        console.log("BigBank contract deployed at:", address(bigBank));
        
        // Stop broadcasting
        vm.stopBroadcast();
        
        // Output deployment info
        console.log("================================");
        console.log("Deployment Summary:");
        console.log("================================");
        console.log("Bank Contract Address:", address(bank));
        console.log("BigBank Contract Address:", address(bigBank));
        console.log("Deployer Address:", msg.sender);
        console.log("================================");
    }
}