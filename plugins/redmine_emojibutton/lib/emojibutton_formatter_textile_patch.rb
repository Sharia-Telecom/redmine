module EmojiButtonPlugin
  module Formatter
    module Textile
      module Patch
        def self.included(base) # :nodoc:
          base.send(:include, EmojiButtonPlugin::Formatter)
          base.class_eval do
            unloadable # Send unloadable so it will not be unloaded in development

            # Textile patch: add :inline_emoji to list of textile functions
            Redmine::WikiFormatting::Textile::Formatter::RULES << :inline_emoji
          end
        end
      end
    end
  end
end
