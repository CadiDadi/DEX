pragma solidity ^0.4.21;

contract ERC20Interface {

    // Returns total token supply
    function totalSupply() view public returns (uint256);

    // Get other account balances with: address _owner
    function balanceOf(address _owner) view public returns (uint256);

    // Send: _value to address: _to
    function transfer(address _to, uint256 _value) public returns (bool success);
    
    // Send: _value from: _from to: _to
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function required for some DEX functionality
    function approve(address _spender, uint256 _value) public returns (bool success);

    // Returns amount: _spender can withdraw from: _owner
    function allowance(address _owner, address _spender) view public returns (uint256 remaining);

    // Token transfer
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Calls: approve(address _spender, uint256 _value)
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract FixedSupplyToken is ERC20Interface {
    string public constant symbol = "FIXED";
    string public constant name = "Example Fixed Supply Token";
    uint8 public constant decimals = 0;
    uint256 _totalSupply = 1000000;

    // Contract owner
    address public owner;

    // Account balances
    mapping (address => uint256) balances;

    // Transfers allowed
    mapping (address => mapping (address => uint256)) allowed;

    // Owner modifier
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Constructor
    constructor() public {
        owner = msg.sender;
        balances[owner] = _totalSupply;
    }

    function totalSupply() view public returns (uint256) {
        return _totalSupply;
    }

    // Account balance
    function balanceOf(address _owner) view public returns (uint256) {
        return balances[_owner];
    }

    // Transfer balance
    function transfer(address _to, uint256 _amount) public returns (bool success) {
        if (balances[msg.sender] >= _amount
        && _amount > 0
        && balances[_to] + _amount > balances[_to]) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        }
        else {
            return false;
        }
    }

    // Send _value amount of tokens from address _from to address _to
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
    // fees in sub-currencies; the command should fail unless the _from account has
    // deliberately authorized the sender of the message via some mechanism; we propose
    // these standardized APIs for approval:
    function transferFrom(
    address _from,
    address _to,
    uint256 _amount
    ) public returns (bool) {
        if (balances[_from] >= _amount
        && allowed[_from][msg.sender] >= _amount
        && _amount > 0
        && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            emit Transfer(_from, _to, _amount);
            return true;
        }
        else {
            return false;
        }
    }

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}
