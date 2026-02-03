"use client";

import { useEffect } from "react";

export default function PaymentSuccessPage() {
  useEffect(() => {
    // Redirect to download link after a short delay
    const timer = setTimeout(() => {
      window.location.href = "https://sungjoonpark.net";
    }, 3000);

    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-6">
      <h1 className="text-4xl font-bold">Payment Successful!</h1>
      <p className="text-muted-foreground">
        Thank you for your purchase. Redirecting you to your download...
      </p>
      <p className="text-sm text-muted-foreground">
        If you are not redirected,{" "}
        <a
          href="https://sungjoonpark.net"
          className="underline hover:text-foreground"
        >
          click here
        </a>
      </p>
    </div>
  );
}
