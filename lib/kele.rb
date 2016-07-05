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

    def get_mentor_availability(mentor_id)
        response = self.class.get('/mentors/' + mentor_id.to_s + '/student_availability', headers: { "authorization" => @auth_token})
        @mentor_availability = JSON.parse(response.body)
    end

    def get_roadmap(roadmap_id)
        response = self.class.get('/roadmaps/' + roadmap_id.to_s, headers: { "authorization" => @auth_token})
        @roadmap = JSON.parse(response.body)
    end

    def get_checkpoint(checkpoint_id)
        response = self.class.get('/checkpoints/' + checkpoint_id.to_s, headers: { "authorization" => @auth_token})
        @checkpoint = JSON.parse(response.body)
    end
    
end
