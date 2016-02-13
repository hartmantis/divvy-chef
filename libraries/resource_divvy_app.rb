# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: divvy_app
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A Chef resource for the Divvy app.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DivvyApp < Resource::LWRPBase
      self.resource_name = :divvy_app
      actions :install, :enable, :start
      default_action [:install, :enable, :start]

      #
      # Attribute for the app's installed status.
      #
      attribute :installed,
                kind_of: [NilClass, TrueClass, FalseClass],
                default: nil
      alias installed? installed

      #
      # Attribute for the app's enabled status.
      #
      attribute :enabled,
                kind_of: [NilClass, TrueClass, FalseClass],
                default: nil
      alias enabled? enabled

      #
      # Attribute for the app's running status.
      #
      attribute :running,
                kind_of: [NilClass, TrueClass, FalseClass],
                default: nil
      alias running? running
    end
  end
end
