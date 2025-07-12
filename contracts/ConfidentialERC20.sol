// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint256, externalEuint256} from "@fhevm/solidity/lib/FHE.sol";
import {SepoliaZamaFHEVMConfig} from "./ZamaFHEVMConfig.sol";

contract ConfidentialERC20 is SepoliaZamaFHEVMConfig {
    string public name = "Confidential Token";
    string public symbol = "CTOK";
    uint8 public decimals = 18;
    
    mapping(address => euint256) private _balances;
    mapping(address => mapping(address => euint256)) private _allowances;
    euint256 private _totalSupply;
    
    event Transfer(address indexed from, address indexed to, bytes ciphertext);
    
    constructor() {
        // Mint initial supply to deployer (1,000,000 tokens)
        _totalSupply = FHE.asEuint256(1000000 * 10**18);
        _balances[msg.sender] = _totalSupply;
        FHE.allow(_totalSupply, address(this));
        FHE.allow(_balances[msg.sender], msg.sender);
    }
    
    function balanceOf(address account, bytes calldata inputProof) public view returns (bytes memory) {
        require(FHE.isVerified(account, inputProof), "Invalid proof");
        return FHE.decrypt(_balances[account]);
    }
    
    function transfer(address to, externalEuint256 memory amount, bytes calldata inputProof) public {
        require(to != address(0), "Invalid address");
        euint256 encryptedAmount = FHE.fromExternal(amount, inputProof);
        
        euint256 senderBalance = _balances[msg.sender];
        require(FHE.decrypt(FHE.gte(senderBalance, encryptedAmount)), "Insufficient balance");
        
        _balances[msg.sender] = FHE.sub(senderBalance, encryptedAmount);
        _balances[to] = FHE.add(_balances[to], encryptedAmount);
        
        FHE.allow(_balances[msg.sender], msg.sender);
        FHE.allow(_balances[to], to);
        
        emit Transfer(msg.sender, to, FHE.encrypt(encryptedAmount));
    }
    
    function totalSupply() public view returns (bytes memory) {
        return FHE.decrypt(_totalSupply);
    }
}
