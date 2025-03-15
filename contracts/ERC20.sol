// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract ERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;
    uint256 public price;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint8 _decimals,
        uint256 _price
    ) {
        name = _name;
        symbol = _symbol;
        mint(msg.sender, _totalSupply);
        decimals = _decimals;
        price = _price;
    }

    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }

    modifier enoughTokens(address _account, uint256 _amount) {
        require(balanceOf[_account] >= _amount, "Not enough tokens");
        _;
    }

    modifier hasAllowance(address _from, uint256 _amount) {
        require(
            allowance[_from][msg.sender] >= _amount,
            "Not enough allowance"
        );
        _;
    }

    function transfer(address _to, uint256 _amount)
        external
        enoughTokens(msg.sender, _amount)
        validAddress(_to)
        returns (bool)
    {
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    )
        external
        validAddress(_from)
        validAddress(_to)
        // hasAllowance(_from, _amount)
        enoughTokens(_from, _amount)
        returns (bool)
    {
        // allowance[_from][msg.sender] -= _amount;
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount)
        external
        validAddress(_spender)
        returns (bool)
    {
        allowance[msg.sender][_spender] = _amount;

        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function mint(address _to, uint256 _amount) public validAddress(_to) {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    }

    function buy() external payable returns (uint256) {
        mint(msg.sender, msg.value / price);
        return msg.value / price;
    }
}
