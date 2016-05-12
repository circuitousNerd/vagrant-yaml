node /default/ {

}

node /puppet/ {

  package { 'puppetserver':
    ensure => 'latest',
  }

  service { 'puppetserver':
    enable => true,
    ensure => running,
  }

  Package['puppetserver']
  -> Service['puppetserver']
}
