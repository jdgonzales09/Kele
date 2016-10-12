$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kele'
require 'dotenv'
require 'httparty'
require 'vcr'

Dotenv.load

VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into  :webmock
end
