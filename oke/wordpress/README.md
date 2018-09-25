# Wordpress on Oracle Container Engine for Kubernetes (OKE)

## The example creates wordpress app with a mysql backend.

Pre-requisites: OKE Cluster in Oracle Cloud Infrastructure (OCI) with basic setup of networking infrastructure. 

1. Creates two PVC (50GB) each for wordpress and mysql pods
2. Creates a mysql deployment and attaches the block volume with the pod hosts.
3. Creates a wordpress deployment and attaches the block volume with the pod hosts.
4. Creates a mysql service (type clusterIP) and a wordpress service (type LoadBalancer). 

Access the wordpress application on the external IP for that service. 
