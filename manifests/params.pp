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

  $agent_ip = $ec2_public_ipv4 ? {
    undef   => $ipaddress,
    default => $ec2_public_ipv4
  }
}