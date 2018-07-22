require 'dry/monads/result'
require 'dry/monads/do'
require 'dry/validation'

class Operation
  include Dry::Monads::Result::Mixin

  def self.inherited(subclass)
    subclass.include Dry::Monads::Do.for(:call)
  end

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

  # ----------------------------------------------------------
  # Helpers
  # ----------------------------------------------------------

  def params_validation
    self.class.params_validation
  end

  def validate(params)
    validation = params_validation.call(params)
    validation.failure? ? Failure(validation.errors) : Success(validation.output)
  end
end
