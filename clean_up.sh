echo "[INFO] Removing Flair Services"

for service in $(helm ls --namespace flair -q);
do
    echo "[INFO] Deleting Flair Service: ${service}";
    helm delete ${service} -n flair;
done

echo "[INFO] All services successfully deleted!"
kubectl delete ns flair

echo "[INFO] Cleaned up everything successfully!"
