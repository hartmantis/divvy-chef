# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: resource_divvy_app_mac_os_x
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

require 'etc'
require 'chef/mixin/shell_out'
require_relative 'resource_divvy_app'

class Chef
  class Resource
    # A Chef resource for Divvy for OS X.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DivvyAppMacOsX < DivvyApp
      include Chef::Mixin::ShellOut

      PATH ||= '/Applications/Divvy.app'.freeze

      provides :divvy_app, platform_family: 'mac_os_x'

      property :source,
               Symbol,
               coerce: proc { |v| v.to_sym },
               equal_to: %i(app_store direct),
               default: :app_store

      property :system_user, String, default: Etc.getlogin

      %i(installed enabled running).each do |p|
        property p, [TrueClass, FalseClass]
      end

      load_current_value do
        installed(::File.exist?(PATH))
        cmd = "osascript -e 'tell application \"System Events\" to get " \
              "the name of the login item \"Divvy\"'"
        enabled(!shell_out(cmd).stdout.strip.empty?)
        cmd = 'ps -A -c -o command | grep ^Divvy$ || true'
        running(!shell_out(cmd).stdout.strip.empty?)
      end

      action :install do
        new_resource.installed(true)

        case new_resource.source
        when :app_store
          include_recipe 'mac-app-store'
          mac_app_store_app 'Divvy - Window Manager'
        when :direct
          converge_if_changed :installed do
            local_path = ::File.join(Chef::Config[:file_cache_path],
                                     'Divvy.zip')
            remote_file local_path do
              source 'http://mizage.com/downloads/Divvy.zip'
            end
            execute 'Unzip Divvy' do
              command "unzip -d /Applications #{local_path}"
            end
          end
        end

        include_recipe 'privacy_services_manager'
        privacy_services_manager 'Grant Accessibility to Divvy' do
          service 'accessibility'
          applications [PATH]
        end
      end

      action :enable do
        new_resource.enabled(true)

        converge_if_changed :enabled do
          execute 'Enable Divvy' do
            command "osascript -e 'tell application \"System Events\" to " \
                    'make new login item at end with properties ' \
                    "{name: \"Divvy\", path: \"#{PATH}\", hidden: false}'"
          end
        end
      end

      action :start do
        new_resource.running(true)

        converge_if_changed :running do
          execute 'Start Divvy' do
            command "open #{PATH}"
            user new_resource.system_user
          end
        end
      end
    end
  end
end
