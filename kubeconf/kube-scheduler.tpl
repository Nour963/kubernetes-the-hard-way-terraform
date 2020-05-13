apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca_path}
    server: https://127.0.0.1:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: system:kube-scheduler
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: system:kube-scheduler
  user:
    client-certificate-data: ${kube-scheduler_c_path}
    client-key-data: ${kube-scheduler_k_path}