# Copyright (C) 2017  Productize
#
# License: see LICENSE file

class BbConnectionsController < ApplicationController
  unloadable

  def allow
    bb_connection = BitbucketConnection.find(params["id"])
    raise ActiveRecord::RecordNotFound if bb_connection.nil?

    bb_connection.allowed = true
    bb_connection.save

    redirect_to plugin_settings_path :bitbucket_reference_redmine
  end

  def disconnect
    c = BitbucketConnection.destroy(params["id"])
    redirect_to plugin_settings_path :bitbucket_reference_redmine
  end
end
