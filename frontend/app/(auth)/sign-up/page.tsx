import Image from "next/image";

const page = () => {
  return (
    <main className="min-h-screen w-full flex bg-[var(--surface)]">
      <div className="w-full">
        <h1>hassanin</h1>
      </div>
      <div className="flex justify-center flex-col items-center">
      <Image
            // src="/logo.svg"
            src="/متقن.svg"
            alt="Motqin Logo"
            width={300}
            height={70}
            priority
          />
        <div className="hidden md:flex items-center justify-center -my-10 w-[900px] h-[600px]">
          <video
            src="/Research paper.mp4"
            autoPlay
            // loop
            muted
            playsInline
            className="max-w-125 w-full h-full"
          />
        </div>
      </div>
    </main>
  );
};

export default page;
