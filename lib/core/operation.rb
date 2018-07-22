require 'dry/monads/result'
require 'dry/monads/do'
require 'dry/validation'

class Operation
  include Dry::Monads::Result::Mixin
  include Dry::Monads::Do.for(:call)

  def call
    raise NotImplementedError
  end

  # ----------------------------------------------------------
  # DSL
  # ----------------------------------------------------------

  def self.params_validation(&block)
    return @_params_validation if block.nil?
    @_params_validation = Dry::Validation.Params(&block)
  end

  def params_validation
    self.class.params_validation
  end
end
