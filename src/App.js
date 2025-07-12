import React, { useState } from 'react';
import { ethers } from 'ethers';
import { FHEVM } from './utils/fhevm';
import WalletConnect from './components/WalletConnect';
import BalanceDisplay from './components/BalanceDisplay';
import TransferForm from './components/TransferForm';
import './App.css';

function App() {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [contract, setContract] = useState(null);
  const [account, setAccount] = useState(null);

  const contractAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS";

  const connectContract = async (signer) => {
    const contract = new ethers.Contract(
      contractAddress,
      [
        "function balanceOf(address, bytes) view returns (bytes)",
        "function transfer(address, externalEuint256, bytes)",
        "function totalSupply() view returns (bytes)"
      ],
      signer
    );
    setContract(contract);
  };

  return (
    <div className="App">
      <h1>Confidential Token DApp</h1>
      <WalletConnect
        setProvider={setProvider}
        setSigner={setSigner}
        setAccount={setAccount}
        connectContract={connectContract}
      />
      {account && contract && (
        <>
          <BalanceDisplay contract={contract} account={account} fhevm={FHEVM} />
          <TransferForm contract={contract} account={account} fhevm={FHEVM} />
        </>
      )}
    </div>
  );
}

export default App;
