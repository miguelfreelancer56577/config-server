FROM openjdk:11
RUN groupadd -r spring && useradd -r -g spring -ms /bin/bash config_usr
USER config_usr:spring
RUN mkdir -p ~/application/config-files
WORKDIR /home/config_usr/application/
ARG JAR_FILE=config-server-*.jar
COPY ${JAR_FILE} /home/config_usr/application/app.jar
ENTRYPOINT ["java","-jar","/home/config_usr/application/app.jar"]