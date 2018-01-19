##
# Copyright (c) Andrew Ying 2017-18.
#
# This file is part of HomeMate.
#
# HomeMate is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU General Public License
# as published by the Free Software Foundation. You must preserve
# all reasonable legal notices and author attributions in this program
# and in the Appropriate Legal Notice displayed by works containing
# this program.
#
# HomeMate is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HomeMate.  If not, see <http://www.gnu.org/licenses/>.
##

require 'base64'
require 'openssl'
require 'active_support/core_ext/securerandom'
require_relative '../../lib/homemate/exception'

module ApplicationHelper
  class Encryptor
    cattr_accessor :salt, :cipher, :iterations, :digest, :pkey, :key_size

    self.salt = Rails.application.secrets.secret_key_base
    self.cipher = 'AES-256-CBC'
    self.iterations = 20000
    self.digest = OpenSSL::Digest::SHA256
    self.pkey = OpenSSL::PKey::RSA
    self.key_size = 2048

    def self.initialize
      yield(self.class)
    end
  end

  class FileEncryptor < Encryptor
    def self.encrypt(data, password = nil)
      password = SecureRandom::base58(20) unless password.present?

      cipher = OpenSSL::Cipher.new(self.cipher).encrypt
      iv = cipher.random_iv

      digest = self.digest.new
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(password, self.salt, self.iterations, digest.digest_length, digest)

      {
        :iv => Base64.encode64(iv),
        :encrypted => cipher.update(data) + cipher.final,
        :password => password
      }
    end

    def self.decrypt(iv, password, secret)
      cipher = OpenSSL::Cipher.new(self.cipher).decrypt
      cipher.iv = Base64.decode64(iv)

      digest = self.digest.new
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(password, self.salt, self.iterations, digest.digest_length, digest)

      cipher.update(secret) + cipher.final
    end
  end

  class SecretEncryptor < Encryptor
    def self.generate_key(passphrase)
      key = self.pkey.new(self.key_size)

      {
        :public => key.public_key.to_pem,
        :private => key.export(OpenSSL::Cipher.new(self.cipher), passphrase)
      }
    end

    def self.check_passphrase(private_key, passphrase)
      key = self.pkey.new(private_key, passphrase)

      key.private?
    end

    def self.update_passphrase(private_key, current, new)
      key = self.pkey.new(private_key, current)

      unless key.private?
        raise HomeMate::InvalidUsage 'The key supplied does not have a valid private key'
      end

      key.export(OpenSSL::Cipher.new(self.cipher), new)
    end

    def self.encrypt(public_key, data)
      key = self.pkey.new(public_key)

      unless key.public?
        raise HomeMate::InvalidUsage 'The key supplied does not have a valid public key'
      end

      Base64.encode64(key.public_encrypt(data))
    end

    def self.decrypt(private_key, passphrase, data)
      key = self.pkey.new(private_key, passphrase)

      unless key.private?
        raise HomeMate::InvalidUsage 'The key supplied does not have a valid private key'
      end

      key.private_decrypt(Base64.decode64(data))
    end
  end
end
