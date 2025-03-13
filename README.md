📌 How the contract works:
1.Deploy the contract by specifying the unlock time (in Unix timestamp format).

2.Lock funds by sending ETH during deployment or using the deposit() function.

3.Withdraw funds after the unlock time using the withdraw() function.


// Deploy the wallet with a 1-week lock period
TimeLockedWallet wallet = new TimeLockedWallet(block.timestamp + 7 days);

🛡️ Use case:

Securely lock funds until a specific future date (e.g., employee vesting, inheritance, or delayed payments).
