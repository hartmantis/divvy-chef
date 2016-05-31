require_relative '../spec_helper'
require_relative '../../libraries/helpers_app_mac_os_x'

describe Divvy::Helpers::App::MacOsX do
  describe '::PATH' do
    it 'returns the expected path' do
      expect(described_class::PATH).to eq('/Applications/Divvy.app')
    end
  end

  describe '.installed?' do
    let(:installed) { nil }

    before(:each) do
      allow(File).to receive(:exist?).with('/Applications/Divvy.app')
        .and_return(installed)
    end

    context 'installed' do
      let(:installed) { true }

      it 'returns true' do
        expect(described_class.installed?).to eq(true)
      end
    end

    context 'not installed' do
      let(:installed) { false }

      it 'returns false' do
        expect(described_class.installed?).to eq(false)
      end
    end
  end

  describe '.enabled?' do
    let(:enabled) { nil }

    before(:each) do
      allow(described_class).to receive(:shell_out)
        .with("osascript -e 'tell application \"System Events\" to get the " \
              "name of the login item \"Divvy\"'")
        .and_return(double(stdout: enabled ? "stuff\n" : "\n"))
    end

    context 'enabled' do
      let(:enabled) { true }

      it 'returns true' do
        expect(described_class.enabled?).to eq(true)
      end
    end

    context 'not enabled' do
      let(:enabled) { false }

      it 'returns false' do
        expect(described_class.enabled?).to eq(false)
      end
    end
  end

  describe '.running?' do
    let(:running) { nil }

    before(:each) do
      allow(described_class).to receive(:shell_out)
        .with('ps -A -c -o command | grep ^Divvy$ || true')
        .and_return(double(stdout: running ? "stuff\n" : "\n"))
    end

    context 'running' do
      let(:running) { true }

      it 'returns true' do
        expect(described_class.running?).to eq(true)
      end
    end

    context 'not running' do
      let(:running) { false }

      it 'returns false' do
        expect(described_class.running?).to eq(false)
      end
    end
  end
end
