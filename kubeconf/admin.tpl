apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca_path}
    server: https://127.0.0.1:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: admin
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: ${admin_c_path}
    client-key-data: ${admin_k_path}