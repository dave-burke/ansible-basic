#!/bin/bash

ssh -i ~/.ssh/id_rsa_minecraft dropy docker stop minecraft
do-resize.sh dropy s-1vcpu-1gb

