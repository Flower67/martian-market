pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './MartianAuction.sol';

contract MartianMarket is ERC721, Ownable {
    constructor() ERC721("MartianMarket", "MARS") public {}

       // cast a payable address for the Martian Development Foundation to be the beneficiary in the auction
    // this contract is designed to have the owner of this contract (foundation) to pay for most of the function calls
    // (all but bid and withdraw)
    address payable foundationAddress = address(uint160(owner()));

    mapping(uint => MartianAuction) public auctions;

    function registerLand(string memory tokenURI) public payable onlyOwner {
        uint _id = totalSupply();
        _mint(msg.sender, _id);
        _setTokenURI(_id, tokenURI);
        createAuction(_id);
    }

    function createAuction(uint tokenId) public onlyOwner {
       auctions[tokenId] = new MartianAuction(foundationAddress);
    }

    function endAuction(uint tokenId) public onlyOwner {
        require(_exists(tokenId), "Land not registered!");
        MartianAuction auction = auctions[token_id];
        auction.auctionEnd();
        safeTransferFrom(owner(), auction.highestBidder(), tokenId);
    }

    function getAuction(uint tokenId) public view returns(MartianAuction auction) {
        return auction[tokenId];
    }

    function auctionEnded(uint tokenId) public view returns(bool) {
        require(_exists(tokenId), "Incorrect Token ID, please try again.");
        MartianAuction auction = auctions[token_id];
        return auction.ended();
    }

    function highestBid(uint tokenId) public view returns(uint) {
        require(_exists(tokenId), "Incorrect Token ID, please try again.");
        MartianAuction auction = auctions[token_id];
        return auction.highestBid();
    }

    function pendingReturn(uint tokenId, address sender) public view returns(uint) {
        require(_exists(tokenId), "Incorrect Token ID, please try again.");
        MartianAuction auction = auctions[token_id];
        return auction.pendingReturn(sender);
    }

    function bid(uint tokenId) public payable {
        require(_exists(tokenId), "Incorrect Token ID, please try again.");
        MartianAuction auction = auctions[token_id];
        auction.bid.value(msg.value)(msg.sender);
    }

}
