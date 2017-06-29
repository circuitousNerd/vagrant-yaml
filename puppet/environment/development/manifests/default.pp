class base {
  package { ['epel-release', 'vim-enhanced', 'htop', 'nmap', 'git']:
    ensure => latest,
  }

  exec { 'network_restart':
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    command => 'systemctl restart network'
  }

  service { 'firewalld':
    ensure => 'stopped',
    enable => false,
  }

  Package['epel-release'] -> Package <| title != 'epel-release' |>
}

node /default/ {
  require base
}

node /puppetmaster/ {
  require base

  package { 'puppetserver':
    ensure => 'latest',
  }

  service { 'puppetserver':
    enable => true,
    ensure => running,
  }

  class { 'consul':
    config_hash => {
      'data_dir'       => '/opt/consul',
      'datacenter'     => 'vagrant',
      'log_level'      => 'INFO',
      'node_name'      => $facts['hostname'],
      'retry_join'     => ['vault01', 'vault02', 'vault03'],
      'advertise_addr' => {
        'serf_lan' => "${facts['ipaddress_enp0s8']}:8301",
        'rpc'      => "${facts['ipaddress_enp0s8']}:8300",
      },
    }
  }

  consul::service { 'puppetserver':
    checks => [
      {
        script   => 'systemctl status puppetserver',
        interval => '10s',
      }
    ],
    tags   => ['puppet']
  }

  Package['puppetserver']
  -> Service['puppetserver']
}

node /vault/ {
  $vault_version = '0.7.3'
  $vault_extract_path = '/opt/vault'
  $vault_path = '/usr/local/bin/vault'
  $test_vault_cmd = "test -f ${vault_path}"
  require base
  include ::archive

  package { 'unzip':
    ensure => 'latest',
  }

  # Terrible hack to work around the idempotency of a file resource
  # Test the return code of vault -v; if not 0 then vault hasn't been downloaded
  # and we need to download it. Otherwise all is well and we don't need to
  # redownload it.

  exec { 'test-vault-binary':
    path    => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin','/usr/local/sbin'],
    command => 'true',
    unless  => $test_vault_cmd,
    tag     => ['vault'],
  }

  file { 'download-vault-binary':
    source => "https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip",
    path   => "/tmp/vault_${vault_version}_linux_amd64.zip",
    tag      => ['vault'],
  }

  exec { 'unzip-vault-binary':
    path    => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin','/usr/local/sbin'],
    command => "unzip -u /tmp/vault_${vault_version}_linux_amd64.zip -d ${vault_extract_path}",
    unless  => $test_vault_cmd,
    tag     => ['vault'],
  }

  file { 'symlink-vault-binary':
    ensure => 'link',
    target   => "${vault_extract_path}/vault",
    path => $vault_path,
    tag    => ['vault'],
    force  => true,
  }

  class { '::consul':
    config_hash => {
      'bootstrap_expect' => 3,
      'client_addr'      => '0.0.0.0',
      'ui_dir'           => '/opt/consul/ui',
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'vagrant',
      'log_level'        => 'INFO',
      'node_name'        => $facts['hostname'],
      'server'           => true,
      'addresses'        => {
        'http'  => $facts['ipaddress_enp0s8'],
        'https' => $facts['ipaddress_enp0s8'],
        'dns'   => $facts['ipaddress_enp0s8'],
      },
      'advertise_addr'   => $facts['ipaddress_enp0s8'],
      'retry_join'       => ['vault01', 'vault02', 'vault03'],
    }
  }

  consul::service { 'puppetserver':
    checks => [
      {
        script   => '/usr/bin/true',
        interval => '10s',
      }
    ],
    tags   => ['vault']
  }

  Package['unzip']
  -> Exec['test-vault-binary']
  ~> File['download-vault-binary']
  ~> Exec['unzip-vault-binary']
}
