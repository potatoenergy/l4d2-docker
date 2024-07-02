FROM sonroyaalmerol/steamcmd-arm64:root AS build_stage

LABEL maintainer="ponfertato@ya.ru"
LABEL description="A Dockerised version of the Left 4 Dead 2 dedicated server for ARM64 (using box86)"

RUN dpkg --add-architecture amd64 \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    net-tools \
    lib32gcc-s1:amd64 \
    lib32stdc++6 \
    lib32z1 \
    libcurl3-gnutls:i386 \
    libcurl4-gnutls-dev:i386 \
    libcurl4:i386 \
    libgcc1 \
    libncurses5:i386 \
    libsdl1.2debian \
    libtinfo5 \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm -rf /var/lib/apt/lists/*

ENV HOMEDIR="/home/steam" \
    STEAMAPPID="222860" \
    STEAMAPPDIR="/home/steam/l4d2-server"

COPY etc/entry.sh ${HOMEDIR}/entry.sh

WORKDIR ${STEAMAPPDIR}

RUN chmod +x "${HOMEDIR}/entry.sh" \
    && chown -R "${USER}":"${USER}" "${HOMEDIR}/entry.sh" ${STEAMAPPDIR}

FROM build_stage AS bookworm-root

ENV L4D2_ARGS="" \
    L4D2_CLIENTPORT="27005" \
    L4D2_IP="" \
    L4D2_LAN="0" \
    L4D2_MAP="c1m1_hotel" \
    L4D2_MAXPLAYERS="12" \
    L4D2_PORT="27015" \
    L4D2_SOURCETVPORT="27020" \
    L4D2_TICKRATE=""

EXPOSE ${L4D2_CLIENTPORT}/udp \
    ${L4D2_PORT}/tcp \
    ${L4D2_PORT}/udp \
    ${L4D2_SOURCETVPORT}/udp

USER ${USER}
WORKDIR ${HOMEDIR}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD netstat -l | grep "${L4D2_PORT}.*LISTEN"

CMD ["bash", "entry.sh"]