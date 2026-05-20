import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from "npm:stripe@14.5.0"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const secretKey = Deno.env.get('STRIPE_SECRET_KEY');
    if (!secretKey) throw new Error("Missing STRIPE_SECRET_KEY");

    const stripe = new Stripe(secretKey, {
      apiVersion: '2023-10-16',
      httpClient: Stripe.createFetchHttpClient(),
    })

    const { amount, currency, planName } = await req.json()

    // 1. Generate the Mobile Token (For iOS/Android)
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, 
      currency: currency || 'usd',
    })

    // 2. Generate the Web Checkout Link (For Chrome)
    // Stripe requires a success/cancel URL to return the user to after payment
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: currency || 'usd',
          product_data: { name: `${planName} Membership` },
          unit_amount: amount,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: 'http://localhost:59955/#/success', // Update this to your live domain later!
      cancel_url: 'http://localhost:59955/#/cancel',
    })

    // Send BOTH back to Flutter
    return new Response(
      JSON.stringify({ 
        paymentIntent: paymentIntent.client_secret,
        checkoutUrl: session.url 
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 200 }
    )
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), { headers: corsHeaders, status: 400 })
  }
})