FROM alpine AS build

WORKDIR /home

RUN wget https://github.com/nats-io/nats-server/releases/download/v2.2.3/nats-server-v2.2.3-linux-amd64.zip -O nats-server.zip
RUN wget https://github.com/fatedier/frp/releases/download/v0.36.2/frp_0.36.2_linux_amd64.tar.gz -O frp.tar.gz
RUN wget https://github.com/erebe/wstunnel/releases/download/v3.0/wstunnel-x64-linux.zip -O wstunnel.zip

RUN unzip nats-server.zip
RUN unzip wstunnel.zip
RUN tar -xvf frp.tar.gz

RUN cp nats-server-v2.2.3-linux-amd64/nats-server /usr/bin/
RUN cp wstunnel /usr/bin/
RUN cp frp_0.36.2_linux_amd64/frps /usr/bin/
RUN chmod +x /usr/bin/nats-server
RUN chmod +x /usr/bin/wstunnel
RUN chmod +x /usr/bin/frps

FROM alpine

RUN apk add --no-cache nginx openssh-server
RUN mkdir -p /run/nginx

COPY --from=build /usr/bin/nats-server /bin/
COPY --from=build /usr/bin/wstunnel /bin/
COPY --from=build /usr/bin/frps /bin/

COPY zaue /bin/
RUN chmod +x /bin/zaue

CMD zaue
