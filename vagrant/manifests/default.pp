Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

include system-update

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
Exec["apt-update"] -> Package <| |>

class { 'openldap::server':
  databases => {
    'dc=megaldap,dc=com' => {
      ensure => present,
      rootdn    => 'cn=admin,dc=megaldap,dc=com',
      rootpw    => '{SSHA}LMhUx6cKrXXCv9RHHvjkUhrSJGJQeJbm',
    }
  }
}

class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=megaldap,dc=com',
  ldap_bind_id   => 'cn=admin,dc=megaldap,dc=com',
  ldap_bind_pass => 'bigboss123',
}
->
exec { "phpldapadmin-fix":
    command => "sudo sed -i 's/password_hash/password_hash_custom/' /usr/share/phpldapadmin/lib/TemplateRender.php"
}

file { ["/srv/pictures/", "/srv/pictures/testfile"]:
    ensure => "directory",
    owner  => "nobody",
    group  => "nogroup",
    mode   => 666,
}

class { '::samba::server':
  workgroup            => 'megaldap',
  server_string        => 'megaldap.com Samba Server',
  netbios_name         => 'F01',
  interfaces           => [ 'lo', 'eth0' ],
  hosts_allow          => [ '127.', '192.168.', '10.' ],
  local_master         => 'yes',
  map_to_guest         => 'Bad User',
  os_level             => '50',
  preferred_master     => 'yes',
  extra_global_options => [
    'printing = BSD',
    'printcap name = /dev/null',
  ],
  shares => {
    'homes' => [
      'comment = Home Directories',
      'browseable = no',
      'writable = yes',
    ],
    'pictures' => [
      'comment = Pictures',
      'path = /srv/pictures',
      'browseable = yes',
      'writable = yes',
      'guest ok = yes',
      'available = yes',
    ],
  },
  selinux_enable_home_dirs => true,
  ldap_suffix              => 'dc=megaldap,dc=com',
  ldap_url                 => 'localhost',
  ldap_ssl                 => 'off',
  ldap_admin_dn            => 'cn=admin,dc=megaldap,dc=com',
  ldap_admin_dn_pwd        => 'bigboss123',
  ldap_group_suffix        => 'groups',
  ldap_machine_suffix      => 'machines',
  ldap_user_suffix         => 'users',
}
