apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca_path}
    server: https://${kub_public_add}:443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: system:kube-proxy
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: system:kube-proxy
  user:
    client-certificate-data: ${kube_proxy_c_path}
    client-key-data: ${kube_proxy_k_path}