import { NextResponse } from "next/server";
import { stripe } from "@/lib/stripe";

export async function POST(request: Request) {
  try {
    const { priceId, productName, amount } = await request.json();

    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      payment_method_types: ["card"],
      line_items: [
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: productName || "Product",
            },
            unit_amount: amount || 99, // Default $0.99 in cents
          },
          quantity: 1,
        },
      ],
      success_url: `${request.headers.get("origin")}/payment/success`,
      cancel_url: `${request.headers.get("origin")}/payment`,
    });

    return NextResponse.json({ url: session.url });
  } catch (error) {
    console.error("Stripe checkout error:", error);
    return NextResponse.json(
      { error: "Failed to create checkout session" },
      { status: 500 }
    );
  }
}
