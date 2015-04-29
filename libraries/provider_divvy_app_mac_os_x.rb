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

require 'chef/provider/lwrp_base'
require_relative 'provider_divvy_app'
require_relative 'provider_divvy_app_mac_os_x_app_store'

class Chef
  class Provider
    class DivvyApp < Provider::LWRPBase
      # An empty parent class for the Divvy for OS X providers.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < DivvyApp
      end
    end
  end
end
