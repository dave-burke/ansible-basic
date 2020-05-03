#!/bin/bash

do-resize.sh dropy s-1vcpu-3gb
ssh -i ~/.ssh/id_rsa_minecraft dropy docker start minecraft

