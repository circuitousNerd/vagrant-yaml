class base {
  package { ['epel-release', 'vim-enhanced', 'htop', 'nmap', 'git']:
    ensure => latest,
  }

  exec { 'network_restart':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    command => 'systemctl restart network'
  }

  Package['epel-release'] -> Package <| title != 'epel-release' |>
}

node /default/ {
  require base
}
