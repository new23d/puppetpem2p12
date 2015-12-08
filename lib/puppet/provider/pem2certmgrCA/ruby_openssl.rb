require 'openssl'
require 'open3'

Puppet::Type.type(:pem2certmgrca).provide(:ruby_openssl) do
  def _thumbprint
    pem_pem = File.read(@resource[:path])

    openssl_cert = OpenSSL::X509::Certificate.new(pem_pem)
    var_thumbprint = OpenSSL::Digest::SHA1.new(openssl_cert.to_der)

    var_thumbprint
  end

  def create
    stdin, stdout, stderr, wait_thr = Open3.popen3("certutil -addstore AuthRoot #{@resource[:path]}")
    stdin.close
    var_cert_installed = (wait_thr.value.exitstatus == 0)

    var_cert_installed
  end

  def destroy
    var_thumbprint = _thumbprint

    stdin, stdout, stderr, wait_thr = Open3.popen3("certutil -delstore AuthRoot \"#{var_thumbprint}\"")
    stdin.close
    var_cert_deleted = (wait_thr.value.exitstatus == 0)

    var_cert_deleted
  end

  def exists?
    var_thumbprint = _thumbprint

    stdin, stdout, stderr, wait_thr = Open3.popen3("certutil -verifystore AuthRoot \"#{var_thumbprint}\"")
    stdin.close
    var_cert_installed = (wait_thr.value.exitstatus == 0)

    var_cert_installed
  end

  def self.instances
    fail 'Not implemented.'
  end
end
