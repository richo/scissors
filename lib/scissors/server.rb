require 'lib/scissors/encryption'
require 'rack'

Scissors::App = Struct.new(:name, :key, :login_url, :logoff_url) do
  include Scissors::Encryption
  alias :app :name
end

# Rack application which provides authentication
class Scissors::Server
  attr_accessor :authenticable_model, :prefix
  attr_reader :apps

  def initialize
    @apps = {}
    yield self
  end

  def authenticates_for(app_name, opts)
    apps[app_name] = Scissors::App.new(app_name, opts[:shared_key], opts[:login_url], opts[:logoff_url])
  end

  def call(req)
    req = Rack::Request.new(req)
    if req.get?
      get(req)
    else
      post(req)
    end
  end

  private

  def get(req)
    [404, {}, '']
  end

  def post(req)
    login = Scissors::Server::Actions::Login.new(req)
    login.rack_response
  end

end

require 'lib/scissors/server/actions'