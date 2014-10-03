module RKit::Dsl::ModuleExtend

  def act_as_a_dsl
    extend RKit::Dsl::DslExtend
  end


  def acts_as *names
    names.each do |name|
      send "acts_as_#{ name }"
    end
  end

  def try_to_acts_as *names
    names.each do |name|
      send "try_to_acts_as_#{ name }"
    end
  end


  Module.send :include, self
end
