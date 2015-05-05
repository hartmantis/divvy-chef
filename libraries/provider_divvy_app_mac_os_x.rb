# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: provider_divvy_app_mac_os_x
#
# Copyright 2015 Jonathan Hartman
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
require 'chef/dsl/include_recipe'
require 'chef/provider/lwrp_base'
require_relative 'provider_divvy_app'
require_relative 'provider_divvy_app_mac_os_x_app_store'
require_relative 'provider_divvy_app_mac_os_x_direct'

class Chef
  class Provider
    class DivvyApp < Provider::LWRPBase
      # An empty parent class for the Divvy for OS X providers.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < DivvyApp
        # `URL` varies by sub-provider
        PATH ||= '/Applications/Divvy.app'

        private

        #
        # (see DivvyApp#enable!)
        #
        def enable!
          # TODO: This should eventually take the form of applescript and
          # login_item resources in the mac_os_x cookbook.
          cmd = "osascript -e 'tell application \"System Events\" to make " \
                'new login item at end with properties ' \
                "{name: \"Divvy\", path: \"#{PATH}\", hidden: false}'"
          enabled_status = enabled?
          execute 'enable divvy' do
            command cmd
            action :run
            only_if { !enabled_status }
          end
        end

        #
        # Shell out and use AppleScript to check whether the "Divvy" login
        # item already exists.
        #
        # @return [TrueClass, FalseClass]
        #
        def enabled?
          cmd = "osascript -e 'tell application \"System Events\" to get " \
                "the name of the login item \"Divvy\"'"
          !Mixlib::ShellOut.new(cmd).run_command.stdout.empty?
        end

        #
        # (see DivvyApp#start!)
        #
        def start!
          execute 'start divvy' do
            command "open #{PATH}"
            user Etc.getlogin
            action :run
            only_if do
              cmd = 'ps -A -c -o command | grep ^Divvy$'
              Mixlib::ShellOut.new(cmd).run_command.stdout.empty?
            end
          end
        end

        #
        # Authorize the Divvy app.
        #
        # (see DivvyApp#install!)
        #
        def install!
          authorize_app!
        end

        #
        # Declare a trusted_app resource and grant Accessibility to the app.
        #
        def authorize_app!
          ai = app_id
          macosx_accessibility ai do
            items [ai]
            action [:insert, :enable]
          end
        end

        #
        # Return the ID the Accessibility database needs for this provider.
        #
        # @return [String]
        #
        # @raise [NotImplementedError] if not overloaded for this provider
        #
        def app_id
          fail(NotImplementedError,
               "`app_id` method not implemented for #{self.class} provider")
        end
      end
    end
  end
end
