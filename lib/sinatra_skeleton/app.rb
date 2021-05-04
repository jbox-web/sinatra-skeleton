# frozen_string_literal: true

module SinatraSkeleton
  class App < Sinatra::Application

    get '/' do
      SinatraSkeleton::Config.app_name
    end

    get '/settings/' do
      content_type :json
      SinatraSkeleton::Config.to_h.to_json
    end

  end
end
