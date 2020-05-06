# Flair GCP Deployment 

## Autenticate with Google Cloud

```sh
-> gcloud auth login
```

## Platform Setup

### Cloud SQL Postrges

#### Create Postgres database
```sh
-> gcloud sql instances create staging-pg-config \
  --project flair-staging \
  --database-version=POSTGRES_11 \
  --tier=db-g1-small \
  --zone=us-central1-a \
  --root-password=admin \
  --storage-type=SSD \
  --storage-size=20 \
  --availability-type=zonal \
  --assign-ip \
  --no-backup
  
-> gcloud beta sql instances create staging-pg-config-private \
  --project flair-staging \
  --database-version=POSTGRES_11 \
  --tier=db-g1-small \
  --zone=us-central1-a \
  --root-password=admin \
  --storage-type=SSD \
  --storage-size=20 \
  --availability-type=zonal \
  --network=default \
  --no-assign-ip \
  --no-backup
```

> **Note**: Manually, disable Public access and enable private access so that a `Private IP` is assigned to the instance. This `IP` needs to be used for connecting to the instance from `GKE`.


> You can now go ahead and create databases needed for `Flair` to run. (i.e `flairbi`, `flairengine`, `flairnotify`)

### GKE cluster

#### Create GKE Cluster
```sh
-> gcloud beta container clusters create "staging" \
  --project "flair-staging" \
  --region "us-central1" \
  --no-enable-basic-auth \
  --cluster-version "1.15.11-gke.9" \
  --machine-type "n1-standard-2" \
  --image-type "COS" \
  --disk-type "pd-ssd" \
  --disk-size "10" \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/cloud-platform" \
  --preemptible \
  --num-nodes "3" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --network "projects/flair-staging/global/networks/default" \
  --subnetwork "projects/flair-staging/regions/us-central1/subnetworks/default" \
  --default-max-pods-per-node "110" \
  --no-enable-master-authorized-networks \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing \
  --enable-autoupgrade \
  --enable-autorepair \
  --node-locations "us-central1-c"
```

#### Get Kubeconfig
```sh
-> gcloud beta container clusters get-credentials staging --region us-central1
```

#### Create a Static IP
```sh
-> gcloud compute addresses create flair-bi-cloud --region us-central1
```

#### Check Nodes & Labels
```sh
-> kubectl get nodes -L cloud.google.com/gke-preemptible -L beta.kubernetes.io/instance-type -L failure-domain.beta.kubernetes.io/zone

NAME                                     STATUS   ROLES    AGE   VERSION          GKE-PREEMPTIBLE   INSTANCE-TYPE   ZONE
gke-staging-default-pool-b70979c5-84p2   Ready    <none>   23m   v1.15.11-gke.9   true              n1-standard-2   us-central1-c
gke-staging-default-pool-b70979c5-hqkn   Ready    <none>   23m   v1.15.11-gke.9   true              n1-standard-2   us-central1-c
gke-staging-default-pool-b70979c5-tdsk   Ready    <none>   23m   v1.15.11-gke.9   true              n1-standard-2   us-central1-c
```

#### Deploy Flair BI

##### Clone [Flair Helm Charts](https://github.com/viz-centric/flair-helm-charts)
```sh
-> git clone https://github.com/viz-centric/flair-helm-charts.git
```

##### Install Flair PLatform
```sh
-> ./flair-helm-charts/setup-gcp.sh
```

#### Run Data Generator
```sh
-> kubectl apply -f ./tools/data-generator.yaml -n flair
```

## Tear down

### Stop Data Generator
```sh
-> kubectl delete pod flair-data-generator -n flair
```

### Clean up Flair Platform
```sh
-> ./flair-helm-charts/clean_up.sh
```

### Delete GKE Cluster
```sh
-> gcloud container clusters delete staging --region us-central1
```

#### Delete Static IP
```sh
-> gcloud compute addresses delete flair-bi-cloud --region us-central1
```

### Delete Postgres database
```sh
-> gcloud sql instances delete staging-pg-instance # --async
```
