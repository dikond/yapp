require 'core/operation'

module Operations
  class Register < Operation
    params_validation do
      required(:user).schema do
        required(:agent).filled(:str?)
      end
    end

    def call(params)
      validation = params_validation.call(params)
      return Failure(validation.errors) if validation.failure?

      user = User.create(validation.output[:user])
      Success(user)
    end
  end
end
