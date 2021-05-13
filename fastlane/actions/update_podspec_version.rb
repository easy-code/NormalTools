module Fastlane
  module Actions
    module SharedValues
      UPDATE_PODSPEC_VERSION_CUSTOM_VALUE = :UPDATE_PODSPEC_VERSION_CUSTOM_VALUE
    end

    class UpdatePodspecVersionAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        target_version = params[:version]
        spec_path = params[:spath]
    
        # 定义一个数据 用来存储所有需要执行的命令
        cmds = []
    
        v = target_version.split(".").map { |s| s.to_i }
        v_0 = v[0]
        v_1 = v[1]
        v_2 = v[2]
        target_version = "#{v_0}.#{v_1}.#{v_2+1}"
        UI.message("👉 version add Libifly new version #{target_version}")

        cmds << "fastlane run version_bump_podspec"
        
        # 执行数组里面所有的命令
        result = Actions.sh(cmds.join('&'));
        return result
        
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "版本号自动加一"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "版本号加一"
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "版本号加一", # a short description of this parameter
                                       optional: false,
                                       is_string: true
                                       ),
    
          FastlaneCore::ConfigItem.new(key: :spath,
                               description: "spec path",
                                  optional: false,
                                 is_string: true
                                       ),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['UPDATE_PODSPEC_VERSION_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
