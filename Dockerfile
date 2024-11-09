# Use an official Tomcat image as a base image
FROM tomcat:9.0

# Copy the WAR file to the webapps directory of Tomcat
COPY *.war /usr/local/tomcat/webapps/

# Expose port 8080 to access the app
EXPOSE 8080