class LoginSessionCreateContract < ApplicationContract
  params do
    required(:user_id).filled(:string)
  end
end
