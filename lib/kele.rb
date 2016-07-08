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
        if response == 200
            puts response
        else
            puts "Oops there was an error! Lemme check on that!"
        end
    end

    def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment = nil)
        response = self.class.post("/checkpoint_submissions", body: {
            "assignment_branch": assignment_branch,
            "assignment_commit_link": assignment_commit_link,
            "checkpoint_id": checkpoint_id,
            "comment": comment,
            "enrollment_id": @enrollment_id
        }, 
        headers: { "authorization" => @auth_token })
        if response == 200
            puts response
        else
            puts "Oops, that's not right, lemme fix that"
        end
        
    end
private

    def student_id
        response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
        @user_id = response["id"]
    end

    def enrollment_id
        response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
        @enrollment_id = response["current_enrollment" "id"]
    end

end
