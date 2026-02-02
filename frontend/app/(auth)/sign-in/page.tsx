"use client";
import CustomButton from "@/components/CustomButton";
import CustomInput from "@/components/CustomInput";
import { Key, Mail, User } from "lucide-react";
import { FcGoogle } from "react-icons/fc";
import Image from "next/image";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { FaFacebook } from "react-icons/fa";
import Link from "next/link";

const SignUp = () => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [form, setForm] = useState({ email: "", password: "", username: "" });
  const router = useRouter();

  const submit = async () => {
    if (!form.email || !form.password || !form.username) {
      console.log("enter the the required data please ");
      setIsSubmitting(true);
      try {
        console.log("you have sing up succefully ");
        router.replace("/");
      } catch (error) {
        console.log(error);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  return (
    <main className="min-h-screen w-full flex bg-[var(--surface)]">
      <div className=" w-130 min-w-100 flex flex-col gap-7 h-[88vh] m-10 p-10 bg-white rounded-3xl">
        <h1 className="text-3xl font-bold text-left">Login</h1>
        <CustomButton
          title="Login with Google"
          leftIcon={<FcGoogle size={24} />}
          href="/api/auth/google"
          variant="google"
          className="w-full text-md font-semibold"
        />
        <CustomButton
          title="Login with Facebook"
          leftIcon={<FaFacebook size={24} />}
          href="/api/auth/facebook"
          variant="facebook"
          className="w-full text-md font-semibold"
        />
        <CustomInput
          placeholder="example@gmail.com"
          label="Email"
          value={form.email}
          type="email"
          keyboardType="email"
          onChange={(e) =>
            setForm((prev) => ({ ...prev, email: e.target.value }))
          }
          className="w-full"
          icon={<Mail size={18} />}
        />
        <CustomInput
          label="Password"
          value={form.password}
          type="password"
          onChange={(e) =>
            setForm((prev) => ({ ...prev, password: e.target.value }))
          }
          // className="w-full"
          icon={<Key size={18} />}
        />
        <div className="font-medium text-right">
          <Link href={"/sign-in"}>
            <span className="text-blue-600 ">Forget password?</span>
          </Link>
        </div>

        <CustomButton
          title="sing up"
          type="submit"
          className="w-full text-md font-semibold"
        />

        <div className="my-1 text-sm flex justify-center items-center gap-2">
          <p className="text-gray-700">Are you new?</p>
          <Link href={"/sign-up"}>
            <span className="text-blue-600 ">Sign Up</span>
          </Link>
        </div>
      </div>
      <div className="hidden md:flex flex-1 justify-center items-center">
        <div className="flex flex-col items-center gap-6 w-full">
          <Image
            src="/متقن.svg"
            alt="Motqin Logo"
            width={300}
            height={70}
            priority
            className="-mb-20"
          />

          <div className="relative w-full max-w-[900px] h-[550px]">
            <Image
              src="/Research paper-rafiki.svg"
              alt="Motqin Illustration"
              fill
              className="object-contain"
              priority
            />
          </div>
        </div>
      </div>
    </main>
  );
};

export default SignUp;
