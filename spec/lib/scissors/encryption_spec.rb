require 'spec_helper'
require 'scissors/encryption'

describe Scissors::Encryption do

  before do
    # Setup an app name and secret key
    @subject = OpenStruct.new :app => 'App name', :key => 'Secret Key'
    @subject.extend(Scissors::Encryption)
    @my_data = 'my data'

    @expected_early_signature = "\xCBo8\x80\xE1e\xA0\xF4?\xDC\x1E@\xD50\xA9(2\xD5F\xAD\xC7J\x06\xED\xA09\xD0\x8F\xDD$m\xA2"
    @expected_later_signature = "4Ai\x89\x95\xEB~\x84\x16\x7F\x9E\x92\x8Bm\x89M8\xBD8\xFD\xF5\xCB\x05Q~;`C\xFF\xD1\x81#"
  end

  describe 'signing arbitrary data' do

    describe 'earlier' do
      before do
        Time.stub(:now) { Time.at(1350100000) }
      end

      it 'finds the nearest block of 5 minutes' do
        @subject.nearest_time_block.to_i.should == 1350000000
      end

      it 'generates a signature' do
        @subject.sign(@my_data).should == @expected_early_signature
      end

      it 'verifies the later signature' do
        @subject.valid?(@my_data, @expected_later_signature).should == true
      end

      it 'verifies the earlier signature' do
        @subject.valid?(@my_data, @expected_early_signature).should == true
      end
    end

    describe 'later' do
      before do
        Time.stub(:now) { Time.at(1350200000) }
      end

      it 'finds the nearest block of 5 minutes' do
        @subject.nearest_time_block.to_i.should == 1350300000
      end

      it 'generates a different signature' do
        @subject.sign(@my_data).should == @expected_later_signature
      end

      it 'verifies the later signature' do
        @subject.valid?(@my_data, @expected_later_signature).should == true
      end

      it 'verifies the earlier signature' do
        @subject.valid?(@my_data, @expected_early_signature).should == true
      end
    end


  end
end
