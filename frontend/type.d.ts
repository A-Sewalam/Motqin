export interface CustomInputProps {
    placeholder?: string;
    value?: string;
    type:string
    onChange?: (event: React.ChangeEvent<HTMLInputElement>) => void;
    label: string;
    className?:string;
    icon?:React.ReactNode;
    keyboardType?: | "email" | "numeric" | "tel"|"text";
}

export interface CustomButtonProps {
    title: string;
    leftIcon?: React.ReactNode;
    href?: string; // if provided → acts as Link
    onClick?: () => void;
    variant?: "primary" | "outline" | "google" | "facebook";
    disabled?: boolean;
    className?: string;
    type?: "button" | "submit" | "reset";
  }
  