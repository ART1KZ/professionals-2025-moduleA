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
        address _lpToken
    ) {
        firstToken = ERC20(_firstToken);
        secondToken = ERC20(_secondToken);
        lpToken = ERC20(_lpToken);
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
            string memory firstTokenName,
            address secondTokenAddress,
            string memory secondTokenName,
            uint256 firstTokenReserve,
            uint256 secondTokenReserve
        )
    {
        firstTokenAddress = address(firstToken);
        firstTokenName = firstToken.name();
        secondTokenAddress = address(secondToken);
        secondTokenName = secondToken.name();
        firstTokenReserve = firstToken.balanceOf(address(this));
        secondTokenReserve = secondToken.balanceOf(address(this));
    }
}
