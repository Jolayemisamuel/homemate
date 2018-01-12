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

ApplicationHelper::Encryptor.initialize do |config|
  # => Initialize the application encryptor module

  # config.salt = ''

  # The algorithm used for encryption, in the format `<name>-<key length>-<mode>`
  # List of available algorithms can be found with the command `ruby -e "require 'openssl';puts OpenSSL::Cipher.ciphers;"`

  # config.cipher = 'AES-256-CBC'
  # config.iterations = 20000

  # => Hashing function used for PKCS#5, in the format `OpenSSL::Digest::<algorithm>`
  #
  # Supported algorithms include SHA, SHA1, SHA224, SHA256, SHA384 and SHA512; MD2, MD4, MDC2 and MD5; and RIPEMD160

  # config.digest = OpenSSL::Digest::SHA256

  # => Public/private key algorithm used for asymmetric encryption, in the format `OpenSSL::PKey::<algorithm>` and the
  # => key size
  #
  # Supported algorithms include RSA and DSA

  # config.pkey = OpenSSL::PKey::RSA
  # config.key_size = 2048
end

Hashid::Rails.configure do |config|
  # => The salt to use for generating hashid. Prepended with table name.
  # config.salt = ''

  # => The minimum length of generated hashids
  config.min_hash_length = 6

  # => The alphabet to use for generating hashids
  config.alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

  # => Whether to override the `find` method
  config.override_find = false
end