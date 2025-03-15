// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "../ERC20.sol";

contract Professional is ERC20 {
    constructor() ERC20("Professional", "PROFI", 0, 12, 6 ether) {}
}
