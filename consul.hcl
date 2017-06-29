storage "consul" {
  address = "10.100.0.11:8500"
  path = "vault"
}

listener "tcp" {
 address = "10.100.0.11:8200"
 tls_disable = 1
}
