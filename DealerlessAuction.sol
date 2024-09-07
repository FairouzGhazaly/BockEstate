// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract DealerlessAuction {

    address public deployer;
    address payable public beneficiary;
    address payable public highestBidder;

    uint public highestBid;
    
    mapping (address => uint) pendingReturns;
    bool public ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // Constructor to initialize deployer and beneficiary
    constructor(address payable _beneficiary)  {
        deployer = msg.sender;
        beneficiary = _beneficiary;
    }
    
    function bid() public payable {
        require(!ended, "auctionEnd has already been called.");
        require(msg.value > highestBid, "There already is a higher bid.");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = payable(msg.sender);
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Set to zero to prevent re-entrancy attacks
            pendingReturns[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                // Revert the change if send fails
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function pendingReturn(address sender) public view returns (uint) {
        return pendingReturns[sender];
    }
    
    function auctionEnd() public {
        require(!ended, "auctionEnd has already been called.");
        require(msg.sender == deployer, "You are not the auction deployer!");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }
}
