#Imports 
require 'sinatra'
require 'stripe'
require 'json'

#This is the secret part of the secret/publishable pair of keys necessary to complete a transaction. If mismatch between the secret and publishable keys, the charge will fail.
Stripe.api_key = 'sk_test_lrcSui9oDZEjRE0gaSBzUY5M00gTjCjB9r'

#Create the base / route that will print a statement if the back end has been set up correctly. Used to test your server.
get '/' do
  status 200
  return "Kolony backend back end has been set up correctly"
end

#Create /charge route. It will listen for requests from the iOS app and send charge requests to Stripe.
post '/charge' do
  #Parse the JSON sent by your iOS application.
  payload = params
  if request.content_type.include? 'application/json' and params.empty?
    payload = indifferent_params(JSON.parse(request.body.read))
  end

  begin
    #Create and invoke Stripe::Charge with various POST parameters.
    #amount- The amount in cents that you’ll charge your customer. You don't need to make any conversion here since your iOS app deals already with cents.
    #currency- short string that identifies the currency used for the transaction. Is usd in Kolony
    #source- The one-time token that you get back from
    #description- A descriptive message that you can easily recognize when you log into the Stripe dashboard. This is a good place for an internal transaction ID.
    charge = Stripe::Charge.create(
      :amount => payload[:amount],
      :currency => payload[:currency],
      :source => payload[:token],
      :description => payload[:description]
    )
    #Notify your app of error by returning the response that you receive from Stripe.
    rescue Stripe::StripeError => e
    status 402
    return "Error creating charge: #{e.message}"
  end
  #Success; Stripe account should have received money
  status 200
  return "Charge successfully created"

end
