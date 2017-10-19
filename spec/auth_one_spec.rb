require "spec_helper"

RSpec.describe AuthOne do
  it "has a version number" do
    expect(AuthOne::VERSION).not_to be nil
  end

  describe '#configuration' do
    it 'has a default value' do
      expect(described_class.configuration)
        .to have_attributes described_class.const_get('DEFAULT_CONFIGURATION')
    end
  end
  describe '#configure' do
    it 'allows changing the configuration' do
      expect do
        described_class.configure { |config| config.private_key = 'a' }
      end.to change(described_class.configuration, :private_key)
        .from(nil).to('a')
    end
  end
end
