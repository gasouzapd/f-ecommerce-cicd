#!/usr/bin/env bash
# exit when any command fails
set -e

APPNAME="ecommerceappcursogpdev"

cd ../src
func azure functionapp publish $APPNAME