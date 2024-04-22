import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> { }

const inputVariants = cva(
  "flex h-9 w-full rounded-2xl border-2 disabled:border-slate-300 disabled:bg-slate-50 border-2 px-3 py-1 text-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-blue-200/40 disabled:cursor-not-allowed disabled:opacity-50",
  {
    variants: {
      variant: {
        blue: "border-blue-400 bg-blue-50",
        orange: "border-orange-400 bg-orange-50",
      },
    },
    defaultVariants: {
      variant: "blue",
    },
  },
);

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement>,
  VariantProps<typeof inputVariants> {
  asChild?: boolean;
}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, variant, ...props }, ref) => {
    return (
      <input
        className={cn(inputVariants({ variant, className }))}
        ref={ref}
        {...props}
      />
    );
  },
)
Input.displayName = "Input";

export { Input, inputVariants };
