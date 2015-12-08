require 'puppet'

Facter.add(:puppet_config_ssldir) do
  setcode do
    Puppet.[](:ssldir)
  end
end

Facter.add(:puppet_config_localcacert) do
  setcode do
    Puppet.[](:localcacert)
  end
end
