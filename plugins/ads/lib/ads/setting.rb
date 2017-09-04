# encoding: UTF-8

# Copyright © Emilio González Montaña
# Licence: Attribution-NoDerivatives 4.0 International
#   * Attribution to the plugin web page URL should be done if you want to use it.
#     https://redmine.ociotec.com/projects/redmine-plugin-ads
#   * No derivates of this plugin (or partial) are allowed.
# Take a look to licence.txt file at plugin root folder for further details.

module Ads
  class Setting

    %w(google_adsense_enabled
       google_analytics_enabled
       infolinks_enabled
       patreon_enabled).each do |setting|
      src = <<-END_SRC
      def self.#{setting}
        setting_or_default_boolean(:#{setting})
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end

    %w(google_adsense_client_id
       google_adsense_sidebar_ad_id
       google_analytics_id
       infolinks_pid
       infolinks_wsid
       patreon_id
       patreon_custom_message).each do |setting|
      src = <<-END_SRC
      def self.#{setting}
        setting_or_default(:#{setting})
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end

    def self.plugin_support_chance(what = nil)
      if what == :min
        MIN_PLUGIN_SUPPORT_CHANCE
      elsif what == :max
        MAX_PLUGIN_SUPPORT_CHANCE
      else
        setting_or_default_integer(:plugin_support_chance,
                                   :min => MIN_PLUGIN_SUPPORT_CHANCE,
                                   :max => MAX_PLUGIN_SUPPORT_CHANCE)
      end
    end

  private

    MIN_PLUGIN_SUPPORT_CHANCE = 2
    MAX_PLUGIN_SUPPORT_CHANCE = 10

    def self.setting_or_default(setting)
      ::Setting.plugin_ads[setting] ||
      Redmine::Plugin::registered_plugins[:ads].settings[:default][setting]
    end

    def self.setting_or_default_boolean(setting)
      setting_or_default(setting) == '1'
    end

    def self.setting_or_default_integer(setting, options = {})
      value = setting_or_default(setting).to_i
      value = options[:min] if options[:min] and value < options[:min]
      value = options[:max] if options[:max] and value > options[:max]
      value
    end

  end
end
