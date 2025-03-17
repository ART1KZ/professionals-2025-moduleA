// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "./ERC20.sol";

contract Pool {
    ERC20 firstToken;
    ERC20 secondToken;
    ERC20 lpToken;

    constructor(
        address _firstToken,
        address _secondToken,
        address _lpToken,
        uint256 _firstTokenETHInitAmount,
        uint256 _secondTokenETHInitAmount
    ) {
        firstToken = ERC20(_firstToken);
        secondToken = ERC20(_secondToken);
        lpToken = ERC20(_lpToken);
        firstToken.mint(address(this), _firstTokenETHInitAmount * 1 ether / firstToken.price());
        secondToken.mint(address(this), _secondTokenETHInitAmount * 1 ether / secondToken.price());
    }

    function addLiquidity(uint256 _firstTokenAmount, uint256 _secondTokenAmount)
        external
    {
        firstToken.transferFrom(msg.sender, address(this), _firstTokenAmount);
        secondToken.transferFrom(msg.sender, address(this), _secondTokenAmount);

        uint256 lpAmount = ((firstToken.price() * _firstTokenAmount) +
            (secondToken.price() * _secondTokenAmount)) / lpToken.price();
        lpToken.mint(msg.sender, lpAmount);
    }

    function swap(bool _isSwapFirstTokenToSecond, uint256 _amount)
        external
    {
        ERC20 tokenIn = _isSwapFirstTokenToSecond ? firstToken : secondToken;
        ERC20 tokenOut = _isSwapFirstTokenToSecond ? secondToken : firstToken;

        uint256 amountOut = (_amount * tokenOut.balanceOf(address(this))) / tokenIn.balanceOf(address(this));
        tokenIn.transferFrom(msg.sender, address(this), _amount);
        tokenOut.transferFrom(address(this), msg.sender, amountOut);
    }

    function getInfo()
        external
        view
        returns (
            address firstTokenAddress,
            string memory firstTokenSymbol,
            uint256 firstTokenWeiPrice,
            address secondTokenAddress,
            string memory secondTokenSymbol,
            uint256 secondTokenWeiPrice,
            uint256 firstTokenReserve,
            uint256 secondTokenReserve
        )
    {
        firstTokenAddress = address(firstToken);
        firstTokenSymbol = firstToken.symbol();
        firstTokenWeiPrice = firstToken.price();
        secondTokenAddress = address(secondToken);
        secondTokenSymbol = secondToken.symbol();
        secondTokenWeiPrice = secondToken.price();
        firstTokenReserve = firstToken.balanceOf(address(this));
        secondTokenReserve = secondToken.balanceOf(address(this));
    }
}
