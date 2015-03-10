Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

include system-update

class { 'openldap::server':
  databases => {
    'dc=megaldap,dc=com' => {
      ensure => present,
      rootdn    => 'cn=root,dc=megaldap,dc=com',
      rootpw    => '{SSHA}LMhUx6cKrXXCv9RHHvjkUhrSJGJQeJbm',
    }
  }
}
