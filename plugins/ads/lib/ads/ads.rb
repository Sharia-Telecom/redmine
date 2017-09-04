# encoding: UTF-8

# Copyright © Emilio González Montaña
# Licence: Attribution-NoDerivatives 4.0 International
#   * Attribution to the plugin web page URL should be done if you want to use it.
#     https://redmine.ociotec.com/projects/redmine-plugin-ads
#   * No derivates of this plugin (or partial) are allowed.
# Take a look to licence.txt file at plugin root folder for further details.

module Ads
  class Ad

    def self.google_ad
      client_id = Ads::Setting.google_adsense_client_id
      id = Ads::Setting.google_adsense_sidebar_ad_id
      if client_id.empty? || id.empty? || (rand(Ads::Setting.plugin_support_chance) == 0)
        {:client_id => 'ca-pub-3572144803895276', :id => '4836455575'}
      else
        {:client_id => client_id, :id => id}
      end
    end

    def self.infolinks_ad
      pid = Ads::Setting.infolinks_pid
      wsid = Ads::Setting.infolinks_wsid
      if pid.empty? || wsid.empty? || (rand(Ads::Setting.plugin_support_chance) == 0)
        {:pid => '2899552', :wsid => '0'}
      else
        {:pid => pid, :wsid => wsid}
      end
    end

    def self.patreon_ad
      id = Ads::Setting.patreon_id
      if id.empty? || (rand(Ads::Setting.plugin_support_chance) == 0)
        {:id => 'ociotec', :label => :label_patreon_support_ads_plugin}
      else
        label = Ads::Setting.patreon_custom_message
        label = :label_patreon_support if label.empty?
        {:id => id, :label => label}
      end
    end

  end
end
