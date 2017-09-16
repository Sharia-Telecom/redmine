module EmojiButtonPlugin
  module Formatter
    module Markdown
      module Patch
        def self.included(base) # :nodoc:
          base.send(:include, EmojiButtonPlugin::Formatter)
          base.class_eval do
            unloadable # Send unloadable so it will not be unloaded in development

            # Markdown patch: add a postprocess hook to redcarpet's html formatter
            def postprocess(text)
              inline_emoji(text)
            end
          end
        end
      end
    end
  end
end
