#!/bin/bash

echo "[INFO] Creating Namespace 'Flair'"
kubectl create ns flair

echo "[INFO] Installing Flair Registry"
helm upgrade \
    --install \
    --values ./gcp/flair-registry.yaml \
    --wait \
    --namespace flair \
    flair-registry ./flair-registry

echo "[INFO] Installing Flair Engine"
helm upgrade \
    --install \
    --values ./gcp/flair-engine.yaml \
    --wait \
    --namespace flair \
    flair-engine ./flair-engine

echo "[INFO] Installing Flair Cache"
helm upgrade \
    --install \
    --values ./gcp/flair-cache.yaml \
    --wait \
    --namespace flair \
    flair-cache ./flair-cache

echo "[INFO] Installing CouchDb for Flair BI"
helm upgrade \
    --install \
    --values ./gcp/flair-couchdb.yaml \
    --wait \
    --namespace flair \
    flair-couchdb ./flair-couchdb/couchdb

echo "[INFO] Installing Flair BI"
helm upgrade \
    --install \
    --values ./gcp/flair-bi.yaml \
    --wait \
    --namespace flair flair-bi ./flair-bi

echo "[INFO] Installing Flair Notifications"
helm upgrade \
    --install \
    --values ./gcp/flair-notifications.yaml \
    --wait \
    --namespace flair \
    flair-notifications ./flair-notifications

echo "[INFO] All services sucessfully installed"
