FROM tomcat
COPY target/*.war /opt/tomcat/webapps/ROOT.war
