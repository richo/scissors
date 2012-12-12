require 'spec_helper'
require 'scissors/server'
require 'rack/test'

describe Scissors::Server do
  include Rack::Test::Methods

  def app
    @subject ||= Scissors::Server.new do |app|
      app.authenticable_model = TestAuthenticableUser
      app.authenticates_for(
        :myapp,
        :shared_key => 'secret',
        :login_url => 'https://myapp.net/login',
        :logoff_url => 'https://myapp.net/logoff'
      )
    end
  end

  describe 'when not logged in' do

    describe 'call with HTTP GET' do
      it 'renders a 404' do
        get '/'
        last_response.status.should == 404
      end
    end

    describe 'call with HTTP POST' do
      describe 'with valid login details' do
        it 'redirects to the calling app' do
          post '/',
            :identity => TestAuthenticableUser::VALID_USER,
            :password => TestAuthenticableUser::VALID_PASSWORD,
            :app => 'myapp',
            :appdata => 'foobar'
          last_response.should be_redirect
          base_url = "https://myapp.net/login"

          expected_body = {
            "user" => {"ident" => "Jonoleth Irenicus" , "random_other" => "property"},
            "appdata" => "foobar"
          }.to_json

          signed_token = "signed_token=%93%CA%07%83fe%14%92C%F9%E9%A7%F3d%040n%98-tT%18%FA%A5%A1%B1%DF%AA%F8K%8E%C9"
          signed_body = "signed_body=#{CGI.escape expected_body}"
          last_response['location'].should == "#{base_url}?#{signed_token}&#{signed_body}"
        end
      end

      describe 'with invalid login details' do
        it 'redirects back to the login form'
      end
    end

    describe 'call with HTTP DELETE' do
      describe 'with a userid provided' do
        it 'redirects back to the login form'
      end
      describe 'with no userid provided' do
        it 'redirects back to the login form'
      end
    end

  end

  describe 'when logged in' do

    describe 'call with HTTP GET' do
      it 'logs you in to the calling app'
    end

    describe 'call with HTTP POST' do
      describe 'with valid login details' do
        it 'redirects to the calling app'
      end
      describe 'with invalid login details' do
        it 'redirects back to the login form'
      end
    end

    describe 'call with HTTP DELETE' do
      describe 'with no userid provided' do
        it 'logs you out'
      end

      describe 'specifying another userid' do
        describe 'when you #can_terminate_sessions?' do
          it "DELETE's to each applications logoff_url"
          it 'redirects you back to the application you came from'
        end
        describe 'when you cannot #can_terminate_sessions?' do
          it 'returns 403 NOT AUTHORIZED'
        end
      end

    end

  end

end
