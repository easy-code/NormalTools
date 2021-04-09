module Fastlane
  module Actions
    module SharedValues
      REMOVE_TAG_CUSTOM_VALUE = :REMOVE_TAG_CUSTOM_VALUE
    end

    class RemoveTagAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        tagName = params[:tag]
        isRemoveLocalTag = params[:rL]
        isRemoveRemoteTag = params[:rR]
        
        # 定义一个数据 用来存储所有需要执行的命令
        cmds = []
        
        # 删除本地标签
        # git tag -d 标签名
        if isRemoveLocalTag
            cmds << "git tag -d #{tagName} "
        end
        
        # 删除远程标签
        # git push origin :标签名
        if isRemoveRemoteTag
            cmds << " git push origin :#{tagName}"
        end
        
        # 执行数组里面所有的命令
        result = Actions.sh(cmds.join('&'));
        return result

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::REMOVE_TAG_CUSTOM_VALUE] = "my_val"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "非常好用的action"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "删除重复tag"
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
            FastlaneCore::ConfigItem.new(key: :tag,
                                     description: "需要被删除的标签名称",
                                     optional: false,
                                     is_string: true
                                     ),
            FastlaneCore::ConfigItem.new(key: :rL,
                                 description: "是否需要删除本地标签",
                                    optional: true,
                                   is_string: false,
                               default_value: true
                                    ),
            FastlaneCore::ConfigItem.new(key: :rR,
                                 description: "是否需要删除远程标签",
                                    optional: true,
                                   is_string: false,
                               default_value: true
                                    )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
            [tag, '已被移除']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["chengfeng"]
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
