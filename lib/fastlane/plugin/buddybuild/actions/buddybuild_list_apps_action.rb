module Fastlane
  module Actions
    class BuddybuildListAppsAction < Action
      def self.run(params)
        require 'faraday'
        require 'faraday_middleware'
        require 'json'

        UI.error("API Access Token not set") unless params[:api_access_token]

        buddybuild_api_base_url = 'https://api.buddybuild.com'

        conn = Faraday.new(:url => buddybuild_api_base_url) do |builder|
          builder.authorization :Bearer, params[:api_access_token]
          builder.adapter :net_http
        end
        response = conn.get '/v1/apps'

        case response.status
        when 200...300
          # Print table
          options = [
            "Number",
            "App Id",
            "Name",
            "Platform"
          ]

          json = JSON.parse(response.body)

          rows = []
          json.each_with_index do |value, i|
            index = i + 1
            rows << [index, value['_id'], value['app_name'], value['platform']]
          end

          puts Terminal::Table.new(
            title: "Buddybuild Applications".green,
            headings: options,
            rows: FastlaneCore::PrintTable.transform_output(rows)
          )
          return response.body
        else
          UI.user_error!('Error retrieving applications: #{response.status} - #{response.body}')
        end
        
      end

      def self.description
        "Retrieves all the applications for a given account in Buddybuild."
      end

      def self.authors
        ["Jorge Revuelta"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_access_token,
                                        env_name: "BUDDYBUILD_API_ACCESS_TOKEN",
                                        description: "The Buddybuild API Access Token for a given account",
                                        optional: false,
                                        type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
