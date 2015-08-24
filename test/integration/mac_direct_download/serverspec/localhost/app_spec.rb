# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Divvy app' do
  describe file('/Applications/Divvy.app') do
    it 'is present on the filesystem' do
      expect(subject).to be_directory
    end
  end

  describe command(
    'osascript -e \'tell application "System Events" to get the name of the ' \
    'login item "Divvy"\''
  ) do
    it 'indicates Divvy is enabled' do
      expect(subject.stdout.strip).to eq('Divvy')
    end
  end

  # TODO: Using proces('Divvy') requires a fix for Specinfra to not try to use
  # `ps -C` in OS X.
  describe command('ps -A -c -o command | grep Divvy') do
    it 'is running' do
      expect(subject.stdout.strip).to eq('Divvy')
    end
  end
end
