# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_mac_os_x'

describe Chef::Provider::DivvyApp::MacOsX do
  let(:name) { 'Some App' }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#start!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:execute)
    end

    it 'starts up Divvy for OS X' do
      p = provider
      expect(p).to receive(:execute).with('start divvy').and_yield
      expect(p).to receive(:command).with('open /Applications/Divvy.app')
      expect(p).to receive(:user).with(Etc.getlogin)
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      cmd = 'ps -A -c -o command | grep ^Divvy$'
      expect(Mixlib::ShellOut).to receive(:new).with(cmd)
        .and_return(double(run_command: double(stdout: 'test')))
      p.send(:start!)
    end
  end

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
        .to receive(:macosx_accessibility)
      allow_any_instance_of(described_class).to receive(:app_id)
        .and_return('a.b.c')
    end

    it 'grants Accessibility access to the app' do
      p = provider
      expect(p).to receive(:macosx_accessibility).with('a.b.c').and_yield
      expect(p).to receive(:items).with(%w(a.b.c))
      expect(p).to receive(:action).with([:insert, :enable])
      p.send(:authorize_app!)
    end
  end

  describe '#app_id' do
    it 'raises an error' do
      expect { provider.send(:app_id) }.to raise_error(NotImplementedError)
    end
  end
end
