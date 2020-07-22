# Payroll_Payment
Using stable coins to collect funds and make payments to collaborators or employees.

This contract only allows a unique address to fund. This mechanics is conceived in order to avoid the business receiving payments "out of the radar" that let the boss to fool the employees (or the shareholders in a future deployment).

This address is supposed to be the designated address of the wallet for the circle-business-account.

In this simple implementation, the payments are weekly. 

The Boss takes the 40% of the available total amount of funds, if he makes the payment on time.

If he fails, any employee can trigger the payment, for a plus in her/his payment of 2%, and a penlaty to the boss of 5%.

The contract allows to hire and fire people. And allows the boss ordering payments to suppliers.

Old Testnet Deployment:

https://ropsten.etherscan.io/address/0xe6395d0fb745d89cd7d4e5975e357df5445f26d1#code