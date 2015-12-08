require 'openssl'

Puppet::Type.type(:puppetpem2p12).provide(:ruby_openssl) do
  def create
    file_hostprivkey = File.read(Puppet.[](:hostprivkey))
    file_hostcert = File.read(Puppet.[](:hostcert))
    file_localcacert = File.read(Puppet.[](:localcacert))

    openssl_pass = @resource[:password]
    openssl_name = nil
    openssl_key = OpenSSL::PKey::RSA.new(file_hostprivkey)
    openssl_cert = OpenSSL::X509::Certificate.new(file_hostcert)

    openssl_pkcs12 = OpenSSL::PKCS12.create(openssl_pass, openssl_name, openssl_key, openssl_cert)

    file_p12 = File.open(@resource[:path], 'wb')
    file_p12.write(openssl_pkcs12.to_der)
    file_p12.close
  end

  def destroy
    File.unlink(@resource[:path])
  end

  def exists?
    File.exist?(@resource[:path])
  end

  def self.instances
    fail 'Not implemented.'
  end
end
