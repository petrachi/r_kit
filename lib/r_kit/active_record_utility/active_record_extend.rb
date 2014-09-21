module RKit::ActiveRecordUtility::ActiveRecordExtend

  RKit::ActiveRecordUtility::UTILITIES.each do |utility, method_name|
    define_method method_name, ->(*args) do
      RKit::ActiveRecordUtility::Utility.const_get(utility.classify).new(self, method_name: __method__).interfere *args
    end
  end


  def interferences_options_set utility, **options
    instance_variable_set "@_active_record_utilities_self", utility
    instance_variable_set "@_active_record_utilities_#{ utility }_options", options
  end

  def interferences_options_get utility = @_active_record_utilities_self
    instance_variable_get "@_active_record_utilities_#{ utility }_options"
  end


  def interfered? utility
    RKit::ActiveRecordUtility::Utility.const_get(utility.classify).interfered? self
  rescue NameError
    false
  end


  def collection_finder **options
    collection = all
    collection = collection.pool options[:pool] if interfered? :pool
    collection = collection.published.publication_desc if interfered? :publisher
    collection = collection.series options[:series] if interfered? :series
    collection
  end

  def instance_finder **options
    if interfered? :tag
      tagged options[:tag]
    else
      find_by id: options[:id]
    end
  end


  ActiveRecord::Base.extend self
end
