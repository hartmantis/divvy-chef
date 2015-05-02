# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_divvy_app_mac_os_x_direct'

describe Chef::Provider::DivvyApp::MacOsX::Direct do
  let(:name) { 'Some App' }
  let(:new_resource) { Chef::Resource::DivvyApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    before(:each) do
      [:remote_file_resource, :execute_resource, :authorize_app!].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'sets up the remote file resource' do
      expect_any_instance_of(described_class).to receive(:remote_file_resource)
      provider.send(:install!)
    end

    it 'sets up the execute resource' do
      expect_any_instance_of(described_class).to receive(:execute_resource)
      provider.send(:install!)
    end
  end

  describe '#remote_file_resource' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/Divvy.zip')
    end

    it 'downloads the file' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/Divvy.zip').and_yield
      expect(p).to receive(:source)
        .with('http://mizage.com/downloads/Divvy.zip')
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with('/Applications/Divvy.app')
      p.send(:remote_file_resource)
    end
  end

  describe '#execute_resource' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/Divvy.zip')
    end

    it 'sets up an unzipper execute resource' do
      p = provider
      expect(p).to receive(:execute).with('unzip divvy').and_yield
      expect(p).to receive(:command)
        .with('unzip -d /Applications /tmp/Divvy.zip')
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:creates).with('/Applications/Divvy.app')
      p.send(:execute_resource)
    end
  end

  describe '#download_path' do
    it 'returns the correct path' do
      expected = "#{Chef::Config[:file_cache_path]}/Divvy.zip"
      expect(provider.send(:download_path)).to eq(expected)
    end
  end

  describe '#app_id' do
    it 'returns the ID for a direct download install' do
      expect(provider.send(:app_id)).to eq('com.mizage.direct.Divvy')
    end
  end
end
