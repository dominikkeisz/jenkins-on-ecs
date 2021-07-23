FROM jenkins/jenkins:lts
LABEL maintainer="keisz.d@gmail.com"

USER root
RUN mkdir /var/log/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins
USER jenkins
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log"

EXPOSE 8080
EXPOSE 50000

VOLUME jenkins_home:/var/jenkins_home
