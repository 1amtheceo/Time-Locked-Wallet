// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockedWallet {
    address public owner; // Wallet owner
    uint256 public unlockTime; // Time when funds can be withdrawn

    event Deposited(address indexed sender, uint256 amount); // Emitted when funds are deposited
    event Withdrawn(address indexed receiver, uint256 amount); // Emitted when funds are withdrawn

    // Constructor: Sets the wallet owner and unlock time
    constructor(uint256 _unlockTime) payable {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        owner = msg.sender; // Set the owner to the deployer
        unlockTime = _unlockTime; // Set the unlock time
    }

    // Function to deposit additional funds into the wallet
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        emit Deposited(msg.sender, msg.value); // Emit deposit event
    }

    // Function to withdraw funds after the unlock time
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= unlockTime, "Funds are still locked");

        uint256 balance = address(this).balance; // Get the contract balance
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}(""); // Transfer funds
        require(success, "Withdrawal failed");

        emit Withdrawn(owner, balance); // Emit withdrawal event
    }

    // View function to check the contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // View function to check the time left until unlock
    function timeLeft() external view returns (uint256) {
        if (block.timestamp >= unlockTime) {
            return 0; // Unlock time has passed
        }
        return unlockTime - block.timestamp; // Time remaining until unlock
    }
}
