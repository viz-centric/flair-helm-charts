#!/bin/bash

set -e

echo "[INFO] Sinking charts";
gsutil -m rsync -d -r gs://flair-platform ./.charts

for chart in flair-bi flair-cache flair-engine flair-notifications flair-registry flair-couchdb/couchdb;
do
    echo "[INFO] Packaging chart: ${chart}";
    helm package $chart -d .charts
done

echo "[INFO] Finished packaging all charts";

echo "[INFO] Indexing all charts";
helm repo index .charts/ --url https://flair-platform.storage.googleapis.com
echo "[INFO] Indexing finished";

echo "[INFO] Publishing charts";
gsutil -m rsync -d -r ./.charts gs://flair-platform
echo "[INFO] Publishing Finished";

echo "[INFO] All Done";
