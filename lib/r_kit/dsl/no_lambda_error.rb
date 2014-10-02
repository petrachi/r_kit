class NoLambdaError < StandardError
  def initialize
    # TODO: add a link to smthng that explain the difference between proc & lambda
    # TODO: why not one of my videos ;)
    super %Q{
NoLambdaError: You need to use a lambda, not a proc
  Use the fancy ruby2 `->(){}', or the good old `lambda{}' syntax
    }
  end
end
