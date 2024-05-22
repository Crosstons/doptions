import React from 'react';
import { BackgroundBeams } from '@/components/ui/background-beams';

// Sample data for options
const optionsData = {
    calls: [
        { tokenImg: "/path-to-token-image1.png", strikePrice: "3000", premium: "150", expirationDate: "2023-12-01", quantity: "10" },
        { tokenImg: "/path-to-token-image2.png", strikePrice: "3100", premium: "120", expirationDate: "2023-12-01", quantity: "5" }
    ],
    puts: [
        { tokenImg: "/path-to-token-image3.png", strikePrice: "2900", premium: "180", expirationDate: "2023-12-01", quantity: "8" },
        { tokenImg: "/path-to-token-image4.png", strikePrice: "2800", premium: "200", expirationDate: "2023-12-01", quantity: "10" }
    ]
};

const Page = () => {
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
                                        <img src={option.tokenImg} alt="Token" className="w-8 h-8 rounded-full" />
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.strikePrice}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.premium}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.expirationDate}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.quantity}</td>
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
                                        <img src={option.tokenImg} alt="Token" className="w-8 h-8 rounded-full" />
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.strikePrice}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.premium}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.expirationDate}</td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-800 dark:text-neutral-200">{option.quantity}</td>
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
