FROM openjdk:8-jdk

#ENV CERBERUS_URL=https://github.com/liuhuaian/gitskills/raw/lha/pt_hidoc/target/pt_hidoc-0.0.4-SNAPSHOT.jar

#RUN mvn clean package -Dmaven.test.skip=true -Dmaven.javadoc.skip=true

#RUN cd /opt \
	#&& COPY /pt_hidoc/target/pt_hidoc-0.0.4-SNAPSHOT.jar .

#RUN cd /opt \
#    && wget -O cerberus.jar "$CERBERUS_URL"
    
#COPY BOOT-INF /opt/BOOT-INF

#RUN cd /opt \
#    && jar uf cerberus.jar BOOT-INF
    
#EXPOSE 9999
#RUN cd /opt \
#	&& wget -O pt_hidoc-0.0.4-SNAPSHOT.jar "$CERBERUS_URL"

#CMD ["java", "-jar", "/opt/pt_hidoc-0.0.4-SNAPSHOT.jar"]

#安装maven
RUN mkdir /var/tmp/maven
RUN wget -P /var/tmp/maven http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN tar xzf /var/tmp/maven/apache-maven-3.3.9-bin.tar.gz -C /var/tmp/maven
RUN rm -rf /var/tmp/maven/apache-maven-3.3.9-bin.tar.gz
#设置maven环境变量
ENV MAVEN_HOME=/var/tmp/maven/apache-maven-3.3.9
ENV PATH=$MAVEN_HOME/bin:$PATH

ADD ./ /var/tmp
RUN cd /var/tmp && mvn package && cp /var/tmp/pt_hidoc/target/pt_hidoc-0.0.4-SNAPSHOT.jar /var/tmp

EXPOSE 8080

CMD ["java", "-jar", "/var/tmp/pt_hidoc-0.0.4-SNAPSHOT.jar"]