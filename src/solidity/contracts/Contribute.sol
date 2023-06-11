// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Crowdfunding.sol"; // The Crowdfunding contract is imported

contract Contribute {
    Crowdfunding public crowdfundingContract;
    mapping(address => uint256) public contributions;
    bool public closed;
    uint256 public totalRaised; // Variable to store the total amount collected
    address payable public entrepreneur;

    constructor(address _crowdfundingContract) {
        crowdfundingContract = Crowdfunding(_crowdfundingContract);
        require(
            msg.sender == crowdfundingContract.owner(),
            "Only the contract owner can set the crowdfunding contract address"
        );

        entrepreneur = crowdfundingContract.getEntrepreneur();
    }

    modifier onlyCrowdfundingContract() {
        require(
            msg.sender == address(crowdfundingContract),
            "Only the crowdfunding contract can call this function"
        );
        _;
    }

    function contribute(uint256 amount) public payable {
        require(!closed, "Contribute is closed");
        require(amount > 0, "Contribute amount must be greater than zero");
        require(msg.sender != entrepreneur, "Entrepreneur cannot contribute");
        require(
            msg.sender != crowdfundingContract.owner(),
            "Owner cannot contribute"
        );

        contributions[msg.sender] += amount;
        totalRaised += amount; // Increase the total amount collected

        if (totalRaised >= crowdfundingContract.goal()) {
            closed = true;
            crowdfundingContract.closeCampaign(); // Closing the campaign in the Crowdfunding contract
        }
    }

    function withdrawFunds() public {
        require(
            closed && (msg.sender == entrepreneur || msg.sender == crowdfundingContract.owner()),
            "Withdrawal is not available"
        );

        uint256 amount = totalRaised;
        require(amount > 0, "Insufficient funds for withdrawal");

        totalRaised = 0;

        if (msg.sender == entrepreneur) {
            // Withdrawal to the entrepreneur
            require(payable(entrepreneur).send(amount), "Withdrawal failed");
        } else {
            // Allowing the owner to add funds to the withdraw wallet
            // No transfer is made in this case
        }
    }

    function getTotalRaised() public view returns (uint256) {
        return totalRaised;
    }
}
