require 'dry/monads/result'
require 'dry/monads/do'

class Operation
  include Dry::Monads::Result::Mixin
  include Dry::Monads::Do.for(:call)

  def call
    raise NotImplementedError
  end
end
