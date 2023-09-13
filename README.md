# NFTContract_HolderDistribution_NFTStaking

<i>
SAMPLE <br>
Lang: Solidity
Bch: Polygon<p>
</i>

<b>Basic NFT Contract ERC721A:</b>
- Change metadata URL function
- SetFounder function
  <p>
<b>Distribution Contract - distribute ERC20 token for all NFT Holders:</b>
- <i>Distribute from contract balance</i>
- distributeMatic () - distribute native token
- distributeCustomTKN () - distribute custom token
- changeToken (address) - change distributed token address
- changeHoldersCount (uint256) - change holders/parts amount
- emergency () - withdrawal funds on contraccct balance
- getHolders () - view the array of holders addresses
- getValueCustomTKN() - view distributed token balance
<p>
  
 <b> NFTStaking Contract - stake NFT for reward ERC20 token:</b>
- <i>Pay rewards from contract balance</i>
- <i>Initialization NFT Contract & Reward token contract on deploy </i>
- Staking (uint256, uint256) - staking with check if one in progress. Only one active Staking per account possible
- Unstake() - manual claiming after expiring the time: send back NFT + rewards
- ChangeToken(address) - change Reward token address
- emergency() - withdrawal funds on contraccct balance
- SetStakeTime(uint256) - set time of stakiing in seconds
- RewardBalance() - view current balance of reward token
- StakeTimer() - view staking period time
- TimeLeft() - view time left for senders staking


 
