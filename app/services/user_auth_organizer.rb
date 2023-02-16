class UserAuthOrganizer < LightServiceExt::ApplicationOrganizer
  def self.steps
    [ValidatorAction, UserAuthAction]
  end

  class ValidatorAction < LightServiceExt::ApplicationValidatorAction
    self.contract_class = UserAuthContract
  end
end
