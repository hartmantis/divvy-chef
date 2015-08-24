# Encoding: UTF-8

require_relative '../../spec_helper'

class Chef
  class Provider
    # A fake privacy_services_manager provider
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PrivacyServicesManager < Provider::LWRPBase
    end
  end
end
