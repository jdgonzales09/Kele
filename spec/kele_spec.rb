require 'spec_helper'
require 'httparty'
require 'vcr'

describe Kele, type: :request do
    include HTTParty
    context '.kele' do

        it 'has a version number' do
            expect(Kele::VERSION).not_to be nil
        end

        describe '#initialize' do
            it "authenticates user" do
                VCR.use_cassette('initialize') do
                    client = Kele.new(ENV['EMAIL'], ENV['PASSWORD'])
                    expect(client.instance_variable_get(:@auth_token)).to be_a String
                end
            end
        end
    end
    context 'authorized user' do
        before do
            @client = Kele.new(ENV['EMAIL'], ENV['PASSWORD'])
        end

        describe '#get_me' do
            it "it returns an object when called", vcr: {cassette_name: :get_me} do
                expect(@client.get_me).to be_a Object
            end
        end

        describe '#get_mentor_availability' do
            it "returns an object when called" do
                expect(@client.get_mentor_availability(2290632)).to be_a Object
            end
        end

        describe '#get_messages' do
            it "returns an object when called" do
                expect(@client.get_messages).to be_a Object
            end
        end

        describe '#create_message' do
            it "returns http 200" do
                expect(@client.get_messages(2342389, 2290632, test, testing)).to have_http_status(200)
            end
        end

        describe '#create_submission' do
            it "returns http 200" do
                expect(@client.create_submission(14098, 99, 99, "http://bloc.io").to have_http_status(200))
            end
        end
  end
end
