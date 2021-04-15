FROM payara/server-web:5.194

LABEL  maintainer="Ioannis Angelakopoulos<ioagel@gmail.com>"

ENV MJDBC=8.0.18

USER root

RUN apt update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt install -y --no-install-recommends ttf-mscorefonts-installer && \
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MJDBC}.zip && \
    unzip mysql-connector-java-${MJDBC}.zip && \
    mv mysql-connector-java-${MJDBC}/mysql-connector-java-${MJDBC}.jar /opt/payara/appserver/glassfish/domains/domain1/lib/ && \
    mkdir -p /usr/share/fonts/default && \
    cp -r /usr/share/fonts/truetype/msttcorefonts /usr/share/fonts/default/TrueType && \
    apt-get purge -y --auto-remove ttf-mscorefonts-installer && \
    rm -rf /usr/share/fonts/truetype/msttcorefonts /usr/share/fonts/X11 *.zip mysql* && \
    rm -rf /var/lib/apt/lists/*

# Optional: Customize it and use
COPY domain.xml default-web.xml /opt/payara/appserver/glassfish/domains/domain1/config/

RUN chown -R payara:payara /opt/payara

USER payara
