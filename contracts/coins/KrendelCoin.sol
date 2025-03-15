// SPDX-Licenese-Identifier: MIT

pragma solidity ^0.8.28;

import "../ERC20.sol";

contract KrendelCoin is ERC20 {
    constructor() ERC20("KrendelCoin", "KRENDEL", 150000, 12, 1.5 ether) {}
}
