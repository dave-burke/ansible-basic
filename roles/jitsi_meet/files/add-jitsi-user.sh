#!/bin/bash

set -e

cd /compose

docker-compose exec prosody prosodyctl --config /config/prosody.cfg.lua register ${1} meet.jitsi "${2}"

