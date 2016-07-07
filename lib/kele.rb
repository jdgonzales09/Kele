require "kele/version"
require "HTTParty"
require "json"
require "pry"
require "roadmap"

class Kele

    include Roadmap
    include HTTParty
    base_uri 'https://www.bloc.io/api/v1'

    def initialize(email, password)
        response = self.class.post("/sessions", body: { "email": email, "password": password } )
        @auth_token = response["auth_token"]
    end

    def get_me
        response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
        @user_info = JSON.parse(response.body)
    end

    def get_mentor_availability(mentor_id)
        response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token})
        @mentor_availability = JSON.parse(response.body)
    end

    def get_messages(page = nil)
      if page.nil?
        response = self.class.get("/message_threads", headers: { "authorization" => @auth_token })
        totalPages = (1..(response["count"]/10 + 1)).map do |n|
          self.class.get("/message_threads?page=#{n}", headers: { "authorization" => @auth_token })
                    end
          totalPages
      else
          response = self.class.get("/message_threads?page=#{page}", headers: { "authorization" => @auth_token })
          @messages = JSON.parse(response.body)
      end
    end

    def create_message(recipient_id, subject, body, thread_token = nil)
        response = self.class.post("/messages", body: { 
            "user_id": @user_id,
            "recipient_id": recipient_id,
            "token": thread_token,
            "subject": subject,
            "stripped-text": body
        },
        headers: { "authorization" => @auth_token })
        puts response
    end

private

    def student_id
        response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
        @user_id = response["id"]
    end

end
