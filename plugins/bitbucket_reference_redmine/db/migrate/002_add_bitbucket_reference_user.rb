# Copyright (C) 2017  Productize
#
# License: see LICENSE file

class AddBitbucketReferenceUser < ActiveRecord::Migration
  LOGIN = "bitbucket_reference_redmine"

  class User < ActiveRecord::Base
    unloadable
    self.inheritance_column = :_type_disabled
  end

  def self.up
    user = User.create(
      :login     => LOGIN,
      :firstname => "Bitbucket",
      :lastname  => "reference",
      :type      => "AnonymousUser"
    )
  end

  def self.down
    User.find_by_login(LOGIN).destroy
  end
end
