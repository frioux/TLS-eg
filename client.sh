#!/bin/dash

curl --cert web.pem --key web.key --cacert rootCA.pem https://localhost:8000/serial
