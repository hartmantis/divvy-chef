require_relative '../../../spec_helper'
require_relative '../../../../libraries/helpers_app_mac_os_x'

describe 'resource_divvy_app::mac_os_x::10_10' do
  let(:name) { 'default' }
  %i(source action).each { |i| let(i) { nil } }
  %i(installed? enabled? running?).each { |i| let(i) { nil } }
  let(:getlogin) { 'vagrant' }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'divvy_app', platform: 'mac_os_x', version: '10.10'
    ) do |node|
      %i(name source action).each do |p|
        node.set['resource_divvy_app_test'][p] = send(p) unless send(p).nil?
      end
    end
  end
  let(:converge) { runner.converge('resource_divvy_app_test') }

  before(:each) do
    allow(Kernel).to receive(:load).and_call_original
    allow(Kernel).to receive(:load)
      .with(%r{divvy/libraries/helpers_app_mac_os_x\.rb}).and_return(true)
    allow(Etc).to receive(:getlogin).and_return(getlogin)
    %i(installed? enabled? running?).each do |m|
      allow(Divvy::Helpers::App::MacOsX).to receive(m).and_return(send(m))
    end
  end

  context 'the :install action' do
    let(:action) { :install }

    shared_examples_for 'any install method' do
      it 'configures privacy_services_manager' do
        expect(chef_run).to include_recipe('privacy_services_manager')
      end

      it 'grants accessibility to Divvy' do
        expect(chef_run).to add_privacy_services_manager(
          'Grant Accessibility to Divvy'
        ).with(service: 'accessibility',
               applications: %w(/Applications/Divvy.app))
      end
    end

    context 'the default install method (:app_store)' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any install method'

      it 'includes the mac-app-store recipe' do
        expect(chef_run).to include_recipe('mac-app-store')
      end

      it 'installs the Divvy app' do
        expect(chef_run).to install_mac_app_store_app('Divvy - Window Manager')
      end
    end

    context 'the :direct install method' do
      let(:source) { :direct }

      context 'not installed' do
        let(:installed?) { false }
        cached(:chef_run) { converge }

        it_behaves_like 'any install method'

        it 'downloads the Divvy .zip file' do
          expect(chef_run).to create_remote_file(
            "#{Chef::Config[:file_cache_path]}/Divvy.zip"
          ).with(source: 'http://mizage.com/downloads/Divvy.zip')
        end

        it 'extracts the Divvy .zip file' do
          expect(chef_run).to run_execute('Unzip Divvy').with(
            command: 'unzip -d /Applications ' \
                     "#{Chef::Config[:file_cache_path]}/Divvy.zip"
          )
        end
      end

      context 'already installed' do
        let(:installed?) { true }
        cached(:chef_run) { converge }

        it_behaves_like 'any install method'

        it 'does not download the Divvy .zip file' do
          expect(chef_run).to_not create_remote_file(
            "#{Chef::Config[:file_cache_path]}/Divvy.zip"
          )
        end

        it 'does not extract the Divvy .zip file' do
          expect(chef_run).to_not run_execute('Unzip Divvy')
        end
      end
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }

    context 'not enabled' do
      let(:enabled?) { false }
      cached(:chef_run) { converge }

      it 'enables Divvy' do
        expect(chef_run).to run_execute('Enable Divvy').with(
          command: "osascript -e 'tell application \"System Events\" to make " \
                   'new login item at end with properties {name: "Divvy", ' \
                   "path: \"/Applications/Divvy.app\", hidden: false}'"
        )
      end
    end

    context 'already enabled' do
      let(:enabled?) { true }
      cached(:chef_run) { converge }

      it 'does not enable Divvy' do
        expect(chef_run).to_not run_execute('Enable Divvy')
      end
    end
  end

  context 'the :start action' do
    let(:action) { :start }

    context 'not running' do
      let(:running?) { false }
      cached(:chef_run) { converge }

      it 'starts Divvy' do
        expect(chef_run).to run_execute('Start Divvy').with(
          command: 'open /Applications/Divvy.app',
          user: getlogin
        )
      end
    end

    context 'already running' do
      let(:running?) { true }
      cached(:chef_run) { converge }

      it 'does not start Divvy' do
        expect(chef_run).to_not run_execute('Start Divvy')
      end
    end
  end
end
