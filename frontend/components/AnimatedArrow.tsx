"use client";

import Lottie from "lottie-react";
import { useEffect, useRef } from "react";
import arrowAnimation from "@/public/lottie/right-arrow.json";

interface AnimatedArrowProps {
  size?: number;
  play?: boolean;
}

export const AnimatedArrow = ({
  size = 32,
  play = false,
}: AnimatedArrowProps) => {
  const lottieRef = useRef<any>(null);

  useEffect(() => {
    if (play) {
      lottieRef.current?.play();
    } else {
      lottieRef.current?.stop();
    }
  }, [play]);

  return (
    <Lottie
      lottieRef={lottieRef}
      animationData={arrowAnimation}
      loop={false}
      autoplay={false}
      style={{ width: size, height: size }}
    />
  );
};
