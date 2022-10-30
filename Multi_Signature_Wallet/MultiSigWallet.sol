pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

contract MultiSigWallet {
    uint minApprovers;

    address beneficiary;
    address owner;

    mapping (address => bool) approvedBy;
    mapping (address => bool) isApprover;
    uint approvalNum;

    constructor(
        address[] _approvers,
        uint _minApprovers,
        address _beneficiary
    ) public payable {
        require(_minApprovers <= _approvers.length, "Required Number maxed out at no of approvers");

        minApprovers = _minApprovers;
        beneficiary = _beneficiary;
        owner = msg.sender;

        for(uint i = 0; i < _approvers.length; i++){
            address approver = _approvers[i];
            isApprover[approver] = true;
        }
    }

    function approve() public {
        require(isApprover[msg.sender], "Not an approver");
        if (!approvedBy[msg.sender]){
            approvalNum++;
            approvedBy[msg.sender] = true;
        }

        if (approvalNum == minApprovers) {
            beneficiary.send(address(this).balance);
            selfdestruct(owner);
        }
    }

    function reject() public {
        require(isApprover[msg.sender], "Not an approver");
        selfdestruct(owner); //return gas to contract creator
    }
    

}