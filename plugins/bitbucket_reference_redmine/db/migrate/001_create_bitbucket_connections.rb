# Copyright (C) 2017  Productize
#
# License: see LICENSE file

class CreateBitbucketConnections < ActiveRecord::Migration
  def self.up
    create_table :bitbucket_connections do |t|
      t.string :client_key
      t.string :shared_secret
      t.string :base_api_url
      t.string :user
      t.string :user_link
      t.string :principal
      t.string :principal_link
      t.boolean :allowed
    end
  end

  def self.down
    drop_table :bitbucket_connections
  end
end
