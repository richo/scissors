require 'spec_helper'
require 'scissors/rack'

describe Scissors::Rack do

  describe 'when not logged in' do

    describe 'call with HTTP GET' do
      it 'renders a login page'
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
