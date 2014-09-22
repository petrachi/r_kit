module RKit::Pagination::ActiveRecordExtend

  # TODO: use rkit::dsl for this
  # class X < RKit::Dsl::Base
  #   for Y #this is the targeted class
  #   name :act_as_xable
  #   instance_interfere do; end #class methods
  #   class_interfere do; end #instance_methods
  #   decorator_interfere do; end #decorator_methods
  #   can_interfere? do; #auth to load the dsl in a specific class
  # end
  # All of this is largely inspired by the work on ARutility

  def acts_as_paginables
    define_singleton_method "paginate", ->(page: nil, per_page: nil) do
      RKit::Pagination::Base.new(all, page: page, per_page: per_page)
    end
  end

  # we need to create a "paginate" scope, that will create a Pagination::base object

  ActiveRecord::Base.extend self
end
