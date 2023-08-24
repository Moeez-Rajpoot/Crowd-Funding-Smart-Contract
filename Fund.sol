// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract CrowdFund {

    address public Manager;
    uint public Projectno =0;
    uint[] public CompletedProjectID;
    mapping(uint=>Project) public ProjectLocation;

    constructor() {
        Manager=msg.sender;
    }

    struct Project{

        string ProjectName;
        string Description;
        uint ProjectId;
        uint AmountCollected;
        uint RequiredAmount;
        uint Deadline;
        uint MinimumContribution;
        uint NoofContributors;
        uint NoofVotes;
        address payable recipient;
        bool Completed;
        mapping(address=>bool) Vote;
        mapping(address=>uint) Contributors;
    }

        modifier OnlyManager() {
             require(msg.sender==Manager , "Only Manager is Allowed");
        _;
        }

    function CreateProject(string memory _name , string memory _description ,uint _requiredamount, uint _deadline , uint _miniamount , address payable  _receipt ) public OnlyManager {

        Project storage newProject =  ProjectLocation[Projectno];
        newProject.ProjectName = _name;
        newProject.Description = _description;
        newProject.ProjectId = Projectno;
        newProject.RequiredAmount = _requiredamount;
        newProject.Deadline =  block.timestamp + _deadline;
        newProject.MinimumContribution = _miniamount;
        newProject.recipient = _receipt;
        Projectno++;
    }

    function SendFund(uint _ProjectID) payable public  {
      Project storage OldProject =  ProjectLocation[_ProjectID];
      require(OldProject.MinimumContribution <= msg.value , "Minimum Contribution Requirement No met ");
      require(OldProject.Deadline > block.timestamp , "Opss The Time is Over For Contribution");
      require(OldProject.AmountCollected < OldProject.RequiredAmount ,"Requirement is Fullfiled For This Project" );
      require(OldProject.Completed == false , "Project is Completed");

      if(OldProject.Contributors[msg.sender]==0)
      {
          OldProject.NoofContributors++;
      }
      OldProject.Contributors[msg.sender]+= msg.value;
      OldProject.AmountCollected+=msg.value;

    }

    



    
}