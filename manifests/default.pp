node default {
  package { ['vim-enhanced', 'htop', 'epel-release]:
    ensure => latest,
  }
}
