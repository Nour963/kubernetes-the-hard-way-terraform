kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=./certificate/ca.pem \
  --embed-certs=true \
  --server=https://${kub_public_add}:443

kubectl config set-credentials admin \
  --client-certificate=./certificate/admin.pem \
  --client-key=./certificate/admin-key.pem

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context kubernetes-the-hard-way
