FROM postgres:13-bullseye

EXPOSE 5432

ENV PGDATA=/var/lib/postgresql/data

CMD ["postgres"]

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install git maven
RUN apt-get -y install postgresql-server-dev-13 libpq-dev libecpg-dev
RUN apt-get -y install g++ libkrb5-dev
RUN apt-get -y install openjdk-11-jdk

RUN git clone https://github.com/tada/pljava.git
RUN export PGXS=/usr/lib/postgresql/13/lib/pgxs/src/makefiles/pgxs.mk
WORKDIR /pljava
RUN git checkout V1_5_8
RUN mvn clean
RUN mvn install
RUN java -jar /pljava/pljava-packaging/target/pljava-pg13.11-amd64-Linux-gpp.jar

COPY enable-pljava.sh /docker-entrypoint-initdb.d/
