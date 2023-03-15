#!/usr/bin/env bash
# exit when any command fails
set -e

TENANT="9ca31f09-77b5-4af1-b805-503fb3013f7e"
SUBSCRIPTION="8561c07f-06d7-47b5-8f1f-565c7c802da9"
LOCATION="westeurope"
RESOURCEGROUP="estudos"

do_login()
{
    echo "Start Login"
    subscriptionId="$(az account list --query "[?isDefault].id" -o tsv)"
    if [ $subscriptionId != $SUBSCRIPTION ]; then
        az login --tenant $TENANT
        az account set --subscription $SUBSCRIPTION
    fi
    echo "End Login"
}

do_resource_group()
{
    echo "Checking Resource Groups"
    if [ $(az group exists --name $RESOURCEGROUP) = false ]; then
        az group create --name $RESOURCEGROUP --location $LOCATION
    fi
    echo "End Resource Group"
}

do_function_app()
{
    echo "Start Function App"
    az deployment group create \
    --name CheckoutFunctionApp \
    --resource-group $RESOURCEGROUP \
    --template-file azuredeploy.json \
    --parameters azuredeploy.parameters.json \
    --verbose
    echo "End function App"
}

main()
{
    do_login
    do_resource_group
    do_function_app
}

# Start
main
# End