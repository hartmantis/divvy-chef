require_relative '../../../spec_helper'
require_relative '../../../../libraries/helpers_app_windows'

describe 'resource_divvy_app::windows::10' do
  let(:name) { 'default' }
  let(:action) { nil }
  let(:running?) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'divvy_app', platform: 'windows', version: '10'
    ) do |node|
      %i(name action).each do |p|
        node.set['resource_divvy_app_test'][p] = send(p) unless send(p).nil?
      end
    end
  end
  let(:converge) { runner.converge('resource_divvy_app_test') }

  before(:each) do
    allow(Kernel).to receive(:load).and_call_original
    allow(Kernel).to receive(:load)
      .with(%r{divvy/libraries/helpers_app_windows\.rb}).and_return(true)
    allow(Divvy::Helpers::App::Windows).to receive(:running?)
      .and_return(running?)
  end

  context 'the :install action' do
    let(:action) { :install }
    cached(:chef_run) { converge }

    it 'installs Divvy' do
      expect(chef_run).to install_windows_package('Divvy').with(
        source: 'http://mizage.com/downloads/InstallDivvy.exe',
        installer_type: :nsis
      )
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }
    cached(:chef_run) { converge }

    it 'creates the autorun registry key' do
      expect(chef_run).to create_registry_key(
        'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run'
      ).with(
        values: [{
          name: 'WinDivvy',
          type: :string,
          data: "\"#{File.expand_path('~/AppData/Local/Mizage LLC/Divvy')}" \
                '/Divvy.exe" -background'.tr('/', '\\')
        }]
      )
    end

    it 'creates the Divvy registry key' do
      expect(chef_run).to create_registry_key('HKCU\Software\Mizage LLC\Divvy')
        .with(values: [{ name: 'auto_start', type: :string, data: 'true' }],
              recursive: true)
    end
  end

  context 'the :start action' do
    let(:action) { :start }

    context 'not running' do
      let(:running?) { false }
      cached(:chef_run) { converge }

      it 'starts Divvy' do
        expect(chef_run).to run_execute('Start Divvy').with(
          command: "powershell -c \"Start-Process '" \
                   "#{File.expand_path('~/AppData/Local/Mizage LLC/Divvy')}/" \
                   "Divvy.exe'\""
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
