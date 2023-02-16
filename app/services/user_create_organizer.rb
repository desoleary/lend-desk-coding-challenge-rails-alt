class UserCreateOrganizer < LightServiceExt::ApplicationOrganizer
  def self.steps
    [ValidatorAction, UserCreateAction]
  end

  class ValidatorAction < LightServiceExt::ApplicationValidatorAction
    self.contract_class = UserCreateContract
  end
end
