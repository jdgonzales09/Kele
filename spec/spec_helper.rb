$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kele'
require 'dotenv'
require 'typhoeus'
require 'vcr'

VCR.configure do |c|
    c.cassette_library_dir = "vcr"
    c.hook_into :typhoeus
    
end
