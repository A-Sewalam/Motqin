import { LucideIcon } from "lucide-react";
import { cn } from "@/app/lib/utils";

interface FeatureCardProps {
  title: string;
  description: string;
  icon: LucideIcon;
  variant: "planner" | "competition" | "ai-teacher" | "quiz" | "focus";
  size?: "small" | "medium" | "large" | "hero";
  stats?: { label: string; value: string }[];
  className?: string;
  backgroundImage?: string;
  backgroundIcon?: LucideIcon;
  
}

const variantStyles = {
  planner: "bg-blue-600/45 text-hero-foreground",
  competition: "bg-competition/40 text-competition-foreground",
  "ai-teacher": "bg-ai-teacher/40 text-white",
  quiz: "bg-quiz/40 text-quiz-foreground",
  focus: "bg-focus/40 text-white",
};

const ghostIconStyles = {
  planner: "text-blue-300/30",
  competition: "text-yellow-300/50",
  "ai-teacher": "text-purple-300/30",
  quiz: "text-emerald-300/30",
  focus: "text-red-300/25",
};

const iconBgStyles = {
  planner: "bg-white/20",
  competition: "bg-white/20",
  "ai-teacher": "bg-white/20",
  quiz: "bg-white/20",
  focus: "bg-white/20",
};

export const FeatureCard = ({
  title,
  description,
  icon: Icon,
  variant,
  backgroundIcon: BackgroundIcon,
  size = "medium",
  stats,
  className,
  backgroundImage,
}: // onClick,
FeatureCardProps) => {
  const isHero = size === "hero";
  const isLarge = size === "large";
  const isMedium = size === "medium";
  const isSmall = size === "small";
  return (
    <div
      
      className={cn(
        "relative overflow-hidden rounded-3xl p-4 text-left transition-all duration-300",
        "hover:scale-[1.02] hover:shadow-xl active:scale-[0.98]",
        "flex flex-col justify-between h-full",
        // variantStyles[variant],
        className
      )}
    >
      {/* Decorative elements for larger cards */}
      {(isHero || isLarge) && (
        <>
          <div className="absolute -right-8 -top-8 h-32 w-32 rounded-full bg-white/10 blur-2xl" />
          <div className="absolute -bottom-4 -left-4 h-24 w-24 rounded-full bg-black/10 blur-xl" />
        </>
      )}

      {/* Ghost background icon */}
      {BackgroundIcon && (
        <BackgroundIcon
          strokeWidth={1}
          fill="currentColor"
          className={cn(
            "absolute pointer-events-none z-[2]",
            "right-6 bottom-12",
            isHero ? "h-64 w-64" : isLarge ? "h-56 w-48" : "h-40 w-40",
            "blur-xs rotate-12",
            ghostIconStyles[variant]
          )}
        />
      )}
      {backgroundImage && (
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{ backgroundImage: `url(${backgroundImage})` }}
        />
      )}

      <div
        className={cn(
          "absolute inset-0 backdrop-blur-lg",
          variantStyles[variant]
        )}
      />

      <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent" />

      {/* Top section */}
      <div className="relative z-10">
        <div
          className={cn(
            "flex items-center justify-center rounded-2xl",
            iconBgStyles[variant],
            isHero
              ? "h-14 w-14 mb-4"
              : isLarge
              ? "h-12 w-12 mb-3"
              : isMedium
              ? "h-10 w-10 mb-2"
              : "h-8 w-8 mb-1"
          )}
        >
          <Icon
            className={cn(
              isHero
                ? "h-7 w-7"
                : isLarge
                ? "h-6 w-6"
                : isMedium
                ? "h-5 w-5"
                : "h-4 w-4"
            )}
          />
        </div>

        <h3
          className={cn(
            "font-bold leading-tight",
            isHero
              ? "text-2xl mb-2"
              : isLarge
              ? "text-xl mb-1"
              : isMedium
              ? "text-lg mb-1"
              : "text-sm"
          )}
        >
          {title}
        </h3>

        {(isHero || isLarge || isMedium) && (
          <p
            className={cn(
              "opacity-80 leading-snug",
              isHero
                ? "text-sm max-w-[200px]"
                : isLarge
                ? "text-xs max-w-[180px]"
                : "text-xs"
            )}
          >
            {description}
          </p>
        )}
      </div>

      {/* Stats section for larger cards */}
      {stats && stats.length > 0 && (isHero || isLarge || isMedium) && (
        <div
          className={cn(
            "relative z-10 mt-auto pt-4",
            isHero || isLarge ? "flex gap-6" : "flex gap-4"
          )}
        >
          {stats.map((stat, index) => (
            <div key={index}>
              <p
                className={cn(
                  "font-bold",
                  isHero ? "text-2xl" : isLarge ? "text-xl" : "text-lg"
                )}
              >
                {stat.value}
              </p>
              <p
                className={cn("opacity-70", isHero ? "text-xs" : "text-[10px]")}
              >
                {stat.label}
              </p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
