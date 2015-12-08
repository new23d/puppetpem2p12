Puppet::Type.newtype(:p122certmgr) do
  ensurable

  newparam(:path, namevar: true) do
  end

  newparam(:password) do
  end
end
