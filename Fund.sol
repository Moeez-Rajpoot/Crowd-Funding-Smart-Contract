// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract CrowdFund {

    address public Manager;
    uint public Campaignno =0;
    uint[] public CompletedCampaignID;
    mapping(uint=>Campaign) public CampaignLocation;

    constructor() {
        Manager=msg.sender;
    }

    struct Campaign{

        string CampaignName;
        string Description;
        uint CampaignId;
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

    function CreateCampaign(string memory _name , string memory _description ,uint _requiredamount, uint _deadline , uint _miniamount , address payable  _receipt ) public OnlyManager {

        Campaign storage newCampaign =  CampaignLocation[Campaignno];
        newCampaign.CampaignName = _name;
        newCampaign.Description = _description;
        newCampaign.CampaignId = Campaignno;
        newCampaign.RequiredAmount = _requiredamount;
        newCampaign.Deadline =  block.timestamp + _deadline;
        newCampaign.MinimumContribution = _miniamount;
        newCampaign.recipient = _receipt;
        Campaignno++;
    }

    function SendFund(uint _CampaignID) payable public  {
      Campaign storage OldCampaign =  CampaignLocation[_CampaignID];
      require(OldCampaign.MinimumContribution <= msg.value , "Minimum Contribution Requirement No met ");
      require(OldCampaign.Deadline > block.timestamp , "Opss The Time is Over For Contribution");
      require(OldCampaign.AmountCollected < OldCampaign.RequiredAmount ,"Requirement is Fullfiled For This Campaign" );
      require(OldCampaign.Completed == false , "Campaign is Completed");

      if(OldCampaign.Contributors[msg.sender]==0)
      {
          OldCampaign.NoofContributors++;
      }
      OldCampaign.Contributors[msg.sender]+= msg.value;
      OldCampaign.AmountCollected+=msg.value;

    }

    function Refund(uint _CampaignID) public  {
        Campaign storage OldCampaign =  CampaignLocation[_CampaignID];
        require(Campaignno > 0 ,"There is No Campaign In Process Yet");
        require(OldCampaign.Deadline < block.timestamp,"Campaign is Still in Process You Cant Refund Yet");
        require(OldCampaign.Contributors[msg.sender]>0,"You are not a Contributor");
        require(OldCampaign.AmountCollected < OldCampaign.RequiredAmount,"Required Campaign Amount has been Fulfilled Can't Refund Now");
        require(OldCampaign.Completed == false , "The Campaign has been Completed You Cant Refund Now");

        uint RefundAmount = OldCampaign.Contributors[msg.sender];
        OldCampaign.Contributors[msg.sender]=0;
        OldCampaign.NoofContributors--;
        OldCampaign.AmountCollected -= RefundAmount; 
        address payable Refunder = payable(msg.sender);
        Refunder.transfer(RefundAmount);

    }

    function checkbalance() public view returns (uint){

        return address(this).balance;
    }

    



    
}