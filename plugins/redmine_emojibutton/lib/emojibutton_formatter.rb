module EmojiButtonPlugin
  module Formatter

    # emoji text substitution
    def inline_emoji(text)
      text.gsub!(/:([a-z0-9\+\-_]+):/) do |match|
        if Emoji.names.include?($1)
          '<img alt="' + $1 + '" height="20" src="'+ Setting.protocol + "://" + Setting.host_name + '/images/emoji/' + $1 + '.png" style="vertical-align:middle" width="20" title=":' + $1 + ':" class="emoji" />'
        else
          match
        end
      end
      text
    end

  end
end
