require "kele/version"
require "HTTParty"


class Kele
    include HTTParty
    base_uri 'https://www.bloc.io/api/v1'

    def initialize(email, password)
        response = self.class.post('/sessions', body: { "email": email, "password": password } )
        @auth_token = response["auth_token"]
    end
    
    
end
