class ossec::common inherits ossec::params {
  if (!defined(File['/opt'])) {
    file { "/opt":
      ensure => directory
    }
  }

  # Configure yum repo
  exec { "setup-ossec-pkg-install" :
    command => "wget -q -O - https://www.atomicorp.com/installers/atomic |sh",
    path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    unless  => "test -f /etc/yum.repos.d/atomic.repo",
  }

  package { $hidspackage : ensure => $ossec_version, require => Exec["setup-ossec-pkg-install"] }

  case $osfamily {
    'RedHat' : {
      package { 'inotify-tools': ensure=>present}
      if (!defined(File['/opt/rpm'])) {
        file { "/opt/rpm":
          ensure => directory
        }
      }
    }
    default : { fail("This ossec module has not been tested on your distribution") }
  }
}

