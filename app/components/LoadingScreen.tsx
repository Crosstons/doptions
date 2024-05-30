// LoadingScreen.tsx
import React from 'react';

const LoadingScreen: React.FC = () => {
  return (
    <div className="fixed inset-0 bg-black flex flex-col items-center justify-center z-50">
      <div className="animate-spin rounded-full h-32 w-32 border-t-4 border-b-4 border-gray-900"></div>
      <p className="text-white mt-5 animate-pulse text-l">Please Confirm Transactions If Any</p>
      <p className="text-white mt-5 animate-pulse text-4xl">...</p>
    </div>
  );
};

export default LoadingScreen;