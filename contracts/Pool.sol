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

    function addLiquidity(uint256 _firstTokenAmount, uint256 _secondTokenAmount) external {
        firstToken.transferFrom(msg.sender, address(this), _firstTokenAmount);
        secondToken.transferFrom(msg.sender, address(this), _secondTokenAmount);

        uint256 lpAmount = ((firstToken.price() * _firstTokenAmount) + (secondToken.price() * _secondTokenAmount)) / lpToken.price();
        lpToken.mint(msg.sender, lpAmount);
    }

    // function swap(bool _isSwappingFirstTokenToSecond, uint256 _amountIn) external {
    //     ERC20 tokenIn = _isSwappingFirstTokenToSecond ? firstToken : secondToken;
    //     ERC20 tokenOut = _isSwappingFirstTokenToSecond ? secondToken : firstToken;

    //     tokenIn.transferFrom(msg.sender, address(this), _amountIn);

    //     uint256 amountOut = 1;
    //     tokenOut.transferFrom(address(this), msg.sender, amountOut);
    // }

    function getInfo() view external returns(address firstTokenAddr, address secondTokenAddr, uint256 firstTokenReserve, uint256 secondTokenReserve) {
        firstTokenAddr = address(firstToken);
        secondTokenAddr = address(secondToken);
        firstTokenReserve = firstToken.balanceOf(address(this));
        secondTokenReserve = secondToken.balanceOf(address(this));
    }
}
