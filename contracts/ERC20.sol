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

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    event Transfer(
        address indexed _sender,
        address indexed _receiver,
        uint256 amount
    );
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 amount
    );

    modifier hasTokens(address _spender, uint256 _amount) {
        require(balanceOf[_spender] >= _amount, "Not enough tokens");
        _;
    }

    modifier validAddress(address _receiver) {
        require(_receiver != address(0), "Not valid address");
        _;
    }

    modifier hasAllowance(
        address _owner,
        address _spender,
        uint256 _amount
    ) {
        require(allowance[_owner][_spender] >= _amount, "Not enough allowance");
        _;
    }

    function transfer(
        address _receiver,
        uint256 _amount
    )
        external
        override
        hasTokens(msg.sender, _amount)
        validAddress(_receiver)
        returns (bool)
    {
        balanceOf[msg.sender] -= _amount;
        balanceOf[_receiver] += _amount;

        emit Transfer(msg.sender, _receiver, _amount);
        return true;
    }

    function transferFrom(
        address _sender,
        address _receiver,
        uint256 _amount
    )
        external
        override
        hasAllowance(_sender, msg.sender, _amount)
        hasTokens(_sender, _amount)
        validAddress(_receiver)
        returns (bool)
    {
        allowance[_sender][msg.sender] -= _amount;
        balanceOf[_sender] -= _amount;
        balanceOf[_receiver] += _amount;

        emit Transfer(_sender, _receiver, _amount);
        return true;
    }

    function approve(
        address _spender,
        uint256 _amount
    ) external override validAddress(_spender) returns (bool) {
        allowance[msg.sender][_spender] = _amount;

        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
}
