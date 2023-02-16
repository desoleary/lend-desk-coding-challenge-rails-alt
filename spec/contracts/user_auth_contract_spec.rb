require 'rails_helper'

describe UserAuthContract,type: :dry_validation do
  it { is_expected.to validate(:email, :required) }
  it { is_expected.to validate(:password, :required) }
end
