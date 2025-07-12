import React from 'react';
import { ethers } from 'ethers';

const WalletConnect = ({ setProvider, setSigner, setAccount, connectContract }) => {
  const connectWallet = async () => {
    if (window.ethereum) {
      try {
        const provider = new ethers.BrowserProvider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        const signer = await provider.getSigner();
        const account = await signer.getAddress();
        
        setProvider(provider);
        setSigner(signer);
        setAccount(account);
        await connectContract(signer);
      } catch (error) {
        console.error("Wallet connection failed:", error);
      }
    } else {
      alert("Please install MetaMask!");
    }
  };

  return (
    <button onClick={connectWallet}>Connect Wallet</button>
  );
};

export default WalletConnect;
