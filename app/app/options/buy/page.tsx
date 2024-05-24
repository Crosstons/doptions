"use client"; 

import React from 'react';
import { useState, useEffect } from 'react';
import { getOptions, OptionData } from './interactions';
import { useWeb3ModalProvider, useWeb3ModalAccount } from '@web3modal/ethers/react'
import { BackgroundBeams } from '@/components/ui/background-beams';

const Page = () => {

    const { address, chainId, isConnected } = useWeb3ModalAccount();
    const { walletProvider } = useWeb3ModalProvider();

    const [optionsData, setOptionsData] = useState<{ calls: OptionData[], puts: OptionData[] }>({
        calls: [],
        puts: []
    })

    useEffect(() => {
        if (isConnected && walletProvider) {
          (async () => {
            try {
              const data = await getOptions(walletProvider);
              setOptionsData(data);
            } catch (error) {
              console.error(error);
            }
          })();
        }
      }, [isConnected, walletProvider]);

    return (
        <div className="flex flex-row h-screen bg-black text-white pt-32">
            {/* Call Options Side */}
            <div className="w-1/2 overflow-hidden p-4">
                <h2 className="text-2xl font-bold mb-4 text-green-500 w-full text-center">Call Options</h2>
                <div className="overflow-x-auto">
                    <table className="min-w-full divide-y divide-gray-200 dark:divide-neutral-700">
                        <thead>
                            <tr>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Token</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Strike Price</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Premium</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Expiration</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Quantity</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200 dark:divide-neutral-700 ">
                            {optionsData.calls.map((option, index) => (
                                <tr key={index}>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200 ">
                                        <img src={option.tokenImg} alt={option.tokenImg} className="w-8 h-8 rounded-full" />
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">${option.strikePrice}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">${option.premium}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.expirationDate}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.quantity} {option.tokenImg}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Put Options Side */}
            <div className="w-1/2 overflow-hidden p-4 border-l border-gray-700">
                <h2 className="text-2xl font-bold mb-4 text-red-500 w-full text-center">Put Options</h2>
                <div className="overflow-x-auto">
                    <table className="min-w-full divide-y divide-gray-200 dark:divide-neutral-700">
                        <thead>
                            <tr>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Token</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Strike Price</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Premium</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Expiration</th>
                                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase dark:text-neutral-500">Quantity</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200 dark:divide-neutral-700">
                            {optionsData.puts.map((option, index) => (
                                <tr key={index}>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">
                                        <img src={option.tokenImg} alt={option.tokenImg} className="w-8 h-8 rounded-full" />
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">${option.strikePrice}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">${option.premium}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.expirationDate}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.quantity} {option.tokenImg}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}

export default Page;
