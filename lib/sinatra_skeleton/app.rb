module SinatraSkeleton
  class App < Sinatra::Application

    get '/' do
      SinatraSkeleton::Config.app_name
    end

    get '/settings/' do
      SinatraSkeleton::Config.to_h.to_json
    end

  end
end
