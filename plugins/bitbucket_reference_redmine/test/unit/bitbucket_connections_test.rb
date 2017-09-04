require File.expand_path('../../test_helper', __FILE__)

class BitbucketConnectionsTest < ActiveSupport::TestCase

  def test_does_not_save_connection_without_client_key
    bb_connection = BitbucketConnection.new(
      shared_secret: "test-shared-secret",
      base_api_url:  "test-base-api-url"
    )
    assert_not bb_connection.save
  end

  def test_does_not_save_connection_without_shared_secret
    bb_connection = BitbucketConnection.new(
      client_key:   "test-client-key",
      base_api_url: "test-base-api-url"
    )
    assert_not bb_connection.save
  end

  def test_does_not_save_connection_without_base_api_url
    bb_connection = BitbucketConnection.new(
      client_key:   "test-client-key",
      shared_secret: "test-shared-secret"
    )
    assert_not bb_connection.save
  end

  def test_allowed_defaults_to_false
    bb_connection = BitbucketConnection.create(
      client_key:    "test-client-key",
      shared_secret: "test-shared-secret",
      base_api_url:  "test-base-api-url",
    )

    assert_equal false, bb_connection.allowed
  end

  def test_shared_secret_gets_encrypted_on_save
    bb_connection = BitbucketConnection.create(
      client_key:     "test-client-key",
      shared_secret:  "test-shared-secret",
      base_api_url:   "test-base-api-url",
      user:           "test-user",
      user_link:      "test-user-link",
      principal:      "test-principal",
      principal_link: "test-principal-link"
    )

    assert_equal(
      "test-shared-secret",
      BitbucketConnection::ENCRYPTOR.decrypt_and_verify(
        bb_connection.shared_secret
      )
    )
  end

  def test_shared_secret_gets_decrypted_on_load
    BitbucketConnection.create(
      client_key:     "test-client-key",
      shared_secret:  "test-shared-secret",
      base_api_url:   "test-base-api-url",
      user:           "test-user",
      user_link:      "test-user-link",
      principal:      "test-principal",
      principal_link: "test-principal-link"
    )

    bb_connection = BitbucketConnection.find_by!(client_key: "test-client-key")

    assert_equal(
      "test-shared-secret",
      bb_connection.shared_secret
    )
  end
end
