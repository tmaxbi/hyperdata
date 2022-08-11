from apache/nifi:1.15.3

WORKDIR /opt/nifi/nifi-current/

COPY --chown=nifi ozoneconf/core-site.xml ./conf/
COPY --chown=nifi ozoneconf/ozone-site.xml ./conf/
COPY --chown=nifi ozoneconf/hadoop-ozone-filesystem-hadoop3-1.0.0.jar ./conf/
COPY --chown=nifi alarmconf/collection.sh ./scripts/
