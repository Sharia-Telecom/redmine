# Copyright (C) 2017  Productize
#
# License: see LICENSE file
# 
# This changes the type of the Bitbucket reference user to be "User" so the
# name is displayed

class ChangeBitbucketReferenceUserType < ActiveRecord::Migration
  class User < ActiveRecord::Base
    unloadable
    self.inheritance_column = :_type_disabled
  end

  def self.up
    u = User.find_by_login("bitbucket_reference_redmine")
    u.type = "User"
    u.save
  end
end
