"use client";
import React from "react";
import Image from "next/image";
import { CardBody, CardContainer, CardItem } from "@/components/ui/3d-card";
import Link from "next/link";
import btc from '@/public/Bitcoin_logo.png';
import sol from '@/public/Solana_logo.png';
import lin from '@/public/Chainlink_logo.png';
import san from '@/public/Sand_logo.png';
import eth from '@/public/Ethereum_logo.png';
import mat from '@/public/Matic_logo.png';

const tokens = [
  { id: 1, name: "Bitcoin", image: btc },
  { id: 2, name: "Solana", image: sol },
  { id: 3, name: "Ethereum", image: eth },
  { id: 4, name: "Link", image: lin },
  { id: 5, name: "Matic", image: mat },
  { id: 6, name: "Sand", image: san }
];

export default function TokenCards() {
  return (
    <>
    <h1 className="mt-36 text-3xl px-4 md:text-4xl lg:text-5xl font-bold bg-clip-text text-transparent bg-gradient-to-b from-neutral-200 to-neutral-600 font-sanss max-w-4xl leading-relaxed lg:leading-snug text-center mx-auto -mb-16">Select Token</h1>
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 p-8"> {/* Increased spacing between cards */}
      {tokens.map(token => (
        <CardContainer key={token.id} className="inter-var">
          <CardBody className=" relative group dark:hover:shadow-2xl hover:shadow-emerald-500/[0.1] bg-black border-white/[0.2]  w-auto sm:w-[30rem] h-auto rounded-xl p-6 border">
            <CardItem
              translateZ="50"
              className="text-xl font-bold text-neutral-600 dark:text-white"
            >
              {token.name}
            </CardItem>
            <CardItem translateZ="100" className="w-full">
              <Image
                src={token.image}
                height={1000}
                width={1000}
                className="h-60 w-full object-contain rounded-xl group-hover:shadow-xl"
                alt={token.name}
              />
            </CardItem>
            <div className="flex justify-center mt-4"> {/* Centered the button and removed the link */}
              <CardItem
                as={Link}
                href={`/options/write/${token.name.toUpperCase()}`}
                translateZ={20}
                className="px-6 py-2 rounded-xl bg-red-500 text-white text-sm font-bold" // Changed to red button
              >
                Write
              </CardItem>
            </div>
          </CardBody>
        </CardContainer>
      ))}
    </div>
    </>
  );
}
