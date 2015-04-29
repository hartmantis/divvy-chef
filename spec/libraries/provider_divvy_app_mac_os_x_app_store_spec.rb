# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_mac_os_x_app_store'

describe Chef::Provider::DivvyApp::MacOsX::AppStore do
  let(:name) { 'Some App' }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    it 'installs the app from the App Store' do
      p = provider
      expect(p).to receive(:mac_app_store_app).with('Divvy - Window Manager')
        .and_yield
      expect(p).to receive(:bundle_id).with('com.mizage.divvy')
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end
end
