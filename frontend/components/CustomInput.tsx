"use client";

import { cn } from "@/app/lib/utils";
import { CustomInputProps } from "@/type";
import { useState } from "react";
import { Eye, EyeOff } from "lucide-react";

const CustomInput = ({
  placeholder,
  value,
  label,
  type,
  onChange,
  keyboardType,
  icon,
  className,
}: CustomInputProps) => {

  const [isFocused, setIsFocused] = useState(false);
  const [showPassword, setShowPassword] = useState(false);


  return (
    <div className={cn("w-full space-y-1")}>
      {label && (
        <label className="text-md font-semibold text-gray-700">
          {label}
        </label>
      )}

      <div className="relative">
        {/* Left icon */}
        {icon && (
          <span className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
            {icon}
          </span>
        )}

        <input
        //   {...props}
        type={
          type === "password"
            ? showPassword
              ? "text"
              : "password"
            : type
        }
          placeholder={placeholder}
          value={value}
          inputMode={keyboardType}
          onChange={onChange}
          className={cn(
            "w-full rounded-lg border px-3 py-3 text-sm",
            icon && "pl-10",
            type=== ' password' && "pr-10",
            "border-gray-300",
            "focus:border-blue-600 focus:ring-2 focus:ring-blue-100",
            "outline-none transition",
            className
          )}
        />

        {/* Password toggle */}
        {type === 'password' && (
          <button
            type="button"
            
            onClick={() => setShowPassword(!showPassword)}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
          >
            {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
          </button>
        )}
      </div>
    </div>
  );

}
export default CustomInput;
