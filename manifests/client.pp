class ossec::client (
  $ossec_active_response=true,
  $ossec_server_ip
) inherits ossec::params {
  include ossec::common
  include concat::setup

  # install package
  package { $hidsagentpackage : ensure => installed, require => Exec["setup-ossec-pkg-install"] }
  
  service { $hidsagentservice:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package[$hidsserverpackage],
  }
  
  concat { '/var/ossec/etc/ossec.conf':
    owner => root,
    group => ossec,
    mode => 0440,
    require => Package[$hidsagentpackage],
    notify => Service[$hidsagentservice]
  }

  concat::fragment { "ossec.conf_10" :
    target => '/var/ossec/etc/ossec.conf',
    content => template("ossec/10_ossec_agent.conf.erb"),
    order => 10,
    notify => Service[$hidsagentservice]
  }
  
  concat::fragment { "ossec.conf_99" :
    target => '/var/ossec/etc/ossec.conf',
    content => template("ossec/99_ossec_agent.conf.erb"),
    order => 99,
    notify => Service[$hidsagentservice]
  }

  concat { "/var/ossec/etc/client.keys":
    owner   => "root",
    group   => "ossec",
    mode    => "640",
    notify  => Service[$hidsagentservice],
    require => Package[$ossec::common::hidsagentpackage]
  }
  ossec::agentKey{ "ossec_agent_${hostname}_client": agent_id=>$uniqueid, agent_name => $hostname, agent_ip_address => $ipaddress}
  @@ossec::agentKey{ "ossec_agent_${hostname}_server": agent_id=>$uniqueid, agent_name => $hostname, agent_ip_address => $ipaddress}
}


