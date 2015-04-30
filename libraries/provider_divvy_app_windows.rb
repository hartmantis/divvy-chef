# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: provider_divvy_app_windows
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

require 'chef/provider/lwrp_base'
require_relative 'provider_divvy_app'

class Chef
  class Provider
    class DivvyApp < Provider::LWRPBase
      # An empty parent class for the Divvy for OS X providers.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < DivvyApp
        URL ||= 'http://mizage.com/downloads/InstallDivvy.exe'

        private

        def install!
          path = download_path
          remote_file path do
            source URL
            action :create
          end
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
