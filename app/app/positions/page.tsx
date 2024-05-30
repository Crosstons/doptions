"use client";
import React, { useState } from 'react';

type Position = {
  strikePrice: number;
  premiumPaid: number;
  type: 'Bought' | 'Written';
  amount: number;
};

const positionsData = {
    active: [
      { strikePrice: 32000, premiumPaid: 1200, type: 'Bought' as 'Bought' | 'Written', amount: 5 },
      { strikePrice: 34000, premiumPaid: 1100, type: 'Written' as 'Bought' | 'Written', amount: 3 },
    ],
    closed: [
      { strikePrice: 31000, premiumPaid: 1150, type: 'Written' as 'Bought' | 'Written', amount: 2 },
      { strikePrice: 35000, premiumPaid: 1250, type: 'Bought' as 'Bought' | 'Written', amount: 4 },
    ],
};  

const PositionsPage = () => {
  const [activeTab, setActiveTab] = useState<'active' | 'closed'>('active');

  const renderTable = (positions: Position[]) => (
    <table className="min-w-full divide-y divide-gray-700">
      <thead className="bg-gray-800 text-gray-300">
        <tr>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">
            Strike Price
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">
            Premium Paid
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">
            Type
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">
            Amount
          </th>
        </tr>
      </thead>
      <tbody className="bg-gray-900 divide-y divide-gray-700">
        {positions.map((position, index) => (
          <tr key={index}>
            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-400">{position.strikePrice}</td>
            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-400">{position.premiumPaid}</td>
            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-400">{position.type}</td>
            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-400">{position.amount}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );

  return (
    <div className="p-4 md:p-8 bg-gray-900 text-white">
      <div className="mb-4 border-b border-gray-700">
        <ul className="flex cursor-pointer text-sm font-medium text-center">
          <li className={`flex-1 p-4 ${activeTab === 'active' ? 'text-blue-500 border-b-2 border-blue-500' : 'text-gray-500'}`} onClick={() => setActiveTab('active')}>
            Active Positions
          </li>
          <li className={`flex-1 p-4 ${activeTab === 'closed' ? 'text-blue-500 border-b-2 border-blue-500' : 'text-gray-500'}`} onClick={() => setActiveTab('closed')}>
            Closed Positions
          </li>
        </ul>
      </div>
      <div>
        {activeTab === 'active' ? renderTable(positionsData.active) : renderTable(positionsData.closed)}
      </div>
    </div>
  );
};

export default PositionsPage;
