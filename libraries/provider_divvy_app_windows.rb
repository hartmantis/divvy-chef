# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: provider_divvy_app_windows
#
# Copyright 2015-2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/lwrp_base'
require_relative 'provider_divvy_app'

class Chef
  class Provider
    class DivvyApp < Provider::LWRPBase
      # An empty parent class for the Divvy for OS X providers.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < DivvyApp
        URL ||= 'http://mizage.com/downloads/InstallDivvy.exe'.freeze
        PATH ||= ::File.expand_path('~/AppData/Local/Mizage LLC/Divvy').freeze

        use_inline_resources

        private

        #
        # (see DivvyApp#enable!)
        #
        def enable!
          exe = "\"#{::File.join(PATH, 'Divvy.exe').tr('/', '\\')}\""
          registry_key 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run' do
            values(name: 'WinDivvy', type: :string, data: "#{exe} -background")
            action :create
          end
          registry_key 'HKCU\Software\Mizage LLC\Divvy' do
            values(name: 'auto_start', type: :string, data: 'true')
            recursive true
            action :create
          end
        end

        #
        # (see DivvyApp#start!)
        #
        def start!
          exe = ::File.join(PATH, 'Divvy.exe')
          execute 'run divvy' do
            command "powershell -c \"Start-Process '#{exe}'\""
            action :run
            only_if do
              cmd = 'Get-Process Divvy -ErrorAction SilentlyContinue'
              Mixlib::ShellOut.new("powershell -c \"#{cmd}\"").run_command
                              .stdout.empty?
            end
          end
        end

        #
        # (see DivvyApp#install!)
        #
        def install!
          download_package
          install_package
        end

        #
        # Download the package file from the remote URL.
        #
        def download_package
          path = download_path
          remote_file path do
            source URL
            action :create
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Install the package we just downloaded.
        #
        def install_package
          path = download_path
          windows_package 'Divvy' do
            source path
            installer_type :nsis
            action :install
          end
        end

        #
        # Construct a path to download the app file to.
        #
        # @return [String]
        #
        def download_path
          ::File.join(Chef::Config[:file_cache_path], ::File.basename(URL))
        end
      end
    end
  end
end
