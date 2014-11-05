class RKit::Decoration::Object < SimpleDelegator
  include RKit::Decoration::Base


  singleton_attr_reader :decorated_class



  # TODO: we might want to delete the 'after_initialize' thing, as it is useless
  # and not a good answer to the problem we tried to solve with this
  # wich is, recursive decoration
  singleton_attr_reader :after_initialize_procs, default: proc{ [] }

  def self.after_initialize &block
    after_initialize_procs << block
  end

  def after_initialize!
    decorator_class.after_initialize_procs.each{ |after_initialize_proc| self.instance_eval &after_initialize_proc }
  end


  def initialize obj, view_context: nil
    super
    after_initialize!
  end
end
