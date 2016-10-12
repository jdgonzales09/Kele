require "kele/version"
require "typhoeus"
require "json"
require "pry"
require "roadmap"

class Kele

    include Roadmap
    include Typhoeus

    def initialize(email, password)
        url = 'https://www.bloc.io/api/v1/sessions'
        response = Typhoeus::Request.post(url, body: { "email": email, "password": password })
        binding.pry
        @auth_token = response.body["auth_token"]
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

    def create_message(user_id, recipient_id, subject, stripped_text, thread_token = nil)
        values = '{
        "user_id": user_id,
        "recipient_id": recipient_id,
        "token": thread_token,
        "subject": subject,
        "stripped-text": stripped_text
        }'
        response = self.class.post("/messages", body: values, headers: { "authorization" => @auth_token })
        puts response
    end

    def create_submission(enrollment_id, checkpoint_id, assignment_branch, assignment_commit_link, comment = nil)
        values = '{
            "assignment_branch": assignment_branch,
            "assignment_commit_link": assignment_commit_link,
            "checkpoint_id": checkpoint_id,
            "comment": comment,
            "enrollment_id": enrollment_id
        }'
        response = self.class.post("/checkpoint_submissions", body: values, headers: { "authorization" => @auth_token })
        puts response

    end


end
