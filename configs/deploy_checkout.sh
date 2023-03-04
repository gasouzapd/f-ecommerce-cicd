#!/usr/bin/env bash
# exit when any command fails
set -e

APPNAME="ecommerceappcursogpd"

cd ../src
func azure functionapp publish $APPNAME