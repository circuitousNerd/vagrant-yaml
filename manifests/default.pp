node default {
  package { ['vim', 'htop']:
    ensure => latest,
  }