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

  describe '#enable!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:execute)
    end

    it 'runs an execute resource' do
      p = provider
      expect(p).to receive(:execute).with('enable divvy').and_yield
      cmd = 'osascript -e \'tell application "System Events" to make new ' \
            'login item at end with properties {name: "Divvy", ' \
            'path: "/Applications/Divvy.app", hidden: false}\''
      expect(p).to receive(:command).with(cmd)
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      expect(p).to receive(:enabled?)
      p.send(:enable!)
    end
  end

  describe '#enabled?' do
    let(:enabled?) { nil }
    let(:stdout) { enabled? ? 'Divvy' : '' }

    before(:each) do
      cmd = 'osascript -e \'tell application "System Events" to get the ' \
            'name of the login item "Divvy"\''
      allow(Mixlib::ShellOut).to receive(:new).with(cmd)
        .and_return(double(run_command: double(stdout: stdout)))
    end

    context 'Divvy not enabled' do
      let(:enabled?) { false }

      it 'returns false' do
        expect(provider.send(:enabled?)).to eq(false)
      end
    end

    context 'Divvy enabled' do
      let(:enabled?) { true }

      it 'returns true' do
        expect(provider.send(:enabled?)).to eq(true)
      end
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
        .to receive(:privacy_services_manager)
      allow_any_instance_of(described_class).to receive(:app_id)
        .and_return('a.b.c')
    end

    it 'grants Accessibility access to the app' do
      p = provider
      expect(p).to receive(:include_recipe_now).with('privacy_services_manager')
      expect(p).to receive(:privacy_services_manager)
        .with("Grant Accessibility to 'a.b.c'").and_yield
      expect(p).to receive(:service).with('accessibility')
      expect(p).to receive(:applications).with(%w(a.b.c))
      psm = double
      expect(p).to receive(:admin).with(true).and_return(psm)
      expect(psm).to receive(:run_action).with(:add)
      p.send(:authorize_app!)
    end
  end

  describe '#app_id' do
    it 'raises an error' do
      expect { provider.send(:app_id) }.to raise_error(NotImplementedError)
    end
  end
end
