module Scissors::Server::Actions
  class Login


    def initialize(req, server)
      @req = req
      @server = server
    end

    def rack_response
      token = CGI.escape(app.sign(body))
      [302, {"Location" => location}, '']
    end

    private

    attr_reader :req, :server

    def app(name)
      req.params['app'] ? server.apps[req.params['app'].to_sym] : nil
    end

    def location
      "#{app.login_url}?signed_token=#{token}&signed_body=#{body}"
    end

    def body
      @body ||= CGI.escape({"user" => user.serialize_for_app(app), "appdata" => appdata}.to_json)
    end

    def user
      @user ||= server.authenticable_model.find_by_identity(identity)
      if @user.authenticate(password)
        @user
      else
        nil
      end
    end

    def identity
      req.params['identity']
    end

    def appdata
      req.params['appdata']
    end

    def password
      req.params['password']
    end



  end
end

