module Fastlane
    module Actions
      class BuddybuildShowLatestBuildAction < Action
        def self.run(params)
          require 'faraday'
          require 'faraday_middleware'
          require 'json'
  
          UI.error("API Access Token not set") unless params[:api_access_token]
          UI.error("Application Id not set") unless params[:app_id]  

          buddybuild_api_base_url = 'https://api.buddybuild.com'
  
          conn = Faraday.new(:url => buddybuild_api_base_url) do |builder|
            builder.authorization :Bearer, params[:api_access_token]
            builder.adapter :net_http
          end

          response = conn.get "/v1/apps/#{params[:app_id]}/build/latest" do |req|
            if !params[:branch].nil?
                req.params[:branch] = params[:branch]
            end
            if !params[:scheme].nil?
                req.params[:scheme] = params[:scheme]
            end
            if !params[:status].nil?
                req.params[:status] = params[:status]
            end
          end

          case response.status
          when 200...300            
            return response.body
          else
            UI.user_error!('Error retrieving applications: #{response.status} - #{response.body}')
          end
          
        end
  
        def self.description
          "Retrieves the latest build for a given Application Identifier."
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
                                          type: String),
            FastlaneCore::ConfigItem.new(key: :app_id,
                                          env_name: "BUDDYBUILD_APP_ID",
                                          description: "The Buddybuild Application Identifier",
                                          optional: true,
                                          type: String),
            FastlaneCore::ConfigItem.new(key: :branch,
                                          env_name: "BUDDYBUILD_BRANCH_ID",
                                          description: "The Buddybuild Application Branch",
                                          optional: true,
                                          type: String),
            FastlaneCore::ConfigItem.new(key: :scheme,
                                          env_name: "BUDDYBUILD_APP_SCHEMA",
                                          description: "The Buddybuild Application Schema",
                                          optional: true,
                                          type: String),
            FastlaneCore::ConfigItem.new(key: :status,
                                          env_name: "BUDDYBUILD_APP_STATUS",
                                          description: "The Buddybuild Application Status",
                                          optional: true,
                                          type: String,
                                          verify_block: proc do |value|
                                            UI.user_error! "#{value} is not a valid status" unless ["cancelled", "failed", "queued", "running", "success"].include? value
                                          end)
          ]
        end
  
        def self.is_supported?(platform)
          true
        end
      end
    end
  end
  