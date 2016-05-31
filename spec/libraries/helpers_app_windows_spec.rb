require_relative '../spec_helper'
require_relative '../../libraries/helpers_app_windows'

describe Divvy::Helpers::App::Windows do
  describe '.running?' do
    let(:running) { nil }

    before(:each) do
      allow(described_class).to receive(:shell_out).with(
        'powershell -c "Get-Process Divvy -ErrorAction SilentlyContinue"'
      ).and_return(double(stdout: running ? "stuff\n" : "\n"))
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
