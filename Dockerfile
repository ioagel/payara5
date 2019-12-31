FROM payara/server-web:5.194

LABEL  maintainer="Ioannis Angelakopoulos<ioagel@gmail.com>"

ENV MJDBC=8.0.18 \
    APP_INSIGHTS_AGENT_VER=2.5.1

USER root

RUN apt update && \
    apt install -y --no-install-recommends tzdata && \
    wget https://github.com/microsoft/ApplicationInsights-Java/releases/download/${APP_INSIGHTS_AGENT_VER}/applicationinsights-agent-${APP_INSIGHTS_AGENT_VER}.jar \
         -P /opt/payara/appserver/glassfish/domains/domain1/lib/ && \
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MJDBC}.zip && \
    unzip mysql-connector-java-${MJDBC}.zip && \
    mv mysql-connector-java-${MJDBC}/mysql-connector-java-${MJDBC}.jar /opt/payara/appserver/glassfish/domains/domain1/lib/ && \
    rm -rf *.zip mysql* /var/lib/apt/lists/*

COPY AI-Agent.xml /opt/payara/appserver/glassfish/domains/domain1/lib/AI-Agent.xml
COPY domain.xml default-web.xml /opt/payara/appserver/glassfish/domains/domain1/config/

RUN chown -R payara:payara /opt/payara

USER payara
