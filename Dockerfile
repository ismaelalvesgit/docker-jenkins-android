# @ Author Ismael Alves - Ùltima atualização 09/02/2021
FROM jenkins/jenkins:lts
LABEL maintainer="Ismael Alves <cearaismael1997@gmail.com>"
USER root

# Update jenkins
RUN  wget http://updates.jenkins-ci.org/download/war/2.279/jenkins.war \
    && mv ./jenkins.war /usr/share/jenkins

# Docker
RUN apt-get update -qq \
    && apt-get install apt-transport-https ca-certificates curl gnupg-agent \
    software-properties-common python python-pip python-dev -y
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get install docker-ce docker-ce-cli containerd.io -y
RUN usermod -aG docker jenkins

# Docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose \
    -$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Java 8 & Git & Sshpass
RUN apt-get install -y make git openjdk-8-jdk sshpass && rm -rf /var/lib/apt/lists/*

# Node js
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
    && apt-get install -y gcc g++ make nodejs
    
# Appium (Node js) & Robot Framework (Python)
RUN npm i appium appium-doctor -g --unsafe-perm --silent && pip install --upgrade pip \ 
    robotframework Appium-Python-Client==0.52 robotframework-appiumlibrary

# Android SDK
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -yq libc6 libstdc++6 zlib1g libncurses5 build-essential libssl-dev ruby ruby-dev --no-install-recommends && \
    apt-get clean
RUN gem install bundler
RUN mkdir -p /usr/local/android-sdk-linux && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O tools.zip && \
    unzip tools.zip -d /usr/local/android-sdk-linux && \
    rm tools.zip
# Set environment variable
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH
# Make license agreement
RUN mkdir $ANDROID_HOME/licenses && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
    echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 24333f8a63b6825ea9c5514f83c2829b004d1fee >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license
# Update and install using sdkmanager
RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3" "build-tools;27.0.3" && \
    $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28" "platforms;android-27" && \
    $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository"

# Backup & Recover
RUN mkdir /srv/backup && chown jenkins:jenkins /srv/backup 

# # Plugins Install
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Enviroments
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_OPTS "-Xmx8192m"