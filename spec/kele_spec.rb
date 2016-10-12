require 'rspec'
require 'spec_helper'
require 'vcr'
require 'typhoeus'

describe Kele, type: :request do
    context '.kele' do

        it 'has a version number' do
            expect(Kele::VERSION).not_to be nil
        end

        describe '#initialize' do
            it 'authenticates user' do
                VCR.use_cassette 'initialize' do    
                    client = Kele.new("jd_gonzales@icloud.com", "Krimson030?!")
                    expect(client.instance_variable_get(:@auth_token)).to be_a String
                end
            end
        end
    end
=begin
    context 'authorized user' do
        before do
            @client = Kele.new("jd_gonzales@icloud.com", "Krimson030?!")
        end
        
        describe '#get_me' do
            it 'it returns an object when called', vcr: {cassette_name: :get_me} do
                expect(@client.get_me).to be_a Object
            end
        end

  end
=end
end
