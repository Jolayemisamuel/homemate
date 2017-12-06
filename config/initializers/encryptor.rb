ApplicationHelper::Encryptor.new do |config|
  # => Initialize the application symmetric encryptor module

  # config.salt = ''
  # config.password = ''

  # The algorithm used for encryption, in the format `<name>-<key length>-<mode>`
  # List of available algorithms can be found with the command `ruby -e "require 'openssl';puts OpenSSL::Cipher.ciphers;"`
  # config.cipher = 'AES-256-CBC'

  # config.iterations = 20000

  # Hashing function used for PKCS#5, in the format `OpenSSL::Digest::<algorithm>`
  # Supported algorithms include SHA, SHA1, SHA224, SHA256, SHA384 and SHA512; MD2, MD4, MDC2 and MD5; and RIPEMD160
  # config.digest = OpenSSL::Digest::SHA256
end