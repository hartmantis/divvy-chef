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
      pending 'SpecInfra ability to search HKCU registry keys'
      expect(subject).to be_installed
    end
  end

  # TODO: This test can go away when the one above is no longer pending
  describe command("(Get-ItemProperty 'HKCU:\\Software\\Microsoft\\Windows\\" \
                   "CurrentVersion\\Uninstall\\Divvy')") do
    it 'indicates Divvy is installed' do
      expect(subject.stdout).to match(/DisplayName +: +Divvy/)
    end
  end

  describe file(File.expand_path('~/AppData/Local/Mizage LLC/Divvy')),
           if: os[:family] == 'windows' do
    it 'is present on the filesystem' do
      expect(subject).to be_directory
    end
  end
end
