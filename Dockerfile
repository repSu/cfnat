FROM alpine:latest
LABEL Name=cfnat Version=0.0.1

RUN apk add --no-cache bash

WORKDIR /root/cfnat
COPY cfnat /root/cfnat/cfnat
COPY start.sh /root/cfnat/start.sh

RUN chmod +x /root/cfnat/cfnat
RUN chmod +x /root/cfnat/start.sh

CMD ["/bin/bash","./start.sh"]