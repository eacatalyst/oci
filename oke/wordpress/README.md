WORDPRESS Example on Oracle Cloud Infrastructure

The example creates wordpress application with a mysql backend.

Pre-requisites: OKE Cluster in OCI with basic setup of Networking infrastructure. 

1. Creates two PVC (50GB) each for wordpress and mysql pods
2. Creates a mysql deployment and attaches the block volume with the pod hosts.
3. Creates a wordpress deployment and attaches the block volume with the pod hosts.
4. Creates a mysql service (type clusterIP) and a wordpress service (type LoadBalancer). 

Access the wordpress application on the external IP for that service. 
