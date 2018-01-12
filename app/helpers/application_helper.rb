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

require 'openssl'
require 'active_support/core_ext/securerandom'
require_relative '../../lib/homemate/exception'

module ApplicationHelper
  class Encryptor
    class << self
      attr_reader :cipher, :iterations, :digest, :pkey, :key_size
      attr_writer :salt, :password, :cipher, :iterations, :digest, :pkey, :key_size
    end

    @salt = nil
    @cipher = 'AES-256-CBC'
    @iterations = 20000
    @digest = OpenSSL::Digest::SHA256
    @pkey = OpenSSL::PKey::RSA
    @key_size = 2048

    def self.initialize
      yield(self.class)
    end
  end

  class FileEncryptor < Encryptor
    def encrypt(data, password = nil)
      password = SecureRandom::base58(20) unless password.present?

      cipher = self.cipher.type.new(self.cipher.length, self.cipher.mode).encrypt
      iv = cipher.random_iv
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(password, self.salt, self.iterations, cipher.key_len, self.digest.new)

      {
        :iv => iv,
        :encrypted => cipher.update(data) + cipher.final,
        :password => password
      }
    end

    def decrypt(iv, password, secret)
      cipher = OpenSSL::Cipher.new(self.cipher).decrypt
      cipher.iv = iv
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(password, self.salt, self.iterations, cipher.key_len, self.digest.new)

      cipher.update(secret) + cipher.final
    end
  end

  class SecretEncryptor < Encryptor
    def generate_key(passphrase)
      key = self.pkey.new(self.key_size)

      {
        :public => key.public_key.to_pem,
        :private => key.export(OpenSSL::Cipher.new(self.cipher), passphrase)
      }
    end

    def check_passphrase(private_key, passphrase)
      key = self.pkey.new(private_key, passphrase)

      key.private?
    end

    def update_passphrase(private_key, current, new)
      key = self.pkey.new(private_key, current)

      unless key.private?
        raise HomeMate::InvalidUsage 'The key supplied does not have a valid private key'
      end

      key.export(OpenSSL::Cipher.new(self.cipher), new)
    end

    def encrypt(public_key, data)
      key = self.pkey.new(public_key)

      unless key.public?
        raise HomeMate::InvalidUsage 'The key supplied does not have a valid public key'
      end

      key.public_encrypt(data)
    end

    def decrypt(private_key, passphrase, data)
      key = self.pkey.new(private_key, passphrase)

      unless key.private?
        raise HomeMate::InvalidUsage 'The key supplied does not have a valid private key'
      end

      key.private_decrypt(data)
    end
  end
end
