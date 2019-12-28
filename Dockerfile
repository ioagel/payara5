FROM payara/server-web:5.194

LABEL  maintainer="Ioannis Angelakopoulos<ioagel@gmail.com>"

ENV MJDBC=8.0.18 \
    APP_INSIGHTS_AGENT_VER=2.5.1

USER root

RUN apt update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt install -y --no-install-recommends ttf-mscorefonts-installer && \
    wget https://github.com/microsoft/ApplicationInsights-Java/releases/download/${APP_INSIGHTS_AGENT_VER}/applicationinsights-agent-${APP_INSIGHTS_AGENT_VER}.jar \
         -P /opt/payara/appserver/glassfish/domains/domain1/lib/ && \
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MJDBC}.zip && \
    unzip mysql-connector-java-${MJDBC}.zip && \
    mv mysql-connector-java-${MJDBC}/mysql-connector-java-${MJDBC}.jar /opt/payara/appserver/glassfish/domains/domain1/lib/ && \
    mkdir -p /usr/share/fonts/default && \
    cp -r /usr/share/fonts/truetype/msttcorefonts /usr/share/fonts/default/TrueType && \
    apt-get purge -y --auto-remove ttf-mscorefonts-installer && \
    rm -rf /usr/share/fonts/truetype/msttcorefonts /usr/share/fonts/X11 *.zip mysql* && \
    rm -rf /var/lib/apt/lists/*

COPY AI-Agent.xml /opt/payara/appserver/glassfish/domains/domain1/lib/AI-Agent.xml

RUN chown -R payara:payara /opt/payara

USER payara
