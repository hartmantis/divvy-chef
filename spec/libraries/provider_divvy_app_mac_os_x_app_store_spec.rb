# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_mac_os_x_app_store'

describe Chef::Provider::DivvyApp::MacOsX::AppStore do
  let(:name) { 'Some App' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:authorize_app!)
    end

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
