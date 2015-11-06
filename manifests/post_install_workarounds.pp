class ossec::post_install_workarounds inherits ossec::params {
  $ar_conf = "${install_home}/etc/shared/ar.conf"
  exec { "fix-ar-perms":
    command => "chgrp ${group} $ar_conf",
    path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    onlyif  => "test -f $ar_conf && test $(stat -c '%G' $ar_conf) != '${group}'"
  }
}
