require 'logger'
require 'sinatra/base'
require_relative './cable'
require_relative './chat_channel'

ROOT = Pathname.new(__FILE__).dirname

class App < Sinatra::Base

    configure do
        set :sprockets, ::Sprockets::Environment.new
        sprockets.cache = Sprockets::Cache::FileStore.new(ROOT.join('tmp','cache'))
        sprockets.append_path(ROOT.join('assets'))
        config = ActionCable::Server::Configuration.new
        config.logger = Logger.new(STDOUT)
        config.cable = {
            'adapter' => 'async' # Would be 'postgres' or 'redis' in a "real" app
        }
        config.connection_class = -> { ApplicationCable::Connection }
        config.allowed_request_origins = "http://localhost:9292"
        ActionCable::Server::Base.config = config
    end

    get "/" do
        erb :index
    end

    get '/ws' do
        ActionCable.server.call(env)
    end

    get "/asset/*" do |path|
        env_sprockets = request.env.dup
        env_sprockets['PATH_INFO'] = path
        settings.sprockets.call env_sprockets
    end
end
