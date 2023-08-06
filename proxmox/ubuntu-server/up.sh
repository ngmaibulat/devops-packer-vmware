#!/bin/bash

packer init .

packer build -var-file=secrets.hcl main.pkr.hcl
