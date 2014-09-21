module ActiveRecord::ModelSchema::ClassMethods

  def column_exists? column_name
    !!columns_hash[column_name]
  end

end
