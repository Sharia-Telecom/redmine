ActionDispatch::Callbacks.to_prepare do
  require 'query_patch2'
end

Redmine::Plugin.register :_query do
  name 'Using OR in query '
  author 'LTT Quan'
  description 'This plugin allows simple use of OR operator in query. This version is compatible with Redmine 3.4'
  version '0.0.3'
end

