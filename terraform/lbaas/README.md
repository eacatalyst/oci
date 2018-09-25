
This example demonstrates round robin load balancing behavior by creating two instances, a configured
vcn and a load balancer. A webserver is setup on the two instances. 

The public IP of the load balancer is outputted after a successful run.

Curl this address to see the hostname change as different instances handle the request.

NOTE: The https listener is included for completeness but should not be expected to work, it uses dummy certs.
