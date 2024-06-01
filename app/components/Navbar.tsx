"use client";
import React, { useState, useEffect } from "react";
import { HoveredLink, Menu, MenuItem, ProductItem } from "../components/ui/navbar-menu";
import { useWeb3ModalProvider, useWeb3ModalAccount } from '@web3modal/ethers/react';
import { getTokens } from "@/web3/Faucet";
import { cn } from "@/utils/cn";
import Link from "next/link";
import Button3 from "./Button3";

export default function Navbar({ className }: { className?: string }) {
  const { address, chainId, isConnected } = useWeb3ModalAccount();
  const { walletProvider } = useWeb3ModalProvider();
  const [active, setActive] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (isConnected && walletProvider) {
      (async () => {
        console.log("Network / Account Changed");
      })();
    }
  }, [isConnected, walletProvider, chainId, address]);

  const onFaucet = async () => {
    setLoading(true);
    try {
      await getTokens(address, walletProvider, chainId);
    } catch (err) {
      console.log(err);
    } finally {
      setLoading(false);
    }
  }

  return (
    <nav
      className={cn("fixed top-10 inset-x-0 max-w-2xl mx-auto z-50 border-2 border-gray-900 rounded-full ", className)}
    >
      <Menu setActive={setActive}>
        <Link href="/">
        <MenuItem setActive={setActive} active={active} item="Home"></MenuItem>
        </Link>
        <Link href="/options">
        <MenuItem setActive={setActive} active={active} item="Options"></MenuItem>
        </Link>
        <Link href="/positions">
        <MenuItem setActive={setActive} active={active} item="Positions"></MenuItem>
        </Link>
          <w3m-button />
          <button onClick={onFaucet}>
          <Button3 text={loading ? "Loading..." : "Token Faucet"} />
          </button>
      </Menu>
    </nav>
  );
}
