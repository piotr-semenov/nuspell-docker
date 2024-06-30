FROM alpine as builder
LABEL stage=intermediate

ARG nuspell_version=5.1.4

COPY ./apkfile ./dockerfile-commons/reduce_alpine.sh /tmp/.conf/
COPY ./repositories /etc/apk/

# hadolint ignore=SC2046
RUN apk update && \
    apk --no-cache add $(cat /tmp/.conf/apkfile)

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp/

# hadolint ignore=SC2046,DL3003
RUN \
    # Clone the specified version.
    git -c advice.detachedHead=false clone --depth 1 --branch "v$nuspell_version" https://github.com/nuspell/nuspell && \
    cd "$(basename "$_" .git)" && \
    \
    # Build & install.
    mkdir build && cd "$_" && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j && \
    make install && \
    \
    # Reduce to the minimal size distribution.
    sh /tmp/.conf/reduce_alpine.sh -v /target /usr/bin/nuspell \
                                              /usr/lib/libnuspell.so* \
                                              /usr/share/icu/ && \
    \
    # Clean out.
    apk del $(sed -e "s/@.*$//" /tmp/.conf/apkfile) && \
    rm -rf /tmp/*


FROM scratch

ARG vcsref
LABEL \
    stage=production \
    org.label-schema.name="tiny-nuspell" \
    org.label-schema.description="Minified Nuspell distribution." \
    org.label-schema.url="https://hub.docker.com/r/semenovp/tiny-nuspell/" \
    org.label-schema.vcs-ref="$vcsref" \
    org.label-schema.vcs-url="https://github.com/piotr-semenov/nuspell-docker.git" \
    maintainer="Piotr Semenov <piotr.k.semenov@gmail.com>"

COPY --from=builder /target /

ENTRYPOINT ["nuspell"]
