#!/bin/bash

echo "[INFO] Creating Namespace 'Flair'"
kubectl create ns flair

echo "[INFO] Installing Flair Registry"
helm upgrade \
    --install \
    --wait \
    --namespace flair \
    flair-registry ./flair-registry

echo "[INFO] Installing Postgres for Flair Engine"
helm upgrade \
    --install \
    --wait \
    --namespace flair \
    --values ./flair-postgres/flair-engine.yaml \
    flair-engine-pg stable/postgresql

echo "[INFO] Installing Flair Engine"
helm upgrade \
    --install \
    --wait \
    --namespace flair \
    flair-engine ./flair-engine

echo "[INFO] Installing Flair Cache"
helm upgrade \
    --install \
    --wait \
    --namespace flair \
    flair-cache ./flair-cache

echo "[INFO] Installing Postgres for Flair BI"
helm upgrade \
    --install \
    --wait \
    --namespace flair \
    --values ./flair-postgres/flair-bi.yaml \
    flair-bi-pg stable/postgresql

echo "[INFO] Installing CouchDb for Flair BI"
helm upgrade \
    --install \
    --wait \
    --namespace flair \
    --values ./flair-couchdb/values.yaml \
    flair-couchdb incubator/couchdb

echo "[INFO] Installing Flair BI"
helm upgrade \
    --install \
    --wait \
    --namespace flair flair-bi ./flair-bi

echo "[INFO] All services sucessfully installed"
