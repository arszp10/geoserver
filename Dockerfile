FROM tomcat:9-jdk11-openjdk

ARG GEOSERVER_VERSION=2.22.2
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

WORKDIR $GEOSERVER_DATA_DIR

WORKDIR $CATALINA_HOME/webapps/geoserver
RUN wget -qO geoserver.zip https://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip && \
  unzip -q geoserver.zip geoserver.war && \
  unzip -q geoserver.war && \
  rm -rf geoserver.zip geoserver.war data && \
  mv WEB-INF/lib/marlin-0.9.3.jar $CATALINA_HOME/lib/marlin.jar

RUN wget -qO gwc-sqlite-plugin.zip https://build.geoserver.org/geoserver/2.22.x/community-2023-03-21/geoserver-2.22-SNAPSHOT-gwc-sqlite-plugin.zip && \
  unzip -qo gwc-sqlite-plugin.zip -d WEB-INF/lib && \
  rm gwc-sqlite-plugin.zip

ENV GEOSERVER_CSRF_DISABLED true
ENV CATALINA_OPTS "-server -Djava.awt.headless=true \
  -Xms1G -Xmx4G -XX:+UseConcMarkSweepGC -XX:NewSize=48m -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:-UsePerfData \
  -Dorg.geotools.referencing.forceXY=true -Dorg.geotoools.render.lite.scale.unitCompensation=true -Dorg.geotools.coverage.jaiext.enabled=true \
  -Xbootclasspath/a:$CATALINA_HOME/lib/marlin.jar -Dsun.java2d.renderer=org.marlin.pisces.MarlinRenderingEngine \
  -Dfile.encoding=UTF-8 -Djavax.servlet.request.encoding=UTF-8 -Djavax.servlet.response.encoding=UTF-8 -Duser.timezone=UTC -DALLOW_ENV_PARAMETRIZATION=true"

RUN groupadd -g 1000 tomcat && useradd -u 1000 -ms /bin/bash -g tomcat tomcat && \
  chown -R 1000:1000 $CATALINA_HOME $GEOSERVER_DATA_DIR
USER tomcat

HEALTHCHECK --start-period=20s --interval=20s --timeout=5s --retries=10 CMD curl -f http://localhost:8080/geoserver/web || exit 1

VOLUME $GEOSERVER_DATA_DIR

EXPOSE 8080

ENTRYPOINT ["catalina.sh"]
CMD ["run"]