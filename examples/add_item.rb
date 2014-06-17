#!/usr/bin/ruby
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__),'..', 'lib')

require 'ebay'
require 'config'

include Ebay
include Ebay::Types

# With no options, the default is to use the default site_id and the default
# auth_token configured on the Api class.
ebay = Api.new

# However, another user's auth_token can be used and the site can be selected
# at the time of creation. Ex: Canada with another user's auth token.
# ebay = Api.new(:site_id => 2, :auth_token => 'TEST')

# In this example I am simple passing in the strings 'Days_7', 'USD' and others.
# However, there are constants defined for these code types, which can be enumerated
# For example, CurrencyCode::CAD
# For enumerating through the available types: CurrencyCode.each{|code| puts code}

item = Ebay::Types::Item.new(
  :primary_category => Ebay::Types::Category.new(:category_id => 51581),
  :title => 'Ruby eBay API Test Listing',
  :description => 'Neesha Purple Keyhole Banded Maxi',
  :location => 'Ottawa, On',
  :start_price => Money.new(1200, 'USD'),
  :quantity => 1,
  :listing_duration => 'Days_7',
  :country => 'US',
  :currency => 'USD',
  :dispatch_time_max => 1,
  :payment_methods => ['VisaMC'],
  :condition_id => 1000,
  :shipping_details => Ebay::Types::ShippingDetails.new(
    :shipping_service_options => [
      Ebay::Types::ShippingServiceOptions.new(
        :shipping_service_priority => 2, # Display priority in the listing
        :shipping_service => 'UPSNextDay',
        :shipping_service_cost => Money.new(1000, 'USD'),
        :shipping_surcharge => Money.new(299, 'USD')
      )
    ]
  ),
  :picture_details => Ebay::Types::PictureDetails.new(
    :picture_urls => ["http://s3.amazonaws.com/boutiika-assets/image_library/BTKA_14029483086978557_28e0fe88768fbc94f883473ccf5f38.jpg"]
  ),

  :return_policy => Ebay::Types::ReturnPolicy.new(
    :returns_accepted_option => "ReturnsAccepted",
    :returns_within_option => "Days_14"
  ),

  :variations => Ebay::Types::Variation.new(
    :variation_specifics => [
      Ebay::Types::NameValueList.new(
          :name => "Color",
          :values => ["Purple", "White"]
      )
    ]
  )
)

begin
  response = ebay.add_item(:item => item)
  puts "Adding item"
  puts "eBay time is: #{response.timestamp}"

  puts "Item ID: #{response.item_id}"
  # puts "Fee summary: "
  # response.fees.select{|f| !f.fee.zero? }.each do |f|
  #   puts "  #{f.name}: #{f.fee.format(:with_currency)}"
  # end
rescue Ebay::RequestError => e
  e.errors.each do |error|
    puts error.long_message
  end
end
