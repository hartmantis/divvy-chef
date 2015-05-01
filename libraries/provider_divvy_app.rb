# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: provider_divvy_app
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
require_relative 'resource_divvy_app'
require_relative 'provider_divvy_app_mac_os_x'
require_relative 'provider_divvy_app_windows'

class Chef
  class Provider
    # A Chef provider for the Divvy app.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DivvyApp < Provider::LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider.
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Install the app if it's not already.
      #
      action :install do
        install!
        new_resource.installed(true)
        Chef::Log.info(
          'If you have a Divvy license, don\'t forget to enter it in the app!'
        )
      end

      private

      #
      # Do the actual app installation.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def install!
        fail(NotImplementedError,
             "`install!` method not implemented for #{self.class} provider")
      end
    end
  end
end
