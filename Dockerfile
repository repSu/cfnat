FROM alpine:latest
LABEL Name=cfnat Version=0.0.1

RUN apk add --no-cache bash

ENV HOME=/root
WORKDIR $HOME/cfnat
COPY cfnat ./cfnat
COPY start.sh ./start.sh
COPY ips-v4.txt ./conf/ips-v4.txt
COPY ips-v6.txt ./conf/ips-v6.txt
COPY cfnat.conf ./conf/cfnat.conf
COPY locations.json ./conf/locations.json

RUN chmod +x ./cfnat
RUN chmod +x ./start.sh

CMD ["/bin/bash","./start.sh"]