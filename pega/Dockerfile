FROM alpine:3.18 AS builder

# Expand prweb to target directory
COPY ./prweb.war /prweb.war
RUN mkdir prweb
RUN unzip -q -o prweb.war -d /prweb

RUN mkdir -p /opt/pega/node_exporter
WORKDIR /opt/pega/node_exporter
RUN apk add --no-cache wget
RUN apk add --no-cache tar
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
RUN tar xvfz node_exporter-1.6.0.linux-amd64.tar.gz

FROM pegasystems/pega-ready

# Use root to install systemctl
USER root

RUN apt-get update
RUN apt-get install -y systemctl

# Copy node_exporter files
COPY --chown=pegauser:root --from=builder /opt/pega/node_exporter/node_exporter-1.6.0.linux-amd64 /opt/pega/node_exporter
COPY --chown=pegauser:root ./node_exporter/enable.sh /opt/pega/node_exporter

# Privileges to pegauser
RUN chmod u+x -R /opt/pega/node_exporter
RUN mkdir /home/pegauser
RUN chown pegauser:root -R home/pegauser

# Change to pegauser
USER pegauser

# Enable node_exporter service in user context
RUN mkdir -p /home/pegauser/.config/systemd/user
RUN /opt/pega/node_exporter/enable.sh

# Copy prweb to tomcat webapps directory
COPY --chown=pegauser:root --from=builder /prweb ${CATALINA_HOME}/webapps/prweb

RUN chmod -R g+rw ${CATALINA_HOME}/webapps/prweb

# Make a jdbc driver available to tomcat applications
COPY --chown=pegauser:root ./postgresql-42.6.0.jar ${CATALINA_HOME}/lib/

RUN chmod g+rw ${CATALINA_HOME}/webapps/prweb/WEB-INF/classes/prconfig.xml
RUN chmod g+rw ${CATALINA_HOME}/webapps/prweb/WEB-INF/classes/prlog4j2.xml