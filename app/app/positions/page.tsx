"use client";
import React, { useState } from 'react';

type Position = {
  tokenName: string;
  strikePrice: number;
  type: 'CALL' | 'PUT';
  quantity: number;
  expiration: string;
  premiumPaid: number;
  positionType: 'Bought' | 'Written';
};

const positionsData = {
    active: [
      { tokenName: 'BITCOIN', strikePrice: 67000, type: 'CALL' as 'CALL' | 'PUT', quantity: 5, expiration: '2023-12-01', premiumPaid: 1500, positionType: 'Bought' as 'Bought' | 'Written' },
      { tokenName: 'ETHEREUM', strikePrice: 5000, type: 'PUT' as 'CALL' | 'PUT', quantity: 10, expiration: '2023-12-01', premiumPaid: 300, positionType: 'Written' as 'Bought' | 'Written' },
    ],
    closed: [
      { tokenName: 'BITCOIN', strikePrice: 62000, type: 'CALL' as 'CALL' | 'PUT', quantity: 2, expiration: '2023-06-01', premiumPaid: 1100, positionType: 'Written' as 'Bought' | 'Written' },
      { tokenName: 'ETHEREUM', strikePrice: 4500, type: 'PUT' as 'CALL' | 'PUT', quantity: 8, expiration: '2023-06-01', premiumPaid: 250, positionType: 'Bought' as 'Bought' | 'Written' },
    ],
};
  

const PositionsPage = () => {
  const [activeTab, setActiveTab] = useState<'active' | 'closed'>('active');

  const renderPosition = (position: Position) => (
    <div className="bg-gray-800 p-4 my-2 rounded-lg text-white shadow-md">
      <div className="text-lg font-semibold">
        <span>{position.tokenName}</span> <span>{position.strikePrice}</span> <span>{position.type}</span>
      </div>
      <div className="flex justify-between items-center mt-2">
        <div>
          <div>Quantity: {position.quantity}</div>
          <div>Expires on: {position.expiration}</div>
        </div>
        <div>
          Premium Paid: ${position.premiumPaid}
        </div>
      </div>
      <div className="mt-2">
        {position.positionType === 'Bought' ? (
          <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            Execute
          </button>
        ) : (
          <button className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
            Withdraw
          </button>
        )}
      </div>
    </div>
  );

  return (
    <div className="p-4 md:p-8 bg-black min-h-full mt-32">
      <div className="mb-4 border-b border-gray-700">
        <ul className="flex cursor-pointer text-sm font-medium text-center text-gray-500">
          <li className={`flex-1 p-4 ${activeTab === 'active' ? 'text-blue-500 border-b-2 border-blue-500' : 'text-gray-500'}`} onClick={() => setActiveTab('active')}>
            Active Positions
          </li>
          <li className={`flex-1 p-4 ${activeTab === 'closed' ? 'text-blue-500 border-b-2 border-blue-500' : 'text-gray-500'}`} onClick={() => setActiveTab('closed')}>
            Closed Positions
          </li>
        </ul>
      </div>
      <div>
        {activeTab === 'active' ? positionsData.active.map(renderPosition) : positionsData.closed.map(renderPosition)}
      </div>
    </div>
  );
};

export default PositionsPage;
