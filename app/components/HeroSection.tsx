"use client";
import { motion } from "framer-motion";
import { HeroHighlight, Highlight } from "./ui/hero-highlight";
import {Button} from './ui/moving-border'
import Link from "next/link";

export default function HeroHighlightDemo() {
  return (
    <HeroHighlight>
      <motion.h1
        initial={{
          opacity: 0,
          y: 20,
        }}
        animate={{
          opacity: 1,
          y: [20, -5, 0],
        }}
        transition={{
          duration: 0.5,
          ease: [0.4, 0.0, 0.2, 1],
        }}
        className="text-3xl px-4 md:text-4xl lg:text-5xl font-bold bg-clip-text text-transparent bg-gradient-to-b from-neutral-200 to-neutral-600 font-sanss max-w-4xl leading-relaxed lg:leading-snug text-center mx-auto mb-4"
      >
        Welcome to Truly Decentralized Options Protocol
        
      </motion.h1>
      <div className="inline-flex justify-center items-center w-full">
      <Link href={'/options/'}>
      <Button
        borderRadius="1.75rem"
        className="bg-white dark:bg-[#0a0a0a] text-black dark:text-white border-neutral-100 dark:border-slate-900"
      >
        Explore
      </Button>
      </Link>
      </div>
    </HeroHighlight>
  );
}
