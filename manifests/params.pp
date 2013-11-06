class ossec::params {
	case $osfamily {
    'RedHat' : {
      $hidspackage       = 'ossec-hids'
      $hidsagentservice  = 'ossec-hids-agent'
      $hidsagentpackage  = 'ossec-hids-agent'
      $hidsserverservice = 'ossec-hids-server'
      $hidsserverpackage = 'ossec-hids-server'
    }
  }
}