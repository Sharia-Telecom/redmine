# Copyright (C) 2017  Productize
#
# License: see LICENSE file

get 'bitbucket-references', :to => 'bb_references#descriptor'
post 'bitbucket-references/installed', :to => 'bb_references#installed'
post 'bitbucket-references/uninstalled', :to => 'bb_references#uninstalled'

post 'bitbucket-references/push', :to => 'bb_references#push'
post 'bitbucket-references/commit_comment', :to => 'bb_references#commit_comment'
post 'bitbucket-references/pullrequest', :to => 'bb_references#pullrequest'
post 'bitbucket-references/pullrequest_comment', :to => 'bb_references#pullrequest_comment'

post 'bitbucket-connections/:id/allow', :to => 'bb_connections#allow', :as => 'bitbucket_connection_allow'
post 'bitbucket-connections/:id/disconnect', :to => 'bb_connections#disconnect', :as => 'bitbucket_connection_disconnect'
