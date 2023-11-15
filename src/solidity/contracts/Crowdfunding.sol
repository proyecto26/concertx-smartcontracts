// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Crowdfunding {
    address public owner; // owner of the contract
    uint256 public minimumContribution; // minimum contribution required for contributor to do crowdfunding.
    uint256 public deadline; // final time to do crowdfunding.
    uint256 public target; // target set for crowdfunding
    uint256 public raisedAmount; // keep track of the total raised amount.
    uint256 public totalContributors; // total contributors who have contributed to crowdfunding.
    uint256 public numRequests;

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        bool completed;
        uint256 noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public allRequests;
    mapping(address => uint256) public contributors; // key value pair of contributors address and fund they have contributed.

    constructor(uint256 _target, uint256 _deadline) {
        owner = msg.sender;
        deadline = block.timestamp + _deadline;
        target = _target;
        minimumContribution = 10;
    }

    // all modifiers starts here --------------------------------------------------
    /**
     * @dev modifier to check if the caller is the owner of the crowdfunding contract.
     * @notice the function using this modifier will only proceed if the caller is the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access this function.");
        _;
    }

    /**
     * @dev modifier to check if the crowdfunding deadline has passed.
     * @notice the function using this modifier will only proceed if the current block timestamp is less than the crowdfunding deadline.
     */
    modifier isDeadlinePassed() {
        require(
            block.timestamp < deadline,
            "Crowdfunding deadline has passed. Please try again later."
        );
        _;
    }
    /**
     * @dev modifier to check if the caller is a contributor.
     * @notice the function using this modifier will only proceed if the caller has contributed to the crowdfunding.
     */
    modifier isContributor() {
        require(
            contributors[msg.sender] > 0,
            "Sorry, you are not a contributor. Try to contribute to crowdfunding then try again. Thanks."
        );
        _;
    }

    // all modifiers ends here --------------------------------------------------

    /**
     * @notice gets the current balance of the contract.
     * @return the current contract balance in ethers.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice contribute to the crowdfunding.
     * @param amount The amount in ethers being contributed.
     * @dev requires the amount to be greater than or equal to the minimum required to contribute.
     * @dev requires that the amount does not equal zero.
     * @dev if the contributor is new, the contributor counter is incremented.
     */
    function contribute(uint256 amount) public payable isDeadlinePassed {
        require(amount > 0, "Amount must be greater than 0.");
        require(
            amount >= minimumContribution,
            "Minimum 10 is required to contribute."
        );

        if (contributors[msg.sender] == 0) {
            totalContributors++;
        }

        contributors[msg.sender] += amount;
        raisedAmount += amount;
    }

    // TODO: the contract needs to be modified to handle refund functionality.
    /**
     * @dev refund the money if the target is not fulfilled and the deadline has passed.
     * @notice contributors can request a refund if the crowdfunding target is not met and the deadline has passed.
     * @dev only contributors who have made a contribution are eligible for a refund.
     * @dev the refund will be processed to the contributor's address.
     */
    function refund() public isDeadlinePassed isContributor {
        require(raisedAmount < target, "You are not eligible for a refund");
        require(contributors[msg.sender] > 0);

        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
    }

    // TODO: this function is a work in progress and will be expanded to include additional functionality.
    /**
     * @dev create a funding request to use the raised amount for a specific purpose.
     * @param _description a brief description of the funding request.
     * @param _recipient the address of the recipient who will receive the funds for the specified purpose.
     * @param _value the amount of funds requested for the specific purpose.
     * @notice only the owner of the contract can create funding requests.
     * @dev each funding request has a unique identifier and is initially marked as incomplete.
     * @dev the request needs to be voted on by contributors before it can be completed and funds are released.
     */
    function createRequest(
        string memory _description,
        address payable _recipient,
        uint256 _value
    ) public onlyOwner {
        Request storage newRequest = allRequests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    // TODO: this function is a work in progress and will be expanded to include additional functionality.
    /**
     * @dev allow contributors to vote on a funding request.
     * @param _requestNo the unique identifier of the funding request to vote on.
     * @notice only contributors are eligible to vote, and each contributor can vote only once on a specific request.
     * @dev voting on a request increases the number of voters and marks the contributor as having voted on the specific request.
     */
    function voteRequest(uint256 _requestNo) public isContributor {
        Request storage currentRequest = allRequests[_requestNo];
        require(
            currentRequest.voters[msg.sender] == false,
            "you have already voted"
        );
        currentRequest.voters[msg.sender] = true;
        currentRequest.noOfVoters++;
    }

    // TODO: this function is a work in progress and will be expanded to include additional functionality.
    /**
     * @dev execute a payment to the recipient of a funding request if certain conditions are met.
     * @param _requestNo the unique identifier of the funding request for which to make a payment.
     * @notice only the owner can execute a payment.
     * @dev the payment is made if the total raised amount is equal to or greater than the target, the request has not been completed,
     * and the number of voters supporting the request is greater than half of the total contributors.
     */
    function makePayment(uint _requestNo) public onlyOwner {
        require(raisedAmount >= target);
        Request storage currentRequest = allRequests[_requestNo];
        require(
            currentRequest.completed == false,
            "This request has already completed"
        );
        require(
            currentRequest.noOfVoters > totalContributors / 2,
            "Contributor does not support. Votes are low."
        );
        currentRequest.recipient.transfer(currentRequest.value);
    }
}
