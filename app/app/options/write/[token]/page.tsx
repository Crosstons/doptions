"use client"
import React, { useState, useEffect } from 'react';
import { useWeb3ModalProvider, useWeb3ModalAccount } from '@web3modal/ethers/react';
import { BackgroundBeams } from '@/components/ui/background-beams';

type Props = {
  params: {
    token: string;
  };
};
import { createOptionCall } from './interactions';

const OptionForm: React.FC<Props> = ({ params }) => {
  const { address, chainId, isConnected } = useWeb3ModalAccount();
  const { walletProvider } = useWeb3ModalProvider();

  const [activeTab, setActiveTab] = useState<'call' | 'put'>('call');
  const [strikePrice, setStrikePrice] = useState('');
  const [premium, setPremium] = useState('');
  const [expiration, setExpiration] = useState('');
  const [quantity, setQuantity] = useState('');
  const [livePrice, setLivePrice] = useState('');

  useEffect(() => {
    if (isConnected && walletProvider) {
      // Example to fetch live price, implement your own logic here
      fetch(`https://api.example.com/price/${params.token}`)
        .then(response => response.json())
        .then(data => setLivePrice(data.price))
        .catch(error => console.error('Failed to fetch price:', error));
    }
  }, [isConnected, walletProvider, params.token]);

  const tabClass = (tab: 'call' | 'put') => (
    `${activeTab === tab ? (tab === 'call' ? 'bg-green-500' : 'bg-red-500') : 'bg-gray-800'} 
     inline-block w-full p-4 text-white hover:bg-opacity-75 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-lg`
  );

  const convertToUnixTimestamp = (expiration: string) => {
    const date = new Date(expiration);
    const unixTimestamp = Math.floor(date.getTime() / 1000);
    
    return unixTimestamp;
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!strikePrice || !premium || !expiration || !quantity) {
      alert('All fields are required.');
      return;
    }

    let unixExpiration = convertToUnixTimestamp(expiration);

    const formData = {
      type: activeTab.toUpperCase(),
      token: params.token,
      strikePrice,
      premium,
      unixExpiration,
      quantity
    };

    console.log('Form Data:', formData);

    createOptionCall(formData);

  };

  return (
    <div className="bg-[#1a1a1a] p-6 min-h-screen">
      <div className="max-w-xl mx-auto mt-32">
        <div className="text-center mb-4 text-xl font-semibold text-white">
          Current {params.token} Price: ${livePrice}
        </div>
        <div className="mb-4">
          <ul className="flex">
            <li className="flex-1 mr-2">
              <button
                className={tabClass('call')}
                onClick={() => setActiveTab('call')}
              >
                {/* SVG for Call */}
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" className="inline-block w-6 h-6 mr-2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18 9 11.25l4.306 4.306a11.95 11.95 0 0 1 5.814-5.518l2.74-1.22m0 0-5.94-2.281m5.94 2.28-2.28 5.941" />
                </svg>
                Call
              </button>
            </li>
            <li className="flex-1 ml-2">
              <button
                className={tabClass('put')}
                onClick={() => setActiveTab('put')}
              >
                {/* SVG for Put */}
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" className="inline-block w-6 h-6 mr-2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6 9 12.75l4.286-4.286a11.948 11.948 0 0 1 4.306 6.43l.776 2.898m0 0 3.182-5.511m-3.182 5.51-5.511-3.181" />
                </svg>
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
              placeholder='55'
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
            Submit
          </button>
        </form>
      </div>
    </div>
  );
};

export default OptionForm;
