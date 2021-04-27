    // SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
    pragma experimental ABIEncoderV2;
    contract Wallet {
        address[] public owners;
        uint limit;
        event CreateTransferRequest(uint amount, address from, address to);
        event ApprovalRecevied(uint id, bool);

        event TransferApproved(address _from, uint limit);
        struct Transfer{
        uint amount;
        address payable sender;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }

        Transfer[] transferRequests;
        mapping(address => mapping(uint => bool)) approvals;
    
        modifier onlyOwners(){
        bool owner=false;
        for(uint i=0; i<owners.length; i++){

        if(owners[i]==msg.sender){
        owner=true;
        }
    }
        require(owner==true);
        _;
    }

        constructor(address[] memory _owners, uint _limit) {

    }


        function deposit() public payable {}
    

        function supplyChainTransferRequests(uint _amount, address payable _sender, address payable _receiver) public onlyOwners {
        require(msg.sender != _receiver);

        transferRequests.push(
        Transfer(_amount, _sender, _receiver, 0, false, transferRequests.length));
        emit CreateTransferRequest(_amount, msg.sender, _receiver);
    }
    
        function approve(uint _id) public onlyOwners{
        require (approvals[msg.sender][_id]==false);
        require(transferRequests[_id].hasBeenSent == false);
        approvals[msg.sender][_id]=true;
        transferRequests[_id].approvals;
    if(transferRequests[_id].approvals>=limit){
        transferRequests[_id].hasBeenSent=true;
        transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
    emit ApprovalRecevied(_id, true);
    emit TransferApproved(msg.sender, limit);
        }
    }
    //Should return all transfer requests
        function SupplytransferRequests() public view returns (Transfer[] memory){
        return transferRequests;
    }

        function getBalance(uint amount) public view returns (uint) {
        return owners[amount].balance;
        }
}
