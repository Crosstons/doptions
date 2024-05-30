"use client";
import React, { useState } from "react";
import { HoveredLink, Menu, MenuItem, ProductItem } from "../components/ui/navbar-menu";
import { cn } from "@/utils/cn";
import Link from "next/link";
import Button3 from "./Button3";

export default function Navbar({ className }: { className?: string }) {
  const [active, setActive] = useState<string | null>(null);
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
          {/* <Button3 /> */}
      </Menu>
    </nav>
  );
}
