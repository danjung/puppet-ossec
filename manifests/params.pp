class ossec::params {
  case $osfamily {
    'RedHat' : {
      $install_home      = '/var/ossec'
      $group             = 'ossec'
      $hidspackage       = 'ossec-hids'
      $hidsagentservice  = 'ossec-hids-agent'
      $hidsagentpackage  = 'ossec-hids-agent'
      $hidsserverservice = 'ossec-control'
      $hidsservicepath   = "${install_home}/bin"
      $hidsserverpackage = 'ossec-hids-server'
    }
  }
}