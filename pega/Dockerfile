FROM busybox AS builder

# Expand prweb to target directory
COPY ./prweb.war /prweb.war
RUN mkdir prweb
RUN unzip -q -o prweb.war -d /prweb

FROM pegasystems/pega-ready

# Copy prweb to tomcat webapps directory
COPY --chown=pegauser:root --from=builder /prweb ${CATALINA_HOME}/webapps/prweb

RUN chmod -R g+rw ${CATALINA_HOME}/webapps/prweb

# Make a jdbc driver available to tomcat applications
COPY --chown=pegauser:root ./postgresql-42.6.0.jar ${CATALINA_HOME}/lib/

RUN chmod g+rw ${CATALINA_HOME}/webapps/prweb/WEB-INF/classes/prconfig.xml
RUN chmod g+rw ${CATALINA_HOME}/webapps/prweb/WEB-INF/classes/prlog4j2.xml