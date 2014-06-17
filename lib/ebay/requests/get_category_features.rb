
module Ebay # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  text_node :category_id, 'CategoryID', :optional => true
    #  numeric_node :level_limit, 'LevelLimit', :optional => true
    #  boolean_node :view_all_nodes, 'ViewAllNodes', 'true', 'false', :optional => true
    #  value_array_node :feature_ids, 'FeatureID', :default_value => []
    #  boolean_node :all_features_for_category, 'AllFeaturesForCategory', 'true', 'false', :optional => true
    class GetCategoryFeatures < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetCategoryFeaturesRequest'
      text_node :category_id, 'CategoryID', :optional => true
      numeric_node :level_limit, 'LevelLimit', :optional => true
      boolean_node :view_all_nodes, 'ViewAllNodes', 'true', 'false', :optional => true
      value_array_node :feature_ids, 'FeatureID', :default_value => []
      boolean_node :all_features_for_category, 'AllFeaturesForCategory', 'true', 'false', :optional => true
    end
  end
end


item = Ebay::Requests::GetCategoryFeatures.new(
  :category_id => Ebay::Requests::GetCategoryFeatures.new( category_id: 51581 ) #sample ID. replace with item ID after add_item call
)

begin
  # Get the item as passed in as the first argument
  response = ebay.get_category_features( :category_id => item.category_id.category_id )

  # Get the item, which is of the type Ebay::Types::Item
  item = response.item
  puts "The item number is: #{item.item_id}"
  puts "The item was listed at: #{item.listing_details.start_time}"
  puts "The item can be viewed at: #{item.listing_details.view_item_url}"
  puts "The starting price is: #{item.listing_details.converted_start_price.format(:with_currency)}"
rescue Ebay::RequestError => e
  e.errors.each do |error|
    puts error.long_message
  end
end
