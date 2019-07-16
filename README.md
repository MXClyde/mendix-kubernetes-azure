

# Mendix on Azure Kubernetes Service

This how-to outlines how to deploy a scalable, production-ready Kubernetes cluster for hosting Mendix apps on Microsoft Azure. The solution includes all components necessary to succesfully build and operate Mendix apps on Azure and consists of the following components:

![Mendix on Azure](mendixazure.png)

## Features of the solution:

- Host Mendix apps in a secure, scalable and managed environment.
- Utilize standard Azure services to ensure cost-effectiveness
- Utilize Azure  DevOps for automated deployments, fully in control of your team

## How to deploy

### Prerequisites

- Account with Owner role assignment on the target Azure Subscription.


### Deploying Container Platform (Azure Kubernetes Service)

The Mendix apps will run in Docker containers which will be orchestrated using Kubernetes. For this purpose we are going to deploy Azure Kubernetes Service, which will provide us with a managed Kubernetes cluster to host our app containers.

#### Deploying Azure Kubernetes Service

1. Sign in to the Azure Portal (https://portal.azure.com).
2. Start the wizard to create an Azure Kubernetes Service.
3. Fill out the basic information:
   * **When choosing node size:** keep in mind that Mendix containers typically need relatively more memory vs. CPU. So choosing instance sizes with a higher memory to CPU ratio tends to be more cost efficient (e.g. E2s_v3).
![Create Kubernetes cluster](images/createkubernetes.png)
4. Fill out the authentication information:
   * **With regards to enabling RBAC:** Role-Based Access Control (RBAC) allows you to define security roles within the cluster and assign different cluster permissions to different groups of users, enabling this is required in order to run a secure cluster.
![Authentication options](images/authenticationk8s.png)
5. Fill out the network information:
   * **HTTP Application routing:** we disable this as we will deploy an NGINX ingress controller that supports HTTPS later.
   * **Network configuration:** we will select Basic to deploy to a newly created publicly accessible VNet. Specifying an Advanced network configuration is required when we want to deploy to a custom VNet (e.g. a VNet routable over an ExpressRoute).
![Networking options](images/networkingkubernetes.png)
 6. Fill out the monitoring information
   * Enable this to use the built-in cluster monitoring features of Azure.
![Monitoring options](images/monitoringk8s.png)
 7. Optionally, fill out tags (e.g. for cost tracking)
 8. Confirm your choices to start deployment of the cluster

#### Connecting to the Kubernetes cluster

1. After the deployment of the Kubernetes Service,  a resource group will have been created containing the cluster object:


![Monitoring options](images/clusterobject.png) 

2. [Open the Kubernetes Dashboard](https://docs.microsoft.com/nl-nl/azure/aks/kubernetes-dashboard) 
3. The cluster has been deployed successfully and can be managed from your workstation!

## Known issues 


## Support 


## Roadmap
