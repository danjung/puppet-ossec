class ossec::client (
  $ossec_active_response=true,
  $ossec_server_ip
) inherits ossec::params {
  include ossec::common
  include ossec::post_install_workarounds

  Class['Ossec::Client'] -> Class['Ossec::Post_Install_Workarounds']

  # install package
  package { $hidsclientpackage : ensure => $ossec_version, require => Exec["setup-ossec-pkg-install"] }
  
  file { "/etc/init.d/${hidsserverservice}":
    ensure  => present,
    content => template('ossec/ossec-control-client.sh.erb'),
    mode    => 0755,
    require => Package[$hidsclientpackage]
  }

  service { $hidsclientservice:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => File["/etc/init.d/${hidsserverservice}"],
  }

  # Removed shared agent config, should be set on server not client
  file { "${install_home}/etc/shared/agent.conf" : ensure => absent }
  
  concat { '/var/ossec/etc/ossec.conf':
    owner => root,
    group => ossec,
    mode => 0440,
    require => Package[$hidsclientpackage],
    notify => Service[$hidsclientservice]
  }

  concat::fragment { "ossec.conf_10" :
    target => '/var/ossec/etc/ossec.conf',
    content => template("ossec/10_ossec_agent.conf.erb"),
    order => 10,
    notify => Service[$hidsclientservice]
  }
  
  concat::fragment { "ossec.conf_99" :
    target => '/var/ossec/etc/ossec.conf',
    content => template("ossec/99_ossec_agent.conf.erb"),
    order => 99,
    notify => Service[$hidsclientservice]
  }

  file { "/var/ossec/etc/client.keys":
    ensure  => file,
    owner   => "root",
    group   => "ossec",
    mode    => "640",
    notify  => Service[$hidsclientservice],
    require => Package[$ossec::common::hidsclientpackage]
  }

  #concat { "/var/ossec/etc/client.keys":
  #  owner   => "root",
  #  group   => "ossec",
  #  mode    => "640",
  #  notify  => Service[$hidsclientservice],
  #  require => Package[$ossec::common::hidsclientpackage]
  #}
  #ossec::agentKey{ "ossec_agent_${hostname}_client": agent_id=>$uniqueid, agent_name => $hostname, agent_ip_address => $agent_ip}
  #@@ossec::agentKey{ "ossec_agent_${hostname}_server": agent_id=>$uniqueid, agent_name => $hostname, agent_ip_address => $agent_ip}
}


