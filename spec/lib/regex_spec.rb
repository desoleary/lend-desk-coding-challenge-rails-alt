require 'rails_helper'

describe Regex do
  describe '.match?' do
    let(:value) { nil }
    let(:type) { nil }

    subject { described_class.match?(type, value) }

    describe ':email' do
      let(:type) { :email }

      context 'with valid email' do
        let(:value) { 'email@domain.com' }

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with invalid email' do
        let(:value) { 'emaild.g' }

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
     end

    describe ':password_min_length' do
      let(:password_length) { described_class::PASSWORD_MIN_LENGTH }
      let(:type) { :password_min_length }
      let(:value) { 'a' * password_length  }

      context 'with value matching min length ' do
        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value exceeding min length ' do
        let(:password_length) { described_class::PASSWORD_MIN_LENGTH  + 1}

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value less than min length ' do
        let(:password_length) { described_class::PASSWORD_MIN_LENGTH  - 1}

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
    end

    describe ':password_min_numerics' do
      let(:numeric_length) { described_class::PASSWORD_MIN_NUMERICS }
      let(:character) { '1' }
      let(:type) { :password_min_numerics }
      let(:value) { character * numeric_length  }

      context 'with numerics matching minimum ' do
        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value exceeding min length ' do
        let(:numeric_length) { described_class::PASSWORD_MIN_NUMERICS + 1}

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value less than min length ' do
        let(:numeric_length) { described_class::PASSWORD_MIN_NUMERICS - 1}

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end

      context 'with non numeric characters' do
        let(:character) { 'a' }

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
    end

    describe ':password_min_uppercase' do
      let(:min_length) { described_class::PASSWORD_MIN_UPPERCASE }
      let(:character) { 'A' }
      let(:type) { :password_min_uppercase }
      let(:value) { character * min_length  }

      context 'with uppercase matching minimum ' do
        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value exceeding min length ' do
        let(:min_length) { described_class::PASSWORD_MIN_UPPERCASE + 1}

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value less than min length ' do
        let(:min_length) { described_class::PASSWORD_MIN_UPPERCASE - 1}

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end

      context 'with lowercase characters' do
        let(:character) { 'a' }

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
    end

    describe ':password_min_lowercase' do
      let(:min_length) { described_class::PASSWORD_MIN_LOWERCASE }
      let(:character) { 'a' }
      let(:type) { :password_min_lowercase }
      let(:value) { character * min_length  }

      context 'with lowercase matching minimum ' do
        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value exceeding min length ' do
        let(:min_length) { described_class::PASSWORD_MIN_LOWERCASE + 1}

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value less than min length ' do
        let(:min_length) { described_class::PASSWORD_MIN_LOWERCASE - 1}

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end

      context 'with uppercase characters' do
        let(:character) { 'A' }

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
    end

    describe ':password_min_symbols' do
      let(:min_length) { described_class::PASSWORD_MIN_SYMBOLS }
      let(:character) { '^' }
      let(:type) { :password_min_symbols }
      let(:value) { character * min_length  }

      context 'with symbols matching minimum ' do
        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value exceeding min length ' do
        let(:min_length) { described_class::PASSWORD_MIN_SYMBOLS + 1}

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'with value less than min length ' do
        let(:min_length) { described_class::PASSWORD_MIN_SYMBOLS - 1}

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end

      context 'with non symbol characters' do
        let(:character) { 'a' }

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
    end
  end
end
