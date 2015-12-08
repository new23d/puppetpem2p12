# puppetpem2p12

Extend your Puppet CA (Certificate Authority) for use on your MS Windows infrastructure. Converts PEM files to the P12 format and installs them in the Certificate Manager too.

Common uses could be an HTTPS WinRM setup, IIS, etc. and the ability to trust other certificates issued by your Puppet CA.

This module add two facts from `puppet config`:

`puppet_config_ssldir` which is the path to the directory containing SSL related files.

`puppet_config_localcacert` which is the path to the CA certificate's .PEM file on the agent side.

The module also provides three new types:

`puppetpem2p12` this simply converts the .PEM format certificate and private key into a .P12 format file.

`p122certmgr` this installs a given .P12 file into the MS Windows Certificate Manager.

`pem2certmgrCA` this installs the Puppet CA's public certificate into the MS Windows Trusted Root Certification Authorities Certificate Store - so that other certificates issued by this Puppet CA can be trusted.

### Example

```
# store the paths of various directories and file names in variables for convenience
$p12_dir = "${::puppet_config_ssldir}/p12"
$p12_path = "${p12_dir}/${::fqdn}.p12"

# P12 format needs a password
$p12_password = fqdn_rand(42)

# optionally print the password to the password protected .P12 file
notify {$p12_path:
  message => "Password to ${p12_path} is ${p12_password} ."
}

# create a new directory to store the .P12 file
file {$p12_dir:
  ensure => directory,
}

# convert the agent side certificate and private key to .P12 format and save it at $p12_path
puppetpem2p12 {$p12_path:
  ensure   => present,
  password => $p12_password,
}

# install the P12 certificate into the MS Windows Certificate Manager
p122certmgr {$p12_path:
  ensure   => present,
  password => $p12_password,
}

# Optionally install the Puppet CA's public certificate into MS Windows Trusted Root Certification Authorities Certificate Store
pem2certmgrCA {$::puppet_config_localcacert:
  ensure => present,
}
```

