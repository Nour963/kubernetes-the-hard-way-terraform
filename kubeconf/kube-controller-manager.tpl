apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca_path}
    server: https://127.0.0.1:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: system:kube-controller-manager
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: system:kube-controller-manager
  user:
    client-certificate-data: ${kube-controller-manager_c_path}
    client-key-data: ${kube-controller-manager_k_path}