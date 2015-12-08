Puppet::Type.newtype(:puppetpem2p12) do
  ensurable

  newparam(:path, namevar: true) do
  end

  newparam(:password) do
  end
end
