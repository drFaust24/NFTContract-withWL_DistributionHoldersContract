// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./NFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DistributionContract is Ownable {

    address NFTAddress;
    address CustomTKN;
    uint256 holdersCount = 50;
    NFT NFTWrapped;

    event SendReward(uint);
    event Received(address, uint);
    
    constructor (address _NFT, address importToken) {
        NFTAddress = _NFT;
        NFTrapped = NFT(NFTAddress);
        CustomTKN = importToken;
    }
    
    function distributeMatic() external onlyOwner {
        uint256 value = address(this).balance/holdersCount;
        for (uint i=0; i<holdersCount; i++) {
            payable(NFTWrapped.ownerOf(i)).transfer(value);
        }
        emit SendReward(value);
    }

    function distributeCustomTKN() external onlyOwner {
        IERC20 _CustomTKN = IERC20(CustomTKN);
        uint256 value = _CustomTKN.balanceOf(address(this))/holdersCount;
        for (uint i=0; i<holdersCount; i++) {
            address account = payable(NFTWrapped.ownerOf(i));
            _CustomTKN.transfer(account, value);
        }
        emit SendReward(value);
    }

    function changeToken(address _new) external onlyOwner {
        CustomTKN = _new;
    }

    function changeHoldersCount(uint256 _new) external onlyOwner {
        holdersCount = _new;
    }

    function emergency() external onlyOwner {
        IERC20 _CustomTKN = IERC20(CustomTKN);
        _CustomTKN.transfer(owner(), _CustomTKN.balanceOf(address(this)));
        payable(owner()).transfer(address(this).balance);
    }

    function getHolders() external view returns(address[] memory) {
        address[] memory holders = new address[](holdersCount);
        for (uint i=0; i<holdersCount; i++) {
            holders[i] = NFTWrapped.ownerOf(i);
        }
        return holders;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getValueMatic() external view returns (uint256) {
        return address(this).balance/holdersCount;
    }

    function getValueCustomTKN() external view returns (uint256) {
        IERC20 _CustomTKN = IERC20(CustomTKN);
        return _CustomTKN.balanceOf(address(this));
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

}