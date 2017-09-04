# encoding: UTF-8

# Copyright © Emilio González Montaña
# Licence: Attribution-NoDerivatives 4.0 International
#   * Attribution to the plugin web page URL should be done if you want to use it.
#     https://redmine.ociotec.com/projects/redmine-plugin-ads
#   * No derivates of this plugin (or partial) are allowed.
# Take a look to licence.txt file at plugin root folder for further details.

require_dependency 'ads/ads'
require_dependency 'ads/view_hooks'

Redmine::Plugin.register :ads do
  name              'Ads plugin'
  author            'Emilio González Montaña'
  description       'This plugin allows to render ads inside Redmine'
  version           '0.2.1'
  url               'https://redmine.ociotec.com/projects/redmine-plugin-ads'
  author_url        'https://ociotec.com'
  requires_redmine  :version_or_higher => '3.0.0'
  settings          :default => {:google_adsense_enabled => '0',
                                 :google_adsense_client_id => '',
                                 :google_adsense_sidebar_ad_id => '',
                                 :google_analytics_enabled => '0',
                                 :google_analytics_id => '',
                                 :infolinks_enabled => '0',
                                 :infolinks_pid => '',
                                 :infolinks_wsid => '',
                                 :patreon_enabled => '0',
                                 :patreon_id => '',
                                 :patreon_custom_message => '',
                                 :plugin_support_chance => 5},
                    :partial => 'settings/ads_settings'
end
