# @ Author Ismael Alves - Ùltima atualização 09/02/2021
FROM jenkins/jenkins:lts
LABEL maintainer="Ismael Alves <cearaismael1997@gmail.com>"
USER root

# Update jenkins & timezone
RUN wget http://updates.jenkins-ci.org/download/war/2.279/jenkins.war && \
    mv ./jenkins.war /usr/share/jenkins

# Docker
RUN apt-get update -qq && apt-get install apt-transport-https ca-certificates \ 
    curl gnupg-agent software-properties-common python python-pip python-dev -y && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian \ 
    $(lsb_release -cs) stable" && apt-get update -qq && apt-get install docker-ce \ 
    docker-ce-cli containerd.io -y && usermod -aG docker jenkins

# Java 11 & Git & Sshpass & Node js & Docker-compose
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && \
    curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose \
    -$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose  && \
    apt-get install make git openjdk-11-jdk sshpass gcc g++ make nodejs npm -y && \ 
    chmod +x /usr/local/bin/docker-compose 

# Appium (Node js) & Robot Framework (Python)
RUN npm i appium appium-doctor -g --unsafe-perm --silent && pip install --upgrade pip \ 
    robotframework Appium-Python-Client==0.52 robotframework-appiumlibrary

# Android SDK
RUN apt-get update -qq && apt-get install -yq libc6 libstdc++6 zlib1g libncurses5 \
    build-essential libssl-dev ruby ruby-dev --no-install-recommends && gem install bundler
RUN mkdir -p /usr/local/android-sdk-linux && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O tools.zip && \
    unzip tools.zip -d /usr/local/android-sdk-linux && \
    rm tools.zip && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && apt-get -y clean
    # Clear cache
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH
# Make license agreement & Update and install using sdkmanager
RUN mkdir $ANDROID_HOME/licenses && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
    echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 24333f8a63b6825ea9c5514f83c2829b004d1fee >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license && \
    $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;29.0.2" "build-tools;29.0.0" && \
    $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-30" "platforms;android-29" && \
    $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository"

# Set Enviroments variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV JAVA_OPTS "-Xmx8192m"
ENV TZ America/Fortaleza

# Plugins Install
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt