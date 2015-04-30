# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_mac_os_x'

describe Chef::Provider::DivvyApp::MacOsX do
  let(:name) { 'Some App' }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:authorize_app!)
    end

    it 'authorizes the Divvy app' do
      expect_any_instance_of(described_class).to receive(:authorize_app!)
      provider.send(:install!)
    end
  end

  describe '#authorize_app!' do
    before(:each) do
      allow_any_instance_of(described_class)
        .to receive(:mac_app_store_trusted_app)
      allow_any_instance_of(described_class).to receive(:app_id)
        .and_return('a.b.c')
    end

    it 'grants Accessibility access to the app' do
      p = provider
      expect(p).to receive(:mac_app_store_trusted_app).with('a.b.c').and_yield
      expect(p).to receive(:action).with(:create)
      p.send(:authorize_app!)
    end
  end

  describe '#app_id' do
    it 'raises an error' do
      expect { provider.send(:app_id) }.to raise_error(NotImplementedError)
    end
  end
end
