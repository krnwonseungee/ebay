#!/usr/bin/ruby
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'ebay'
require 'config'

ebay = Ebay::Api.new

# Revise the item identified by the item_id passed in on the command line
item = Ebay::Types::Item.new(
  :item_id => 110144856857,
  :description => 'Welcome to Mapel Boutique! ',
  :picture_details => Ebay::Types::PictureDetails.new(
    :gallery_type => "Gallery",
    :picture_urls => [
      "http://s3.amazonaws.com/boutiika-assets/image_library/BTKA_14029482999886508_124dd21b381d291a466b6d6d33f38b.jpg"
    ]
  ),
  :buy_it_now_price => Money.new(9500, 'USD')
)

item = Ebay::Types::Item.new(
  :primary_category => Ebay::Types::Category.new(:category_id => 50986),
  :title => 'Neesha',
  :description => 'Welcome to Mapel Boutique!',
  :location => 'Tigard, OR',
  :start_price => Money.new(7200, 'USD'),
  :quantity => 1,
  :listing_duration => 'Days_7',
  :country => 'US',
  :currency => 'USD',
  :dispatch_time_max => 1,
  :payment_methods => ['VisaMC'],
  :condition_id => 1000,
  :picture_details => Ebay::Types::PictureDetails.new(
    :gallery_type => "Featured",
    :picture_urls => [
      "http://s3.amazonaws.com/boutiika-assets/image_library/BTKA_14029483086978557_28e0fe88768fbc94f883473ccf5f38.jpg",
      "http://s3.amazonaws.com/boutiika-assets/image_library/BTKA_14029482999886508_124dd21b381d291a466b6d6d33f38b.jpg"
    ]
  ),
  :return_policy => Ebay::Types::ReturnPolicy.new(
    :returns_accepted_option => "ReturnsAccepted",
    :returns_within_option => "Days_14"
  ),
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
  response = ebay.revise_item(:item => item)
  puts "Successfully revised item: #{response.item_id}"
  puts "Item start time: #{response.start_time}"
  puts "Item end time: #{response.end_time}"

  # Display any additional fees
  fees = response.fees.select{|f| !f.fee.zero? }

  if fees.any?
    puts "Incurred additional fees:"
    fees.each do |f|
      puts "  #{f.name}: #{f.fee.format(:with_currency)}"
    end
  end
rescue Ebay::RequestError => e
  e.errors.each do |error|
    puts error.long_message
  end
end
