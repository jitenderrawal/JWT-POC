#!/bin/bash

sudo -i -u postgres pg_dump -h stg-ibmhpgdb1.internetbrands.com mh -U mhadmin -Fc | sudo -i -u postgres pg_restore -d mh
