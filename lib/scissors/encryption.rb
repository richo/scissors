require 'openssl'
require 'scissors'

# Encryption/signing
module Scissors::Encryption

  TIME_BLOCK_SIZE_MS = 300000

  def sign(data)
    sign_with_time(data, nearest_time_block)
  end

  def valid?(data, signature)
    (signature == sign_with_time(data, last_time_block)) or
    (signature == sign_with_time(data, next_time_block))
  end

  def sign_with_time(data, time)
    sha = OpenSSL::Digest::Digest.new('sha256')
    OpenSSL::HMAC.digest(sha, key, "#{app}-#{time.to_i}-#{data}")
  end

  def nearest_time_block
    (Time.now.to_f / TIME_BLOCK_SIZE_MS).round * TIME_BLOCK_SIZE_MS
  end

  def last_time_block
    (Time.now.to_f / TIME_BLOCK_SIZE_MS).floor * TIME_BLOCK_SIZE_MS
  end

  def next_time_block
    (Time.now.to_f / TIME_BLOCK_SIZE_MS).ceil * TIME_BLOCK_SIZE_MS
  end

end
