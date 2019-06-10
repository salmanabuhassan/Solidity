pragma solidity ^0.4.21;


contract Bank{
    event warning(string);
    event Account(address);
    event  Time(uint);
    event TxVal(uint);
    event dep(address);
    event wit(address);

    
    // solidity "private" is actually public
    uint  private acc =0;
    uint  private acc1=0;
    bool dup;
    mapping (uint => address) public Acc;//depositer account
    mapping (uint => address) public Acc1;//withdrawer account
    
    //adding withdrawer
    function  AddAcc1(address id) private {
    dup =false;
        for(uint i =0;i < acc1; ++i){
    if(id==Acc1[i])
    dup = true;
    }
    if(dup==false){
    Acc1[acc1] = msg.sender;
    acc1 = acc1 + 1; 
    }
    }
    //adding depositer
    function  AddAcc(address id) private {
    dup =false;
        for(uint i =0;i < acc; ++i){
    if(id==Acc[i])
    dup = true;
    }
    if(dup==false){
    Acc[acc] = msg.sender;
    acc = acc + 1; 
    }
    }
    //output depositer account
    function getAcc()  private {
    for(uint i =0;i <= acc-1; ++i){
        emit dep(Acc[i]);
    }
    }
    //output withdrawer account
    function getAcc1()  private {
    for(uint i =0;i <= acc1-1; ++i){
        emit wit(Acc1[i]);
    }
    }    
    modifier Threshold(){
    if(msg.value>=15000000000000000000)
    _;
    }
    modifier BalanceExceed{
    if(address(this).balance>=50000000000000000000)  
    _;    
    }
    function Alert1() private BalanceExceed(){
        emit warning("This contract balance exceed the limit");
        getAcc();
        getAcc1();
    }
    
    function Alert() private Threshold(){
    //Searching the account address on etherscan will yield better visibility especially
    //the time of transaction
    //this alert will be visible in the event tab
    emit warning("Warning,this account transact is above the limit");
    emit Account(msg.sender);
    emit TxVal(msg.value);// in wei
    emit Time(now);// in unix timestamp
    }
    
    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public {
        AddAcc1(msg.sender);
        
        // Limit withdrawal amount
        require(withdraw_amount <= 1000000000000000000);

        // Send the amount to the address that requested it
        msg.sender.transfer(withdraw_amount);
    }
    
    // Accept any incoming amount
    function () public payable {
    AddAcc(msg.sender);
    Alert();
    Alert1();

    }

}
