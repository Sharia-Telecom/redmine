require 'redmine'

require 'details_issue_hooks'

Redmine::Plugin.register :redmine_issue_dynamic_edit do
  name 'Redmine Dynamic edit Issue plugin'
  author 'Hugo Zilliox'
  description 'Allows users to dynamically update issue attributes in detailed view'
  version '0.4.0'
  url 'https://github.com/ilogeek/redmine_issue_dynamic_edit'
  author_url 'https://hzilliox.fr'
end
