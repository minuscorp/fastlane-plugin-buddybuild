module Fastlane
  module Helper
    class BuddybuildHelper
      # class methods that you define here become available in your action
      # as `Helper::BuddybuildHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the buddybuild plugin helper!")
      end
    end
  end
end
