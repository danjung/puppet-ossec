class ossec::params {
  case $osfamily {
    'RedHat' : {
      $install_home       = '/var/ossec'
      $group              = 'ossec'
      $hidspackage        = 'ossec-hids'
      $hidsclientservice  = 'ossec-control'
      $hidsclientpackage  = 'ossec-hids-client'
      $hidsserverservice  = 'ossec-control'
      $hidsserverpackage  = 'ossec-hids-server'
      $hidsservicepath    = "${install_home}/bin"
    }
  }
}