module RKit::ActiveRecordUtility::ActiveRecordExtend

  RKit::ActiveRecordUtility::UTILITIES.each do |utility, method_name|
    define_method method_name, ->(*args) do
      RKit::ActiveRecordUtility::Utility.const_get(utility.classify).new(self, method: __method__).interfere *args
    end
  end


  def interfered? utility
    RKit::ActiveRecordUtility::Utility.const_get(utility.classify).interfered? self
  rescue NameError
    false
  end


  def collection_finder **options
    collection = all
    collection = collection.pool options[:pool] if interfered? :pool
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
