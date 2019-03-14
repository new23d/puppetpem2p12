Puppet::Type.newtype(:pem2certmgrca) do
  ensurable

  newparam(:path, namevar: true) do
  end
end
