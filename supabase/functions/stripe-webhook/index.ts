import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from "npm:stripe@14.5.0"
import { createClient } from "npm:@supabase/supabase-js@2"

// 1. Initialize Stripe
const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') as string, {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

// 2. We will set this secret in the Supabase dashboard later
const endpointSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET') as string;

serve(async (req) => {
  // Stripe requires the raw text body to verify the cryptographic signature
  const signature = req.headers.get('Stripe-Signature');
  
  if (!signature) {
    return new Response('No signature provided', { status: 400 });
  }

  try {
    const body = await req.text();
    let event;

    // 3. Verify the event came from Stripe and nobody else
    try {
      event = stripe.webhooks.constructEvent(body, signature, endpointSecret);
    } catch (err: any) {
      console.error(`Webhook signature verification failed: ${err.message}`);
      return new Response(`Webhook Error: ${err.message}`, { status: 400 });
    }

    // 4. Initialize a Supabase Admin Client to bypass RLS for background updates
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // 5. Handle a successful Web Checkout
    if (event.type === 'checkout.session.completed') {
      const session = event.data.object as any;
      
      // These are the details we passed into the checkout session earlier
      const paymentIntentId = session.payment_intent;
      const amountPaid = session.amount_total / 100; // Convert cents to dollars
      
      // Update your payment_history table with the receipt!
      await supabaseAdmin.from('payment_history').update({
        status: 'succeeded',
        receipt_url: session.receipt_url
      }).eq('stripe_payment_intent_id', paymentIntentId);
      
      console.log(`Payment logged successfully for Intent: ${paymentIntentId}`);
    }

    // Acknowledge receipt of the event to Stripe
    return new Response(JSON.stringify({ received: true }), { status: 200 });

  } catch (error: any) {
    console.error(`Unexpected Webhook Error: ${error.message}`);
    return new Response('Internal Server Error', { status: 500 });
  }
})