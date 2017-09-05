# encoding: UTF-8

# Copyright © Emilio González Montaña
# Licence: Attribution-NoDerivatives 4.0 International
#   * Attribution to the plugin web page URL should be done if you want to use it.
#     https://redmine.ociotec.com/projects/redmine-plugin-ads
#   * No derivates of this plugin (or partial) are allowed.
# Take a look to licence.txt file at plugin root folder for further details.

module Ads
  class ViewHooks < Redmine::Hook::ViewListener

    render_on(:view_layouts_base_html_head, :partial => 'ads/head')
    render_on(:view_layouts_base_sidebar, :partial => 'ads/sidebar')

  end
end
