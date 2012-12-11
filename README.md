# sciSSOrs
SSO for apps that trust each other

Pre-alpha.

![Build Status](https://travis-ci.org/DanielHeath/scissors.png)

Code samples
```ruby
# Accessing a protected page in the main app:
unless session[:user]
  client = Scissors::Client.new(:app_name, 'secret_key', 'https://auth.myapp.net/prefix')
  redirect_to client.authentication_url( :arbitrary_data => request.url ) # Keep it small enough to fit in a URL.
end

# Handler for the login url in the main app (the login url clients are redirected to by the authentication provider app)
client = Scissors::Client.new(:app_name, 'secret_key', 'https://auth.myapp.net/prefix')
signed_token = client.extract_url_param(params[:signed_token])
session[:user] = signed_token['user']
redirect_to signed_token['appdata'][:arbitrary_data]

# The authentication app code
app = Scissors::Server.new do |app|  # Mount this rack app under a prefix

  # Specify the model object to run authentication against.
  # authenticable_model must implement the following:
  # Static methods
  # #find_by_identity(identity)
  #
  # Instance methods
  # #identity
  # #authenticate(password)
  # #allowed_to_use?(app)
  # #serialize_for_app(app)
  # #can_terminate_sessions? # If you wish to allow one user to terminate another users session (banning misbehaving users, etc)
  app.authenticable_model = User

  app.authenticates_for(:myapp, :shared_key => 'secret', :login_url => 'https://myapp.net/login?signed_token=%s', :logoff_url => 'https://myapp.net/logoff?signed_token=%s')
end

map '/shared_auth/session' do
  app = Scissors::Server.new do |app|
    app.prefix 'prefix'
  end
  run app
end


# App is a rack middleware, mounted at a given prefix.
# It exposes the following routes:
# GET :prefix/ - shows a login form (redirects you iff you are already logged in)
# POST :prefix/ - log in
# DELETE :prefix/ - log out
# DELETE :prefix/:identity - log another user out, iff the current user can_terminate_sessions?
```

# Authors

Code by [Daniel Heath](https://github.com/danielheath/)

Protocol by [Clifford Heath](https://github.com/cjheath/)
