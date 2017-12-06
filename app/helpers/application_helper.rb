require 'openssl'

module ApplicationHelper
  module Encryptor
    attr_reader :cipher, :iterations, :digest
    attr_writer :salt, :password, :cipher, :iterations, :digest

    @salt = nil
    @password = nil
    @cipher = 'AES-256-CBC'
    @iterations = 20000
    @digest = OpenSSL::Digest::SHA256

    def self.initialize
      yield(self)
    end

    def self.encrypt(data)
      cipher = OpenSSL::Cipher.new(self.cipher).encrypt
      iv = cipher.random_iv
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.salt, self.iterations, cipher.key_len, self.digest.new)

      return [
        :iv => iv,
        :encrypted => cipher.update(data) + cipher.final
      ]
    end

    def self.decrypt(iv, secret)
      cipher = OpenSSL::Cipher.new(self.cipher).decrypt
      cipher.iv = iv
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.salt, self.iterations, cipher.key_len, self.digest.new)

      return cipher.update(secret) + cipher.final
    end
  end
end
