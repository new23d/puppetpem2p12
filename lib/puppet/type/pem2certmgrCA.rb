Puppet::Type.newtype(:pem2certmgrCA) do
  ensurable

  newparam(:path, namevar: true) do
  end
end
