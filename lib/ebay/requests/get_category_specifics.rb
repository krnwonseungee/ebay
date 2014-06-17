require 'ebay/types/category_item_specifics'

module Ebay # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  value_array_node :category_ids, 'CategoryID', :default_value => []
    #  time_node :last_update_time, 'LastUpdateTime', :optional => true
    #  numeric_node :max_names, 'MaxNames', :optional => true
    #  numeric_node :max_values_per_name, 'MaxValuesPerName', :optional => true
    #  text_node :name, 'Name', :optional => true
    #  array_node :category_specifics, 'CategorySpecific', :class => CategoryItemSpecifics, :default_value => []
    #  boolean_node :exclude_relationships, 'ExcludeRelationships', 'true', 'false', :optional => true
    #  boolean_node :include_confidence, 'IncludeConfidence', 'true', 'false', :optional => true
    #  boolean_node :category_specifics_file_info, 'CategorySpecificsFileInfo', 'true', 'false', :optional => true
    class GetCategorySpecifics < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetCategorySpecificsRequest'
      value_array_node :category_ids, 'CategoryID', :default_value => []
      time_node :last_update_time, 'LastUpdateTime', :optional => true
      numeric_node :max_names, 'MaxNames', :optional => true
      numeric_node :max_values_per_name, 'MaxValuesPerName', :optional => true
      text_node :name, 'Name', :optional => true
      array_node :category_specifics, 'CategorySpecific', :class => CategoryItemSpecifics, :default_value => []
      boolean_node :exclude_relationships, 'ExcludeRelationships', 'true', 'false', :optional => true
      boolean_node :include_confidence, 'IncludeConfidence', 'true', 'false', :optional => true
      boolean_node :category_specifics_file_info, 'CategorySpecificsFileInfo', 'true', 'false', :optional => true
    end
  end
end



item = Ebay::Requests::GetCategorySpecifics.new(
  :category_ids => Ebay::Requests::GetCategorySpecifics.new( category_ids: [53159] ) #sample ID. replace with item ID after add_item call
)

begin
  # Get the item as passed in as the first argument
  response = ebay.get_category_specifics( :category_ids => item.category_ids.category_ids )

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
