import Link from "next/link";
import { cn } from "@/app/lib/utils";
import { AnimatedArrow } from "./AnimatedArrow";

type LessonState = "start" | "continue" | "review";

interface LessonCardProps {
  title: string;
  description?: string;
//   lessons: number;
  hours: number;
  state: LessonState;
  href: string;
  className?: string;
  arrowPlay?: boolean;

}

const stateStyles: Record<LessonState, string> = {
  start: "bg-emerald-100 text-emerald-700",
  continue: "bg-blue-100 text-blue-700",
  review: "bg-amber-100 text-amber-700",
};

export const LessonCard = ({
  title,
  description,
//   lessons,
  hours,
  state,
  href,
  className,
  arrowPlay
}: LessonCardProps) => {
  return (
    <Link
      href={href}
      className={cn(
        "group relative block rounded-2xl p-6",
        "bg-white border border-zinc-200",
        "transition-all duration-300",
        "hover:shadow-xl hover:-translate-y-1",
        className
      )}
    >
      {/* Header */}
      <div className="flex items-start justify-between gap-4">
        <div>
          <h2 className="text-xl font-bold text-zinc-900">{title}</h2>
          {description && (
            <p className="text-sm text-zinc-600 mt-1 max-w-md">
              {description}
            </p>
          )}
        </div>

        {/* State badge */}
        <span
          className={cn(
            "px-3 py-1 rounded-full text-xs font-semibold capitalize",
            stateStyles[state]
          )}
        >
          {state}
        </span>
      </div>

      {/* Stats */}
      <div className="flex gap-6 mt-6 text-sm text-zinc-700">
        {/* <div>
          <span className="font-semibold">{lessons}</span> lessons
        </div> */}
        <div>
          <span className="font-semibold">{hours}</span> hours
        </div>
      </div>

      {/* Action button */}
      <div className="absolute bottom-6 right-6">
        <div
          className={cn(
            "flex items-center justify-center",
            "h-10 w-10 rounded-full",
            "bg-blue-100 text-blue-700",
            "transition-all duration-300",
            "group-hover:bg-gradient-to-r group-hover:from-blue-500 group-hover:to-blue-700",
            "group-hover:text-white"
          )}
        >
                    <AnimatedArrow size={30} play={arrowPlay} />

        </div>
      </div>
    </Link>
  );
};
