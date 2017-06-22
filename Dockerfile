FROM quay.io/kwiksand/cryptocoin-base:latest

RUN useradd -m digibyte

ENV DIGIBYTE_DATA=/home/digibyte/.digibyte

USER digibyte

RUN cd /home/digibyte && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone https://github.com/digibyte/digibyte.git digibyted && \
    cd /home/digibyte/digibyted && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L/home/digibyte/db4/lib/" CPPFLAGS="-I/home/digibyte/db4/include/" && \
    make 
    
EXPOSE 12024 14022

#VOLUME ["/home/digibyte/.digibyte"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && cp /home/digibyte/digibyted/src/digibyted /usr/bin/digibyted && chmod 755 /usr/bin/digibyted

ENTRYPOINT ["/entrypoint.sh"]

CMD ["digibyted"]
