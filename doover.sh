#!/usr/bin/env bash

sudo rm -R ~/data_infrastructure/
sudo -u postgres psql -c 'drop database hackoregon'