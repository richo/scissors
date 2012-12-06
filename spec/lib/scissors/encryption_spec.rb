require 'spec_helper'
require 'scissors/encryption'
require 'ostruct'

describe Scissors::Encryption do

  before do
    # Setup an app name and secret key
    @subject = OpenStruct.new :app => 'App name', :key => 'Secret Key'
    @subject.extend(Scissors::Encryption)
    @my_data = 'my data'

    @expected_early_signature = '02daeb8ec2b228286451176fce03c9dce7c74b8f12e33e308985e2ae061db819'
    @expected_later_signature = '2b2bac6e7d831b69f4efe3bb98b3cf24e2cc437630ab65fd24d149d118920881'
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
