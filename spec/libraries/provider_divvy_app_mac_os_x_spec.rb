# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_mac_os_x'

describe Chef::Provider::DivvyApp::MacOsX do
  let(:name) { 'Some App' }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    it 'raises an error' do
      expect { provider.send(:install!) }.to raise_error(NotImplementedError)
    end
  end
end
