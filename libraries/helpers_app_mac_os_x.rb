# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: helpers_app_mac_os_x
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

module Divvy
  module Helpers
    module App
      # Helper methods for Divvy for OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX
        PATH ||= '/Applications/Divvy.app'.freeze

        class << self
          include Chef::Mixin::ShellOut

          #
          # Check whether Divvy is currently installed.
          #
          # @return [TrueClass, FalseClass] Divvy's installed state
          #
          def installed?
            ::File.exist?(PATH)
          end

          #
          # Check whether Divvy is currently enabled via login item.
          #
          # @return [TrueClass, FalseClass] Divvy's enabled state
          #
          def enabled?
            cmd = "osascript -e 'tell application \"System Events\" to get " \
                  "the name of the login item \"Divvy\"'"
            !shell_out(cmd).stdout.strip.empty?
          end

          #
          # Check whether Divvy is currently running.
          #
          # @return [TrueClass, FalseClass] Divvy's running state
          #
          def running?
            cmd = 'ps -A -c -o command | grep ^Divvy$ || true'
            !shell_out(cmd).stdout.strip.empty?
          end
        end
      end
    end
  end
end
