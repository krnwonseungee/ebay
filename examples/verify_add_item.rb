#!/usr/bin/ruby
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__),'..', 'lib')

require 'ebay'
require 'config'
require 'xml/mapping'

# This is the same as add_item, but doesn't actually list the item
ebay = Ebay::Api.new

item = Ebay::Types::Item.new(
  :primary_category => Ebay::Types::Category.new(:category_id => 57882),
  :title => 'Ruby eBay API Test Listing',
  :description => 'Welcome!',
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
  )
)

begin
  response = ebay.verify_add_item( :item => item )
  puts "Verifying item"

  puts "Item ID: #{response.item_id}"
  puts "Fee summary: "
  response.fees.select{|f| !f.fee.zero? }.each do |f|
    puts "  #{f.name}: #{f.fee.format(:with_currency)}"
  end
rescue Ebay::RequestError => e
  e.errors.each do |error|
    puts error.long_message
  end
end
