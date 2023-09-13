// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//////-----------------------------------------------------------------------------//////
/// Before staking NFT must be approved to StakeContract address in their NFTContract ///
//////-----------------------------------------------------------------------------//////

contract NFTStake is Ownable {

    uint256 staketime = 0;     // Staking [NFT blocking] time by default
    uint256 rewardValue = 10;  // Staking Reward amount by default
    
    address NFTAddress;
    address RToken;  
    IERC721A StakeNFT;

    struct Stake {
        uint256 tokenId;
        uint256 amount;
        uint256 timestamp;
    }

    mapping (address => Stake) public Stakers;

    event NFTStaked(address owner, uint256 tokenId, uint256 amount);
    event NFTUnstaked(address owner, uint256 tokenId, uint256 amount, uint256 RewardValue);
    event Received(address, uint256);

    // Init addresses on deploy
    constructor (address StakeNFT_Adr, address RewardToken_Adr) {
        NFTAddress = StakeNFT_Adr; // NFT contract address [can't be changed later]
        StakeNFT = IERC721A (NFTAddress);
        RToken = RewardToken_Adr;  // Reward token address [may be changed later in settings]
    }
    
    // Staking with check if one in progress. Only one active Staking per account possible
    function Staking(uint256 _tokenId, uint256 _amount) external {
        require(Stakers[msg.sender].timestamp == 0, "You already have stake!");
        uint256 timerStart = block.timestamp + staketime;
        Stakers[msg.sender] = Stake(_tokenId, _amount, timerStart);
        StakeNFT.transferFrom(msg.sender, address(this), _tokenId);
        
        emit NFTStaked(msg.sender, _tokenId, _amount);
    }

    // Rewards are paying from this contract balance
    function Unstake() external {
        uint256 currentTime = block.timestamp;
        require(Stakers[msg.sender].timestamp <= currentTime, "Not Unstake, Its too early");
        StakeNFT.transferFrom(address(this), msg.sender, Stakers[msg.sender].tokenId);
        IERC20 _RToken = IERC20(RToken);
        _RToken.transfer(msg.sender, rewardValue);
        
        emit NFTUnstaked(msg.sender, Stakers[msg.sender].tokenId, Stakers[msg.sender].amount, rewardValue);
        delete Stakers[msg.sender];
    }

  
// ----- Settings -----

    // Change reward token address
    function ChangeToken(address _new) external onlyOwner {
        RToken = _new;
    }

    // Set stake time in seconds
    function SetStakeTime(uint256 _time) external onlyOwner {
        staketime = _time;
    }

    // Emergency funds withdrawal 
    function emergency() external onlyOwner {
        IERC20 _RToken = IERC20(RToken);
        _RToken.transfer(owner(), _RToken.balanceOf(address(this)));
        payable(owner()).transfer(address(this).balance);
    }

// ----- View -----

    function RewardTokenData() external view returns (address) {
        return RToken;
    }

    function StakeTimer() external view returns(uint256) {
        return staketime; 
    }
    
    // View sum of total reward tokens on this contract balance
    function RewardBalance() external view returns (uint256) {
        IERC20 _RToken = IERC20(RToken);
        return _RToken.balanceOf(address(this));
    }

    // View time left of sender staking
    function TimeLeft() external view returns(uint256){
        uint256 currentTime = block.timestamp;
        uint256 leftTime = Stakers[msg.sender].timestamp - currentTime;
        return leftTime;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

}