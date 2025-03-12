// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "./interfaces/IERC20.sol";

contract ERC20 is IERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint256 public decimals = 12;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        mint(msg.sender, _totalSupply);
    }

    modifier hasTokens(address _account, uint256 _value) {
        require(balanceOf[_account] >= _value, "Not enough tokens");
        _;
    }

    modifier validAddress(address _to) {
        require(_to != address(0), "Not valid address");
        _;
    }

    modifier hasAllowance(
        address _owner,
        address _spender,
        uint256 _value
    ) {
        require(allowance[_owner][_spender] >= _value, "Not enough allowance");
        _;
    }

    function transfer(
        address _to,
        uint256 _value
    ) public hasTokens(msg.sender, _value) validAddress(_to) returns (bool) {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        hasAllowance(_from, msg.sender, _value)
        hasTokens(_from, _value)
        validAddress(_from)
        validAddress(_to)
        returns (bool)
    {
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public validAddress(_spender) returns (bool) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function mint(
        address _account,
        uint256 _value
    ) public validAddress(_account) {
        totalSupply += _value;
        balanceOf[_account] += _value;

        emit Transfer(address(0), _account, _value);
    }

    function burn(
        address _account,
        uint256 _value
    ) public validAddress(_account) hasTokens(_account, _value) {
        balanceOf[_account] -= _value;
        totalSupply -= _value;

        emit Transfer(_account, address(0), _value);
    }
}
