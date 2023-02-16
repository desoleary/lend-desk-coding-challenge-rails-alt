class UserAuthContract < ApplicationContract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
