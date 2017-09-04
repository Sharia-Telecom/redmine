# Copyright (C) 2017  Productize
#
# License: see LICENSE file

require 'bb_connections'

Redmine::Plugin.register :bitbucket_reference_redmine do
  name 'Bitbucket references'
  description 'Reference Redmine issues in Bitbucket.'
  url 'https://bitbucket.org/productize/bitbucket_reference_redmine'
  author 'Seppe Stas, Productize'
  author_url 'https://productize.be'
  version '0.1.3'

  settings :default => { 'allow_new_bb_accounts' => '1' }, :partial => 'settings/bb_references'

end
