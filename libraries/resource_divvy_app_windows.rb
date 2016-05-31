# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: resource_divvy_app_windows
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

require 'chef/mixin/shell_out'
require_relative 'helpers_app_windows'
require_relative 'resource_divvy_app'

class Chef
  class Resource
    # A Chef resource for the Divvy app for Windows.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DivvyAppWindows < DivvyApp
      include Chef::Mixin::ShellOut

      URL ||= 'http://mizage.com/downloads/InstallDivvy.exe'.freeze
      PATH ||= ::File.expand_path('~/AppData/Local/Mizage LLC/Divvy').freeze

      provides :divvy_app, platform_family: 'windows'

      property :running, [TrueClass, FalseClass]

      load_current_value do
        running(Divvy::Helpers::App::Windows.running?)
      end

      action :install do
        windows_package 'Divvy' do
          source URL
          installer_type :nsis
        end
      end

      action :enable do
        exe = "\"#{::File.join(PATH, 'Divvy.exe').tr('/', '\\')}\""
        registry_key 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run' do
          values(name: 'WinDivvy', type: :string, data: "#{exe} -background")
        end
        registry_key 'HKCU\Software\Mizage LLC\Divvy' do
          values(name: 'auto_start', type: :string, data: 'true')
          recursive true
        end
      end

      action :start do
        new_resource.running(true)

        converge_if_changed :running do
          exe = ::File.join(PATH, 'Divvy.exe')
          execute 'Start Divvy' do
            command "powershell -c \"Start-Process '#{exe}'\""
          end
        end
      end
    end
  end
end
