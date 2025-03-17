// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "./ERC20.sol";

contract Staking {
    ERC20 lpToken;
    uint256 rewardPerSecond;

    struct UserStaking {
        uint256 tokensStaked;
        uint256 lastRewardTime;
    }
    mapping(address => UserStaking) stakings;

    constructor(address _lpToken, uint256 _rewardPerSecond) {
        lpToken = ERC20(_lpToken);
        rewardPerSecond = _rewardPerSecond;
    }

    function stake(uint256 _amount) external {
        lpToken.transferFrom(msg.sender, address(this), _amount);
        stakings[msg.sender].tokensStaked += _amount;
    }

    function claimReward() external {
        uint256 allLP = lpToken.balanceOf(address(this));
        uint256 countLP = stakings[msg.sender].tokensStaked;
        uint256 lastRewardTime = stakings[msg.sender].lastRewardTime;
        uint256 reward = countLP * (block.timestamp - lastRewardTime) * rewardPerSecond * (countLP / allLP + 1) * (((block.timestamp - lastRewardTime) / 30 days) / 20 + 1);

        lpToken.mint(msg.sender, reward);
        lastRewardTime = block.timestamp;
    }
}
