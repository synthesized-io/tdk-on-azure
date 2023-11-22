Status: draft.

# Overview

A repository for the configuration files required to deploy the Synthesized TDK offer on Azure Marketplace.

# Deployment

Overall, the process of deployment is the following:

- Create a CNAB bundle (docker image).
- Update the technical configuration in the Partner Center.
- Submit the offer in the Partner Center.

## Creating the CNAB

Microsoft requires that the product is packaged in a special docker image called CNAB bundle.

In order to create the CNAB bundle, follow the steps below:

```bash
docker run --rm -it -v $(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock --name cpa-tool mcr.microsoft.com/container-package-app:latest bash
```

Inside the container:

```bash
# cd into the mounted directory
cd app
# log in to azure shell
az login
# log in docker
az acr login --name tdkk8soffer
# verify our configuration files are in order
cpa verify
# build and publish the CNAB bundle
cpa buildbundle
```

The repository, which contains those docker images is [here](https://portal.azure.com/#@synthesized.io/resource/subscriptions/afcb3cac-e3ff-4a76-b540-39bc6b77ee80/resourceGroups/tdk-k8s-offer/providers/Microsoft.ContainerRegistry/registries/tdkk8soffer/overview). The resulting CNAB bundle will with the `tdkk8soffer.azurecr.io/com.synthesized.tdk:x.x.x` tag.

## Update technical configuration

Browser requirement: Chromium 119+ (does not work in Firefox for some reason).

The link to our offer: [link](https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/d2da9e3f-fcf7-4950-9579-401d67364491/overview).

Inside that offer, you'll see two plans:

- BYOL (bring your own licence plan)
- Usage-based (using Microsoft metering API)

Follow to the plan you want to update; on the left, click the "Technical configuration" link, "add CNAB bundle". Select the `tdkk8soffer` registry, `com.synthesized.tdk` repository and the required image tag. Hit "Save".

## Submit the offer

At the top of the page, you'll see "Review and Publish" button.

The validation takes up to 48 hours, but may take less on subsequent submissions.
