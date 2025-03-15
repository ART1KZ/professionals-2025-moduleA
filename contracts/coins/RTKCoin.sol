// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "../ERC20.sol";

contract RTKCoin is ERC20 {
    constructor() ERC20("RTKCoin", "RTK", 300000, 12, 3 ether) {}
}
