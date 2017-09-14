class base {
  package { ['epel-release', 'vim-enhanced', 'htop', 'nmap', 'git']:
    ensure => latest,
  }

   service { 'firewalld':
     ensure => stopped,
     enable => false,
   }

  Package['epel-release'] -> Package <| title != 'epel-release' |>
}

node /default/ {
  require base
}
