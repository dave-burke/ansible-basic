#!/bin/bash

do-resize.sh dropy s-1vcpu-3gb
sleep 10 # wait for startup
ssh -i ~/.ssh/id_rsa_minecraft dropy docker start minecraft

