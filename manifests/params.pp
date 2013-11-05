class ossec::params {
	case $osfamily {
    'RedHat' : {
      $hidsagentservice='ossec-hids-agent'
      $hidsagentpackage='ossec-hids-agent'
      $hidsserverservice='ossec-hids-server'
      $hidsserverpackage='ossec-hids-server'
    }
  }
}