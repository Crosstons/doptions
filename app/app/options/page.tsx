import Link from "next/link";
import React from "react";

export default function DotBackgroundDemo() {
  return (
    <div className="h-screen flex-col w-full bg-black bg-dot-white/[0.2] relative flex items-center justify-center">
      {/* Radial gradient for the container to give a faded look */}
      <div className="absolute pointer-events-none inset-0 flex items-center justify-center dark:bg-black bg-white [mask-image:radial-gradient(ellipse_at_center,transparent_20%,black)]"></div>
      <h1 className="text-3xl px-4 md:text-4xl lg:text-5xl font-bold bg-clip-text text-transparent bg-gradient-to-b from-neutral-200 to-neutral-600 font-sanss max-w-4xl leading-relaxed lg:leading-snug text-center mx-auto mb-4">What is your investment type?</h1>
      <div className="space-x-4">
                {/* Button for "Write an Option" */}
                <Link href="/options/write">
                <button className="relative inline-flex h-12 overflow-hidden rounded-full p-[1px] focus:outline-none focus:ring-2 focus:ring-slate-400 focus:ring-offset-2 focus:ring-offset-slate-50">
                <span className="absolute inset-[-1000%] animate-[spin_2s_linear_infinite] bg-[conic-gradient(from_90deg_at_50%_50%,#882222_0%,#b73434_50%,#f86161_100%)]" />
                <span className="inline-flex h-full w-full cursor-pointer items-center justify-center rounded-full bg-slate-950 px-6 py-2 text-sm font-medium text-white backdrop-blur-3xl">
                    Write an option
                </span>
                </button>
                </Link>
                
                {/* Button for "Buy an Option" */}
                <Link href="/options/buy">
                  <button className="relative inline-flex h-12 overflow-hidden rounded-full p-[1px] focus:outline-none focus:ring-2 focus:ring-slate-400 focus:ring-offset-2 focus:ring-offset-slate-50">
                  <span className="absolute inset-[-1000%] animate-[spin_2s_linear_infinite] bg-[conic-gradient(from_90deg_at_50%_50%,#008000_0%,#32CD32_50%,#00FF00_100%)]" />
                  <span className="inline-flex h-full w-full cursor-pointer items-center justify-center rounded-full bg-slate-950 px-6 py-2 text-sm font-medium text-white backdrop-blur-3xl">
                      Buy an option
                  </span>
                  </button>
                  </Link>
            </div>
    </div>
  );
}
