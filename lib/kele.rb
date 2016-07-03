require "kele/version"
require "HTTParty"
require "json"

class Kele
    include HTTParty
    base_uri 'https://www.bloc.io/api/v1'

    def initialize(email, password)
        response = self.class.post('/sessions', body: { "email": email, "password": password } )
        @auth_token = response["auth_token"]
    end
    
    def get_me
        response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
        @user_info = JSON.parse(response.body)
    end

    def get_mentor_availability(id)
        response = self.class.get('/mentors/#{id}/student_availability', headers: { "authorization" => @auth_token})
        @mentor_availability = JSON.parse(response.body)
    end
    
end
