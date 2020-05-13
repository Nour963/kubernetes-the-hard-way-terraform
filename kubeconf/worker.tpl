apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca_path}
    server: https://${kub_public_add}:443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: system:node:${node}
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: system:node:${node}
  user:
    client-certificate-data: ${node_c_path}
    client-key-data: ${node_k_path}