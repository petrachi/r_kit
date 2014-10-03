class DslDefinitionError < StandardError
  def initialize base
    # TODO: link to the doc
    super %Q{
DslDefinitionError: Wrong dsl definition order on `#{ base }',
  you can't declare a `domain' unless you have previously declared a `name' AND a `method'
  Please, visit XXX for more details
    }
  end
end
