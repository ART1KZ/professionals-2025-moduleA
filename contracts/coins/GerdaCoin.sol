// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "../ERC20.sol";

contract GerdaCoin is ERC20 {
    constructor() ERC20("GerdaCoin", "GERDA", 100000, 12, 1 ether) {}
}