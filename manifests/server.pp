class ossec::server (
  $mailserver_ip,
  $ossec_emailfrom = "ossec-${hostname}@${domain}",
  $ossec_emailto,
  $ossec_active_response = true,
  $ossec_global_host_information_level = 8,
  $ossec_global_stat_level=8,
  $ossec_email_alert_level=7,
  $ossec_ignorepaths = [],
  $syscheck_frequency = '79200'
  ) inherits ossec::params {
  include ossec::common
  include ossec::post_install_workarounds
  include concat::setup
  include mysql

  Class['Ossec::Common'] -> Class['Ossec::Server']
  Class['Ossec::Server'] -> Class['Ossec::Post_Install_Workarounds']
	
  # install package
  package { $hidsserverpackage : ensure => installed, require => Exec["setup-ossec-pkg-install"] }

  file { "/etc/init.d/${hidsserverservice}":
    ensure  => present,
    content => template('ossec/ossec-control.sh.erb'),
    mode    => 0755,
    require => Package[$hidsserverpackage]
  }

  service { $hidsserverservice:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => File["/etc/init.d/${hidsserverservice}"],
  }

  # configure ossec
  concat { '/var/ossec/etc/ossec.conf':
    owner => root,
    group => ossec,
    mode => 0440,
    require => Package[$hidsserverpackage],
    notify => Service[$hidsserverservice]
  }

  concat::fragment { "ossec.conf_10" :
    target => '/var/ossec/etc/ossec.conf',
    content => template("ossec/10_ossec.conf.erb"),
    order => 10,
    notify => Service[$hidsserverservice]
  }

  #	Concat::Fragment <<| tag == 'ossec' |>>

  concat::fragment { "ossec.conf_90" :
    target => '/var/ossec/etc/ossec.conf',
    content => template("ossec/90_ossec.conf.erb"),
    order => 90,
    notify => Service[$hidsserverservice]
  }

  #concat { "/var/ossec/etc/client.keys":
  #  owner   => "root",
  #  group   => "ossec",
  #  mode    => "640",
  #  notify  => Service[$hidsserverservice]
  #}

  #Ossec::AgentKey<<| |>>

  #concat::fragment { "var_ossec_etc_client.keys_end" :
  #  target  => "/var/ossec/etc/client.keys",
  #  order   => 99,
  #  content => "\n",
  #  notify => Service[$hidsserverservice]
  #}

}
