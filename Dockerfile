FROM i386/debian:stable AS builder
RUN useradd -md /opt/geneshift geneshift
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl ca-certificates

ENV DUMB_INIT_VERSION=1.2.2 \
    GENESHIFT_VERSION=1264

RUN apt-get install curl ca-certificates -y

RUN curl -sSfLo /tmp/Geneshift${GENESHIFT_VERSION}.tar.gz "https://www.geneshift.net/downloads/Geneshift${GENESHIFT_VERSION}.tar.gz"
RUN curl -sSfLo /usr/bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64"
RUN tar -vxzf "/tmp/Geneshift${GENESHIFT_VERSION}.tar.gz" -C /opt/geneshift
RUN chmod a+x /usr/bin/dumb-init

FROM i386/debian:stable
RUN useradd -md /opt/geneshift geneshift
RUN apt-get update && apt-get upgrade -y

COPY --from=builder /usr/bin/dumb-init /usr/bin/
COPY --from=builder --chown=geneshift /opt/geneshift/* /opt/geneshift/
ADD run.sh /usr/local/bin/

VOLUME /config

EXPOSE 11235/udp

USER geneshift

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/run.sh"]
