"use client";

import { useState } from "react";
import { LessonCard } from "./LessonCard";

export const LessonCardClient = (props: any) => {
  const [hovered, setHovered] = useState(false);

  return (
    <div
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
    >
      <LessonCard {...props} arrowPlay={hovered} />
    </div>
  );
};
