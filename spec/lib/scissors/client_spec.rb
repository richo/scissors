require 'spec_helper'
require 'scissors/client'

describe Scissors::Client do
  let(:subject) { Scissors::Client.new('app of wonder', 'secret', 'https://auth.example.com')}
  before do
    Time.stub(:now) { Time.at(1350100000) }
  end

  describe 'authentication_url' do
    it 'signs the request id' do
      signature = '25fd609024b5235da4efb5c220e53f4ff186b0ea6df727b9d75612c80d27db3a'
      request = 'https%3A%2F%2Fmyapp.com%2Fauthenticated_page'
      expected_url = "https://auth.example.com?app=app+of+wonder&request=#{request}&signature=#{signature}"
      subject.authentication_url('https://myapp.com/authenticated_page').to_s.should == expected_url
    end
  end

  describe 'extracting signed params' do

    describe 'with a valid signature' do
      it 'returns the signed param' do
        good_signature = subject.sign('plaintext')
        subject.extract_url_param('plaintext', good_signature).should == 'plaintext'
      end
    end

    describe 'with an invalid signature' do
      it 'returns null' do
        subject.extract_url_param('plaintext', 'bad_signature').should == nil
      end
    end

  end
end
