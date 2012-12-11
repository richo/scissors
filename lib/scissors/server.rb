# Rack application which provides autuhentication

require 'sinatra/base'

Scissors::App = Struct.new(:name, :key, :login_url, :logoff_url)

class Scissors::Server < Sinatra::Base
  attr_accessor :authenticable_model, :prefix

  def initialize
    super
    yield self
  end

  def authenticates_for(app_name, opts)
    apps << Scissors::App.new(app_name, opts[:shared_key], opts[:login_url], opts[:logoff_url])
  end

  get '/' do
    haml :login
  end

end
