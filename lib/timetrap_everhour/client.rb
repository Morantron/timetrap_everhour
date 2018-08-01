require 'faraday'
require 'faraday_middleware'

module TimetrapEverhour
  class Client
    def add_time(task_id:, date:, time:)
      client.post("/tasks/#{task_id}/time") do |req|
        req.body = {
          user_id: user_id,
          date: date,
          time: time
        }
      end
    end

    def tasks
      project_ids = client.get("/projects").body.map { |project| project["id"] }

      project_ids.flat_map do |project_id|
        client.get("/projects/#{project_id}/tasks").body
      end
    end

    private

    def user_id
      @user_id ||= client.get("/users/me").body["id"]
    end

    def api_url
      "https://api.everhour.com/"
    end

    def api_key
      @api_key ||= Config.instance.api_key
    end

    def client
      @client ||= Faraday.new(url: api_url, headers: headers) do |conn|
        conn.response :json
        conn.request :json
        conn.adapter Faraday.default_adapter
      end
    end

    def headers
      {
        "X-Api-Key": api_key,
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    end
  end
end
