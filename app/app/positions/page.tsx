"use client";
import React, { useState, useEffect } from 'react';
import { useWeb3ModalProvider, useWeb3ModalAccount } from '@web3modal/ethers/react';
import { getPositions, executeOption, withdrawOption, PositionData } from './interactions';
import LoadingScreen from "@/components/LoadingScreen";

const PositionsPage = () => {
  const { address, chainId, isConnected } = useWeb3ModalAccount();
  const { walletProvider } = useWeb3ModalProvider();
  const [activeTab, setActiveTab] = useState<'active' | 'closed'>('active');
  const [positionsData, setPositionsData] = useState<{ active: PositionData[], closed: PositionData[] }>({ active: [], closed: [] });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (isConnected && walletProvider) {
      (async () => {
        await fetchPositions();
      })();
    }
  }, [isConnected, walletProvider, chainId, address]);

  const fetchPositions = async () => {
    try {
      setLoading(true);
      const data = await getPositions(address, walletProvider, chainId);
      setPositionsData(data);
      setLoading(false);
    } catch (error) {
      console.error(error);
      setLoading(false);
    }
  }

  const onExecuteClick = async (addr: string, call: boolean) => {
    await executeOption(walletProvider, chainId, addr, call);
    await fetchPositions();
  }

  const onWithdrawClick = async (addr: string, call: boolean) => {
    await withdrawOption(walletProvider, chainId, addr, call);
    await fetchPositions();
  }

  const renderPosition = (position: PositionData) => (
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
          <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" onClick={() => onExecuteClick(position.contractAddr, position.type === 'CALL')}>
            Execute
          </button>
        ) : (
          <button className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded" onClick={() => onWithdrawClick(position.contractAddr, position.type === 'CALL')}>
            Withdraw
          </button>
        )}
      </div>
    </div>
  );

  return (
    <div className="p-4 md:p-8 bg-black min-h-full mt-32">
      {loading && <LoadingScreen />}  {/* Conditionally render the loading screen */}
      {!loading && (
        <>
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
        </>
      )}
    </div>
  );
};

export default PositionsPage;
