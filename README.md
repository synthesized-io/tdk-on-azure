# Overview

A repository for the configuration files required to deploy the Synthesized TDK offer on Azure Marketplace.

# Deployment Process

Overall, the process of deployment is the following:

- Create a CNAB bundle (docker image).
- Update the technical configuration in the [Partner Center](https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/d2da9e3f-fcf7-4950-9579-401d67364491/overview).
- Submit the offer in the Partner Center for review.
- Submit the offer in the Partner Center for production.

## Automated deployment

1. Navigate to the [Publish Draft version](https://github.com/synthesized-io/tdk-on-azure/actions/workflows/publish-draft-version.yaml) GHA workflow
1. Run the workflow, specifying the required TDK version
1. Verify that the workflow passes successfully.
1. Wait for both automatic and manual validations to complete, which can take up to 48 hours.
1. Access the [Partner Center](https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/d2da9e3f-fcf7-4950-9579-401d67364491/overview)
1. Once validation is successful, proceed to click the "Go Live" button.

You can learn more about used API [here](https://learn.microsoft.com/en-us/partner-center/marketplace/product-ingestion-api#configuration-requests)

## Manual deployment

In case the automated deployment isn't feasible, the manual deployment option is available.

### Creating the CNAB

Microsoft mandates packaging the product in a specific Docker image format known as CNAB bundle. Follow these steps:

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

The repository containing these Docker images can be found [here](https://portal.azure.com/#@synthesized.io/resource/subscriptions/afcb3cac-e3ff-4a76-b540-39bc6b77ee80/resourceGroups/tdk-k8s-offer/providers/Microsoft.ContainerRegistry/registries/tdkk8soffer/overview). The resulting CNAB bundle will with the `tdkk8soffer.azurecr.io/com.synthesized.tdk:x.x.x` tag.

### Update technical configuration

Browser requirement: Chromium 119+ (does not work in Firefox for some reason).

The link to our offer: [link](https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/d2da9e3f-fcf7-4950-9579-401d67364491/overview).

Within the offer, you'll find two plans:

- [Bring your own license](https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/d2da9e3f-fcf7-4950-9579-401d67364491/plans/a782a5a4-5b0e-41c1-a4ea-3b08b8287652/listings)
- [Pay-as-you-go](https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/d2da9e3f-fcf7-4950-9579-401d67364491/plans/2f65f546-c98b-4579-8bae-eb5e3bf6f898/listings)

Select the plan you wish to update, click on "Technical Configuration" on the left panel, then "add CNAB bundle." Choose the `tdkk8soffer` registry, `com.synthesized.tdk` repository, and the required image tag. Save your changes.

### Submit the offer for review

Click on the "Review and Publish" button at the top of the page. Validation may take up to 48 hours but could be faster for subsequent submissions.

### Submit the offer for production

Once validation is successful, click the "Go Live" button to initiate the production deployment.
