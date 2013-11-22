class ossec::post_install_workarounds inherits ossec::params {
  exec { "fix-ar-perms":
    command => "chgrp ${group} ${install_home}/etc/shared/ar.conf",
    path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    onlyif  => "test -f ${install_home}/etc/shared/ar.conf"
  }
}