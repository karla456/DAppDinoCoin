pragma solidity ^0.5.0;

contract pointscall{
    uint256 private amount = 0;
    uint256 private rewardPoints = 0;
    uint256 private totalRewardPoints = 0;
    uint256 private exchangedRewardPoints = 0;

    function setAmount(uint256 totalAmount) public{
        amount = totalAmount;
    }

    function setRewardPoints(uint256 points) public{
        rewardPoints = points;
    }

    function setTotalRewardPoints(uint256 points) public{
        totalRewardPoints = points;
    }

    function setExchangeRewardPoints(uint256 points) public{
        exchangedRewardPoints = points;
    }

    function getAmount() public view returns (uint256){
        return amount;
    }

    function getRewardPoints() public view returns (uint256){
        return rewardPoints;
    }

    function getTotalRewardPoints() public view returns (uint256){
        return totalRewardPoints;
    }

    function getExchangeRewardPoints() public view returns (uint256){
        return exchangedRewardPoints;
    }
}
// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
//
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// ----------------------------------------------------------------------------
// Safe Math Library
// ----------------------------------------------------------------------------
contract SafeMath {
    
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}


contract MyFirstToken is ERC20Interface, SafeMath, pointscall{
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it

    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor() public {
        name = "MyFirstToken";
        symbol = "DinoCoin";
        decimals = 0;
        _totalSupply = 10000000;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function sendPoints(address toAddress,uint256 amount, uint256 points, uint256 totalPoints) public returns (bool success){
        setAmount(amount);
        setRewardPoints(points);
        setTotalRewardPoints(safeAdd(totalPoints, points));
        transfer(toAddress, points);
        return true;
    }

    function exchangePoints(address toAddress, uint256 points, uint256 totalPoints) public returns (bool success){
        setTotalRewardPoints(safeSub(totalPoints, points));
        setExchangeRewardPoints(points);
        transfer(toAddress, points);
        return true;
    }
}