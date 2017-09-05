# Copyright (C) 2017  Productize
#
# License: see LICENSE file

class BitbucketConnection < ActiveRecord::Base
  unloadable

  ENCRYPTOR = ActiveSupport::MessageEncryptor.new(
    RedmineApp::Application.config.secret_key_base
  )

  validates :client_key,    presence: true
  validates :shared_secret, presence: true
  validates :base_api_url,  presence: true

  after_initialize do
    self.allowed ||= false
  end
  before_save :encrypt_shared_secret
  after_find  :decrypt_shared_secret

  private

  def encrypt_shared_secret
    self.shared_secret = ENCRYPTOR.encrypt_and_sign(shared_secret)
  end

  def decrypt_shared_secret
    self.shared_secret = ENCRYPTOR.decrypt_and_verify(shared_secret)
  end
end
