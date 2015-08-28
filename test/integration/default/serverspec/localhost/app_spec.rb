# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Divvy app' do
  describe package('com.mizage.Divvy'), if: os[:family] == 'darwin' do
    it 'is installed' do
      expect(subject).to be_installed.by(:pkgutil)
    end
  end

  describe file('/Applications/Divvy.app'), if: os[:family] == 'darwin' do
    it 'is present on the filesystem' do
      expect(subject).to be_directory
    end
  end

  describe package('Divvy'), if: os[:family] == 'windows' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe file(File.expand_path('~/AppData/Local/Mizage LLC/Divvy')),
           if: os[:family] == 'windows' do
    it 'is present on the filesystem' do
      expect(subject).to be_directory
    end
  end

  describe command(
    'osascript -e \'tell application "System Events" to get the name of the ' \
    'login item "Divvy"\''
  ), if: os[:family] == 'darwin' do
    it 'indicates Divvy is enabled' do
      expect(subject.stdout.strip).to eq('Divvy')
    end
  end

  describe command(
    'Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"'
  ), if: os[:family] == 'windows' do
    it 'indicates Divvy is enabled' do
      expect(subject.stdout).to match(/^WinDivvy +:/)
    end
  end

  describe process('Divvy'), if: os[:family] == 'darwin' do
    it 'is running' do
      expect(subject).to be_running
    end
  end

  # TODO: The process('Divvy') call should work in Windows too, but Specinfra
  # throws a NotImplementedError.
  describe command('Get-Process Divvy'), if: os[:family] == 'windows' do
    it 'indicates Divvy is running' do
      expect(subject.exit_status).to eq(0)
    end
  end
end
