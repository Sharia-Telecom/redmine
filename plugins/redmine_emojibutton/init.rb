require 'emojibutton_formatter'
require 'emojibutton_formatter_textile_patch'
require 'emojibutton_formatter_markdown_patch'
require 'emojibutton_helper_patch'

Redmine::Plugin.register :redmine_emojibutton do
  name 'Redmine Emoji Button'
  author 'Tobias Fischer'
  description "Enable github style emoji's in tickets and comments and choose emojis from a new editor button"
  version '0.4.1'
  url 'https://github.com/paginagmbh/redmine_emojibutton'
  author_url 'https://github.com/tofi86'
end

Rails.configuration.to_prepare do
  Rails.configuration.assets.paths << Emoji.images_path

  # send Emoji Patches to all wiki formatters available to be able to switch formatter without app restart
  Redmine::WikiFormatting::format_names.each do |format|
    case format
    when "markdown"
      unless Redmine::WikiFormatting::Markdown::HTML.included_modules.include? EmojiButtonPlugin::Formatter::Markdown::Patch
        Redmine::WikiFormatting::Markdown::HTML.send(:include, EmojiButtonPlugin::Formatter::Markdown::Patch)
      end
    when "textile"
      unless Redmine::WikiFormatting::Textile::Formatter.included_modules.include? EmojiButtonPlugin::Formatter::Textile::Patch
        Redmine::WikiFormatting::Textile::Formatter.send(:include, EmojiButtonPlugin::Formatter::Textile::Patch)
      end
    end
    
    unless Redmine::WikiFormatting::helper_for(format).included_modules.include? EmojiButtonPlugin::Helper::Patch
     Redmine::WikiFormatting::helper_for(format).send(:include, EmojiButtonPlugin::Helper::Patch)
    end
  end
end
