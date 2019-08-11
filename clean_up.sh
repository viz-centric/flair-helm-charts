echo "[INFO] Removing Flair Services"

for service in $(helm ls --namespace flair -q);
do
    echo "[INFO] Deleting Flair Service: ${service}";
    helm delete ${service} --purge;
done

echo "[INFO] All services sucessfully deleted!"
kubectl delete ns flair

echo "[INFO] Cleaned up everything sucessfully!"
