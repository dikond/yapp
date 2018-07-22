require 'core/operation'

module Operations
  class Register < Operation
    params_validation do
      required(:user).schema do
        required(:agent).filled(:str?)
      end
    end

    def call(params)
      output = yield validate(params)

      Success(User.create(output[:user]))
    end
  end
end
