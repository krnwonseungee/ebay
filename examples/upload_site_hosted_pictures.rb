#!/usr/bin/ruby
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__),'..', 'lib')

require 'ebay'
require 'config'

ebay = Ebay::Api.new

picture_request = Ebay::Requests::UploadSiteHostedPictures.new(
  :picture_name => "2nd picture",
  :external_picture_urls => ["http://s3.amazonaws.com/boutiika-assets/image_library/BTKA_14029482999886508_124dd21b381d291a466b6d6d33f38b.jpg"]
)

begin
  response = ebay.upload_site_hosted_pictures(
    picture_name: picture_request.picture_name,
    external_picture_urls: picture_request.external_picture_urls,
  )

rescue Ebay::RequestError => e
  e.errors.each do |error|
    puts error.long_message
  end
end

