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
        postgres:   postgres_check,
        env:        ENV.to_h,
      }
    end

    def self.postgres_check
      conn = PG.connect(host: ENV['POSTGRES_DB_HOST'], port: ENV['POSTGRES_DB_PORT'], user: ENV['POSTGRES_DB_USER'], password: ENV['POSTGRES_DB_PASS'], dbname: ENV['POSTGRES_DB_NAME'])
      conn.exec( "SELECT * FROM pg_stat_activity" ).to_a.select { |r| r['usename'] == ENV['POSTGRES_DB_USER'] }
    end
  end
end
