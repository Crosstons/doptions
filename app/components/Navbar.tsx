"use client";
import React, { useState } from "react";
import { HoveredLink, Menu, MenuItem, ProductItem } from "../components/ui/navbar-menu";
import { cn } from "@/utils/cn";

export default function Navbar({ className }: { className?: string }) {
  const [active, setActive] = useState<string | null>(null);
  return (
    <nav
      className={cn("fixed top-10 inset-x-0 max-w-2xl mx-auto z-50 border-2 border-gray-900 rounded-full", className)}
    >
      <Menu setActive={setActive}>
        <MenuItem setActive={setActive} active={active} item="Home">
        </MenuItem>
        <MenuItem setActive={setActive} active={active} item="Products">
        </MenuItem>
        <MenuItem setActive={setActive} active={active} item="Pricing">
        </MenuItem>
      </Menu>
    </nav>
  );
}
