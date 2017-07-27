FROM qnib/alplain-golang

ENV BURROW_ZK_HOST=zookeeper \
    BURROW_LOGFILE=/var/log/burrow/burrow.log
VOLUME ["/var/log/burrow"]


ENV PATH $GOPATH/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN apk add --no-cache curl bash git ca-certificates wget \
 && update-ca-certificates \
 && curl -sSO https://raw.githubusercontent.com/pote/gpm/v1.4.0/bin/gpm \
 && chmod +x gpm \
 && mv gpm /usr/local/bin
RUN go get github.com/klauspost/crc32
RUN git clone https://github.com/linkedin/Burrow.git $GOPATH/src/github.com/linkedin/Burrow \
 && cd  $GOPATH/src/github.com/linkedin/Burrow \
 && gpm install \
 && go install \
 && mv $GOPATH/bin/Burrow $GOPATH/bin/burrow \
 && apk --no-cache del git wget go

COPY etc/burrow/burrow.cfg \
     etc/burrow/logging.cfg \
     /etc/burrow/
CMD ["burrow", "-config", "/etc/burrow/burrow.cfg"]
