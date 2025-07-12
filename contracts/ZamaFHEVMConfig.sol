// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE} from "@fhevm/solidity/lib/FHE.sol";

abstract contract SepoliaZamaFHEVMConfig {
    constructor() {
        // Configure FHEVM for Sepolia testnet
        FHE.setConfig(
            0x0000000000000000000000000000000000000080, // TFHE address
            0x0000000000000000000000000000000000000081  // Gateway address
        );
    }
}
