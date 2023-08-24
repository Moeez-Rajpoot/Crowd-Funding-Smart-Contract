// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract CrowdFund {

    address public Manager;
    mapping(address=>uint) public Contributors;

    constructor() {
        Manager=msg.sender;
    }

    struct Project{

        string ProjectName;
        string Description;
        uint RequiredAmount;
        uint Deadline;
        uint MinimumContribution;
        uint NoofContributors;
        address payable recipient;

    }


    
}