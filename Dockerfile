FROM pypy:3.7-7-buster

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    groupadd -g ${PGID} webapp && \
    useradd -l -u ${PUID} -g webapp -m webapp && \
    usermod -p "*" webapp -s /bin/bash; exit 0;

USER webapp

WORKDIR /api

COPY ./requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD [ "pypy3", "-m" , "flask", "run", "--host=0.0.0.0"]
