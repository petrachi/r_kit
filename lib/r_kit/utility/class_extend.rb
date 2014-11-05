class Class

  def depend on:, &block
    methods = self.methods
    instance_methods = self.instance_methods

    class_eval &block

    (self.methods - methods).each do |method_name|
      override_singleton_method method_name do |*args, &block|
        if send(on).present? # TODO: use kernel 'then', wich use 'conditionnal statement', wich will include procs
          super *args, &block
        else
          nil
        end
      end
    end

    (self.instance_methods - instance_methods).each do |method_name|
      override_method method_name do |*args, &block|
        if send(on).present?
          super *args, &block
        else
          nil
        end
      end
    end


    #tmp = Module.new(&block)

    #p tmp.instance_methods(false)

  end

end
