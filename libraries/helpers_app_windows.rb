# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: helpers_app_windows
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
      # Helper methods for the Divvy app for Windows.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows
        class << self
          include Chef::Mixin::ShellOut

          def running?
            cmd = 'powershell -c "Get-Process Divvy ' \
                  '-ErrorAction SilentlyContinue"'
            !shell_out(cmd).stdout.strip.empty?
          end
        end
      end
    end
  end
end
