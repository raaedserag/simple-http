resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "ssh_key" {
  filename = "eks-nodes.pem"
  content  = tls_private_key.key_pair.private_key_pem
}
