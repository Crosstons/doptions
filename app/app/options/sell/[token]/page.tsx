'use client'
import React, { useState } from 'react';

const OptionForm = ({ params }: { params: { token : string } }) => {
  const [activeTab, setActiveTab] = useState('call');

  // Function to dynamically set the tab class based on active state
  const tabClass = (tab: string) => (
    `${activeTab === tab ? 'bg-gray-700 text-white' : 'bg-gray-800 text-gray-400'} 
     inline-block w-full p-4 hover:text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500`
  );

  console.log(params.token)

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

        <form className="bg-gray-800 p-5 rounded-lg">
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Strike Price</label>
            <input
              type="number"
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
              placeholder="Enter strike price"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Premium</label>
            <input
              type="number"
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
              placeholder="Enter premium amount"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Expiration Date and Time</label>
            <input
            placeholder='55'
              type="datetime-local"
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
            />
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-300">Quantity</label>
            <input
              type="number"
              className="mt-1 block w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-white"
              placeholder="Enter quantity"
            />
          </div>
          <button
            type="submit"
            className="w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            Sell
          </button>
        </form>
      </div>
    </div>
  );
};

export default OptionForm;
