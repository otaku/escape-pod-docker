FROM arm64v8/mongo:4.4.6-bionic

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install curl libsodium23 libopus0 xz-utils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/escapepod

RUN curl -sSfLo model.tflite https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/deepspeech-0.9.3-models.tflite && \
    curl -sSfLo model.scorer https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/deepspeech-0.9.3-models.scorer && \
    cd /usr/lib && \
    curl -sSfL https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/native_client.arm64.cpu.linux.tar.xz | tar -Jxf - libdeepspeech.so

COPY . .

ENV DDL_RPC_PORT=8084 \
    DDL_HTTP_PORT=8085 \
    DDL_OTA_PORT=8086 \
    DDL_UI_PORT=80 \
    \
    DDL_SAYWHATNOW_STT_MODEL=/usr/local/escapepod/model.tflite \
    DDL_SAYWHATNOW_STT_SCORER=/usr/local/escapepod/model.scorer \
    \
    DDL_DB_NAME=database \
    DDL_DB_HOST=127.0.0.1 \
    DDL_DB_PORT=27017 \
    DDL_DB_USERNAME=myUserAdmin \
    DDL_DB_PASSWORD=MzBmMWFmY2NhYzE0

EXPOSE 8084
EXPOSE 8085
EXPOSE 8086
EXPOSE 80

ENTRYPOINT [ "/usr/local/escapepod/entrypoint.sh" ]
