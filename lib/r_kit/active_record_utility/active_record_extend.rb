module RKit::ActiveRecordUtility::ActiveRecordExtend

  RKit::ActiveRecordUtility::UTILITIES.each do |utility, method_name|

    define_method method_name do
      RKit::ActiveRecordUtility::Utility.const_get(utility.classify).new(self, method: __method__).interfere
    end

  end

  def interfered? utility
    RKit::ActiveRecordUtility::Utility.const_get(utility.classify).interfered? model_klass
  rescue NameError
    false
  end

  ActiveRecord::Base.extend self
end
