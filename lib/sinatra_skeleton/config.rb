# frozen_string_literal: true

module SinatraSkeleton
  module Config

    def self.app_name
      @app_name ||= SinatraSkeleton::Settings.application_name
    end

    def self.to_h
      {
        app_name:   app_name,
        version:    SinatraSkeleton::VERSION,
        ruby:       "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}",
        hostname:   Socket.gethostname,
        ip_address: Socket.ip_address_list.detect { |intf| intf.ipv4_private? }.ip_address,
        user:       Etc.getlogin,
        env:        ENV.to_h,
      }
    end

  end
end
