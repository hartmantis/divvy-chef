# Encoding: UTF-8

require_relative '../../spec_helper'

class Chef
  class Resource
    # A fake privacy_services_manager resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivacyServicesManager < Resource::LWRPBase
      self.resource_name = :privacy_services_manager
      actions :add, :remove
      default_action :add
      attribute :service, kind_of: String
      attribute :applications, kind_of: Array
      attribute :admin, kind_of: [TrueClass, FalseClass]
    end
  end
end
