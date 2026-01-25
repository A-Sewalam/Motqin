"use client";

import { useState } from "react";
import { Mic, Send } from "lucide-react";

interface ChatInputProps {
  onSend: (text: string) => void;
}

export const ChatInput = ({ onSend }: ChatInputProps) => {
  const [value, setValue] = useState("");

  const handleSend = () => {
    onSend(value);
    setValue("");
  };

  return (
    <div className="border-t bg-white px-4 py-3">
      <div className="flex items-end gap-3">
        <button
          type="button"
          className="p-2 rounded-full hover:bg-zinc-100"
          title="Voice input (coming soon)"
        >
          <Mic className="h-5 w-5 text-zinc-600" />
        </button>

        <textarea
          rows={1}
          value={value}
          onChange={(e) => setValue(e.target.value)}
          placeholder="Ask your AI Teacher..."
          className="flex-1 resize-none rounded-xl border text-black text-md font-medium border-zinc-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          onKeyDown={(e) => {
            if (e.key === "Enter" && !e.shiftKey) {
              e.preventDefault();
              handleSend();
            }
          }}
        />

        <button
          onClick={handleSend}
          className="p-2 rounded-full bg-blue-600 text-white hover:bg-blue-700"
        >
          <Send className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
};
