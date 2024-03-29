# These are the usual GKE variables.
PROJECT       ?= prow-clarketm
ZONE          ?= us-west1-a
CLUSTER       ?= prow

.PHONY: get-cluster-credentials
get-cluster-credentials:
	CLOUDSDK_CONTAINER_USE_CLIENT_CERTIFICATE=True gcloud container clusters get-credentials "$(CLUSTER)" --project="$(PROJECT)" --zone="$(ZONE)"

.PHONY: update-deployment
update-deployment: get-cluster-credentials
	kubectl apply -f ./starter_after.yaml

.PHONY: update-plugins
update-plugins: get-cluster-credentials
	kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml --dry-run -o yaml | kubectl replace configmap plugins -f -

.PHONY: update-config
update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -
