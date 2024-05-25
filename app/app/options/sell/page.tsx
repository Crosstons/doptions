"use client";
import React from "react";
import { motion } from "framer-motion";
import { LampContainer } from "@/components/ui/lamp";
import Image from "next/image";
import btc from '@/public/Bitcoin_logo.png'
import sol from '@/public/Solana_logo.png'
import lin from '@/public/Chainlink_logo.png'
import san from '@/public/Sand_logo.png'
import eth from '@/public/Ethereum_logo.png'
import mat from '@/public/Matic_logo.png'
import { HoverEffect } from "@/components/ui/card-hover-effect";

const tokens = [
    { id: 1, name: "Bitcoin", image: btc },
    { id: 2, name: "Solana", image: sol },
    { id: 3, name: "Ethereum", image: eth },
    { id: 4, name: "Link", image: lin },
    { id: 5, name: "Matic", image: mat },
    { id: 6, name: "Sand", image: san }    
  ];

export default function Page() {
  return (
    <LampContainer>
      <h1 className="textmt-8 bg-gradient-to-br from-slate-300 to-slate-500 py-4 bg-clip-text text-center text-4xl font-medium tracking-tight text-transparent md:text-7xl">Token Showcase</h1>
      <div className="flex flex-wrap justify-center items-center mt-8">
        
      {tokens.map((token) => (
        <div key={token.id} className="p-4 m-2 border shadow-lg rounded-lg bg-black">
          <div className="flex flex-col items-center justify-center">
            <Image src={token.image} alt={token.name} width={100} height={100} className="min-w-[100px] min-h-[100px] object-contain"/>
            <p className="mt-2 text-center text-sm font-semibold text-white">{token.name}</p>
          </div>
        </div>
      ))}
    </div>
    </LampContainer>
  );
}
