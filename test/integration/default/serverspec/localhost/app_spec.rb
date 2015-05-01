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
end
