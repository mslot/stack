storage "consul" {
  address = "consul-client-0:8500"
  path    = "vault"
}

listener "tcp" {
  address     = "127.0.0.1:8220"
  tls_disable = 1
}