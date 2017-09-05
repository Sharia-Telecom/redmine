# Copyright (C) 2017  Productize
#
# License: see LICENSE file

module BitbucketConnections
  extend self
  def connected_accounts()
    BitbucketConnection.where(allowed: true)
  end

  def connecting_accounts()
    BitbucketConnection.where(allowed: false)
  end
end
