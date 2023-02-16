class LoginSessionCreateOrganizer < LightServiceExt::ApplicationOrganizer
  def self.steps
    [ValidatorAction, LoginSessionCreateAction]
  end

  class ValidatorAction < LightServiceExt::ApplicationValidatorAction
    self.contract_class = LoginSessionCreateContract
  end
end
