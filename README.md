# Merkle Distributor

The Merkle distributor, pioneered by Uniswap, is more useful when you have a predefined list of addresses that should receive the tokens.
In the ICO model, anybody can buy the tokens. In an Airdrop model only some addresses can receive the token. The question becomes, how do we make ensure that some specific people receive the tokens?
You can send it directly to all of them. This is expensive. You can store a mapping of all the allowed addresses within your contract.
This is expensive for the deployer. Or you can have a merkle root within your Merkle Distributor. This approach reduces your cost for deployment while allowing the user to withdraw their airdrop tokens.