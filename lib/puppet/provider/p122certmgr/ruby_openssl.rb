require 'openssl'
require 'open3'

Puppet::Type.type(:p122certmgr).provide(:ruby_openssl) do
  def _thumbprint
    file_p12 = File.open(@resource[:path], 'rb')
    der_p12 = file_p12.read
    file_p12.close

    openssl_pkcs12 = OpenSSL::PKCS12.new(der_p12, @resource[:password])
    var_thumbprint = OpenSSL::Digest::SHA1.new(openssl_pkcs12.certificate.to_der)

    var_thumbprint
  end

  def create
    stdin, stdout, stderr, wait_thr = Open3.popen3("certutil -p #{@resource[:password]} -importpfx #{@resource[:path]}")
    stdin.close
    var_cert_installed = (wait_thr.value.exitstatus == 0)

    var_cert_installed
  end

  def destroy
    var_thumbprint = _thumbprint

    stdin, stdout, stderr, wait_thr = Open3.popen3("certutil -delstore My \"#{var_thumbprint}\"")
    stdin.close
    var_cert_deleted = (wait_thr.value.exitstatus == 0)

    var_cert_deleted
  end

  def exists?
    var_thumbprint = _thumbprint

    stdin, stdout, stderr, wait_thr = Open3.popen3("certutil -verifystore My \"#{var_thumbprint}\"")
    stdin.close
    var_cert_installed = (wait_thr.value.exitstatus == 0)

    var_cert_installed
  end

  def self.instances
    fail 'Not implemented.'
  end
end
