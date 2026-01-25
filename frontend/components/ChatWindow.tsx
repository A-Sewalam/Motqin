import { Message } from "./ChatLayout";
import { cn } from "@/app/lib/utils";

interface ChatWindowProps {
  messages: Message[];
}

export const ChatWindow = ({ messages }: ChatWindowProps) => {
  return (
    <div className=" h-8/10  overflow-y-auto px-6 py-8 space-y-6">
      {messages.map((msg) => (
        <div
          key={msg.id}
          className={cn(
            "max-w-xl px-4 py-3 rounded-2xl text-sm leading-relaxed",
            msg.role === "user"
              ? "ml-auto bg-blue-600 text-white"
              : "mr-auto bg-white border text-zinc-800"
          )}
        >
          {msg.content}
        </div>
      ))}
    </div>
  );
};
