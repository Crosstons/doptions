'use client'
import React, { useState, useEffect } from 'react';
import { useWeb3ModalProvider, useWeb3ModalAccount } from '@web3modal/ethers/react';

const OptionForm = ({ params }: { params: { token : string } }) => {

  const { address, chainId, isConnected } = useWeb3ModalAccount();
  const { walletProvider } = useWeb3ModalProvider();

  const [activeTab, setActiveTab] = useState('call');
  const [strikePrice, setStrikePrice] = useState('');
  const [premium, setPremium] = useState('');
  const [expiration, setExpiration] = useState('');
  const [quantity, setQuantity] = useState('');

  useEffect(() => {
    if (isConnected && walletProvider) {
      (async () => {
        try {

        } catch (error) {
          console.error(error);
        }
      })();
    }
  }, [isConnected, walletProvider]);

  const tabClass = (tab: string) => (
    `${activeTab === tab ? 'bg-gray-700 text-white' : 'bg-gray-800 text-gray-400'} 
     inline-block w-full p-4 hover:text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500`
  );

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (!strikePrice || !premium || !expiration || !quantity) {
      alert('All fields are required.');
      return;
    }

    const formData = {
      type: activeTab.toUpperCase(),
      token: params.token,
      strikePrice,
      premium,
      expiration,
      quantity
    };

    console.log('Form Data:', formData);
    // Add your form submission logic here
  };

  return (
    <div className="bg-gray-900 p-6 min-h-screen">
      <div className="max-w-xl mx-auto mt-32">
        <div className="mb-4">
          <ul className="flex">
            <li className="flex-1">
              <button
                className={`${tabClass('call')} rounded-tl-lg rounded-bl-lg`}
                onClick={() => setActiveTab('call')}
              >
                Call
              </button>
            </li>
            <li className="flex-1 ">
              <button
                className={`${tabClass('put')} rounded-tr-lg rounded-br-lg`}
                onClick={() => setActiveTab('put')}
              >
                Put
              </button>
            </li>
          </ul>
        </div>

        <form className="bg-gray-800 p-5 rounded-lg" onSubmit={handleSubmit}>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Strike Price</label>
            <input
              type="number"
              value={strikePrice}
              onChange={(e) => setStrikePrice(e.target.value)}
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
              placeholder="Enter Strike Price (USD)"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Premium</label>
            <input
              type="number"
              value={premium}
              onChange={(e) => setPremium(e.target.value)}
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
              placeholder="Enter Premium (DAI)"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Expiration Date and Time</label>
            <input
              type="datetime-local"
              value={expiration}
              onChange={(e) => setExpiration(e.target.value)}
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Quantity</label>
            <input
              type="number"
              value={quantity}
              onChange={(e) => setQuantity(e.target.value)}
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
              placeholder={`Enter ${params.token.toUpperCase()}`}
            />
          </div>
          <button
            type="submit"
            className="w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            Write
          </button>
        </form>
      </div>
    </div>
  );
};

export default OptionForm;