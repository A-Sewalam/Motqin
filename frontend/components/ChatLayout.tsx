"use client";

import { useState } from "react";
import { Sidebar } from "./Sidebar";
import { ChatWindow } from "./ChatWindow";
import { ChatInput } from "./ChatInput";

export interface Message {
  id: string;
  role: "user" | "assistant";
  content: string;
}

export const ChatLayout = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "1",
      role: "assistant",
      content: "Hi 👋 I’m your AI Teacher. What topic are you studying today?",
    },
  ]);

  const handleSend = (text: string) => {
    if (!text.trim()) return;

    const userMessage: Message = {
      id: crypto.randomUUID(),
      role: "user",
      content: text,
    };

    setMessages((prev) => [...prev, userMessage]);

    // 🔜 Later: replace this with API response
    setTimeout(() => {
      setMessages((prev) => [
        ...prev,
        {
          id: crypto.randomUUID(),
          role: "assistant",
          content: "Great question! Let’s break this down step by step.",
        },
      ]);
    }, 800);
  };

  return (
    <div className="flex h-full">
      <Sidebar />
      <div className="flex flex-col flex-1">
        <ChatWindow messages={messages} />
        <ChatInput onSend={handleSend} />
      </div>
    </div>
  );
};
