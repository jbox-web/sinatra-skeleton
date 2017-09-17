module SinatraSkeleton
  module Config

    def self.app_name
      @app_name ||= SinatraSkeleton::Settings.application_name
    end

    def self.to_h
      {
        app_name: app_name,
        version:  SinatraSkeleton::VERSION,
      }
    end

  end
end
