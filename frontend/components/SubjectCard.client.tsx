"use client";

import { useState } from "react";
import { SubjectCard } from "./SubjectCard";

export const SubjectCardClient = (props: any) => {
  const [hovered, setHovered] = useState(false);

  return (
    <div
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
    >
      <SubjectCard {...props} arrowPlay={hovered} />
    </div>
  );
};
