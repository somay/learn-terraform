#!/bin/bash
echo "${server_text}" > index.html
nohup busybox httpd -f -p ${server_port} &
