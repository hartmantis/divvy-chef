# Encoding: UTF-8

require_relative '../spec_helper'

describe 'divvy::default' do
  let(:platform) { nil }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any platform' do
    it 'installs the Divvy app' do
      expect(chef_run).to install_divvy_app('default')
    end

    it 'enables the Divvy app' do
      expect(chef_run).to enable_divvy_app('default')
    end

    it 'starts the Divvy app' do
      expect(chef_run).to start_divvy_app('default')
    end
  end

  context 'Mac OS X platform' do
    let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

    it_behaves_like 'any platform'

    it 'runs the mac-app-store default recipe' do
      expect(chef_run).to include_recipe('mac-app-store')
    end
  end

  context 'Windows 2012 platform' do
    let(:platform) { { platform: 'windows', version: '2012R2' } }

    it_behaves_like 'any platform'

    it 'does not run the mac-app-store recipe' do
      expect(chef_run).not_to include_recipe('mac-app-store')
    end
  end
end
