# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: provider_divvy_app_mac_os_x_direct
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
require_relative 'provider_divvy_app_mac_os_x'

class Chef
  class Provider
    class DivvyApp < Provider::LWRPBase
      class MacOsX < DivvyApp
        # A Chef provider for OS X installs via direct download.
        #
        # @author Jonathan Hartman <j@p4nt5.com>
        class Direct < MacOsX
          URL ||= 'http://mizage.com/downloads/Divvy.zip'.freeze

          use_inline_resources

          private

          #
          # (see DivvyApp#install!)
          #
          def install!
            download_package
            install_package
            super
          end

          #
          # Declare a remote_file resource for downloading the file.
          #
          def download_package
            remote_file download_path do
              source URL
              action :create
              only_if { !::File.exist?(PATH) }
            end
          end

          #
          # Declare an execute resource for extracting the downloaded file.
          #
          def install_package
            path = download_path
            execute 'unzip divvy' do
              command "unzip -d /Applications #{path}"
              action :run
              creates PATH
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
end
