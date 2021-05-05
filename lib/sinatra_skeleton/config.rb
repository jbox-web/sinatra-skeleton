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
        redis:      redis_check,
        postgres:   postgres_check,
        mysql:      mysql_check,
        env:        ENV.to_h,
      }
    end

    def self.postgres_check
      conn = PG.connect(host: ENV['POSTGRES_DB_HOST'], port: ENV['POSTGRES_DB_PORT'], user: ENV['POSTGRES_DB_USER'], password: ENV['POSTGRES_DB_PASS'], dbname: ENV['POSTGRES_DB_NAME'])
      conn.exec( "SELECT * FROM pg_stat_activity" ).to_a.select { |r| r['usename'] == ENV['POSTGRES_DB_USER'] }
    rescue => e
      e.message
    end

    def self.mysql_check
      conn = Mysql2::Client.new(host: ENV['MYSQL_DB_HOST'], port: ENV['MYSQL_DB_PORT'], username: ENV['MYSQL_DB_USER'], password: ENV['MYSQL_DB_PASS'], database: ENV['MYSQL_DB_NAME'])
      conn.query('SELECT * from mysql.user').to_a.select { |r| r['User'] == ENV['MYSQL_DB_USER'] }
    rescue => e
      e.message
    end

    def self.redis_check
      conn = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
      conn.incr('hits')
    rescue => e
      e.message
    end
  end
end
