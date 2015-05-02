# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_windows'

describe Chef::Provider::DivvyApp::Windows do
  let(:name) { 'Some App' }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#start!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:execute)
    end

    it 'starts Divvy via PowerShell' do
      p = provider
      allow(File).to receive(:join).with(described_class::PATH, 'Divvy.exe')
        .and_return('c:/divvy/Divvy.exe')
      expect(p).to receive(:execute).with('run divvy').and_yield
      cmd = 'powershell -c "Start-Process \'c:/divvy/Divvy.exe\'"'
      expect(p).to receive(:command).with(cmd)
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      expect(Mixlib::ShellOut).to receive(:new).with(
        'powershell -c "Get-Process Divvy -ErrorAction SilentlyContinue"'
      ).and_return(double(run_command: double(stdout: 'test')))
      p.send(:start!)
    end
  end

  describe '#install!' do
    before(:each) do
      [:windows_package, :remote_file].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/Divvy.exe')
    end

    it 'downloads the file' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/Divvy.exe').and_yield
      expect(p).to receive(:source)
        .with('http://mizage.com/downloads/InstallDivvy.exe')
      expect(p).to receive(:action).with(:create)
      p.send(:install!)
    end

    it 'runs the installer' do
      p = provider
      expect(p).to receive(:windows_package).with('Divvy').and_yield
      expect(p).to receive(:source).with('/tmp/Divvy.exe')
      expect(p).to receive(:installer_type).with(:nsis)
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#download_path' do
    it 'returns the correct path' do
      expected = "#{Chef::Config[:file_cache_path]}/InstallDivvy.exe"
      expect(provider.send(:download_path)).to eq(expected)
    end
  end
end
