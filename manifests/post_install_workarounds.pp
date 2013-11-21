class ossec::post_install_workarounds inherits ossec::params {
	file { "${install_home}/etc/shared/ar.conf" :
		ensure => file,
		owner  => 'root',
		group  => $group,
		mode   => 0440
	}
}