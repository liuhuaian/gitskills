FROM openjdk:8-jdk

#ENV CERBERUS_URL=https://github.com/liuhuaian/gitskills/raw/lha/pt_hidoc/target/pt_hidoc-0.0.4-SNAPSHOT.jar

RUN mvn clean package -Dmaven.test.skip=true -Dmaven.javadoc.skip=true

RUN cd /opt \
	&& COPY /pt_hidoc/target/pt_hidoc-0.0.4-SNAPSHOT.jar .

#RUN cd /opt \
#    && wget -O cerberus.jar "$CERBERUS_URL"
    
#COPY BOOT-INF /opt/BOOT-INF

#RUN cd /opt \
#    && jar uf cerberus.jar BOOT-INF
    
#EXPOSE 9999
#RUN cd /opt \
#	&& wget -O pt_hidoc-0.0.4-SNAPSHOT.jar "$CERBERUS_URL"

CMD ["java", "-jar", "/opt/pt_hidoc-0.0.4-SNAPSHOT.jar"]