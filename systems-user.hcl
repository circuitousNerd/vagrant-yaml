path "secret/*" {
  policy = "write"
}

path "sys/*" {
  policy = "sudo"
}

path "auth/*" {
  policy = "sudo"
}
