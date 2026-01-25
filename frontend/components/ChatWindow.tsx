import Image from "next/image";
import { Message } from "./ChatLayout";
import { cn } from "@/app/lib/utils";

interface ChatWindowProps {
  messages: Message[];
}

export const ChatWindow = ({ messages }: ChatWindowProps) => {
  return (
    <div className="h-[80%] overflow-y-auto px-6 py-8 space-y-6">
      {messages.map((msg) => (
        <div
          key={msg.id}
          className={cn(
            "flex items-end gap-3",
            msg.role === "user" ? "justify-end" : "justify-start"
          )}
        >
          {/* AI avatar */}
          {msg.role === "assistant" && (
            <Image
              src="/ai-teacher.png" // put image in /public
              alt="AI Teacher"
              width={32}
              height={32}
              className="rounded-full"
            />
          )}

          {/* Message bubble */}
          <div
            className={cn(
              "max-w-xl px-4 py-3 rounded-2xl text-sm leading-relaxed",
              msg.role === "user"
                ? "bg-blue-600 text-white rounded-br-md"
                : "bg-white dark:bg-zinc-800 border dark:border-zinc-700 text-zinc-800 dark:text-zinc-100 rounded-bl-md"
            )}
          >
            {msg.content}
          </div>
        </div>
      ))}
    </div>
  );
};
