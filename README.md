# Imagem docker do jenkins para pipeline de aplicações Android e Testes de UI com Appium e Robot Frameworck
Este projeto foi criado para motivos academicos para minha aprendizagem pessoal
em docker, devops, deploy automatizados com [Jenkins](https://www.jenkins.io/), 
testes utilizado o [Appium](https://appium.io/) e [RobotFramework](https://robotframework.org/).

Feramentas instaladas na Imagem docker:
* [NodeJs](https://nodejs.org/en/)
* [AppiumJS](https://www.npmjs.com/package/appium)
* [AppiumDoctorJS](https://www.npmjs.com/package/appium-doctor)
* [RobotFramework](https://robotframework.org/)
* [RobotFrameworkAppium](https://github.com/serhatbolsu/robotframework-appiumlibrary)
* [AndroidStudio](https://developer.android.com/studio?hl=pt-br)
* [Java](https://www.java.com/pt-BR/download/ie_manual.jsp?locale=pt_BR) (opcional)
* [Python](https://www.python.org/)
* [Git](https://git-scm.com/)
* [Docker](https://www.docker.com/)
* [DockerCompose](https://docs.docker.com/compose/)
* [Jenkins](https://www.jenkins.io/)

## Screenshots
app view:

<img src="https://raw.githubusercontent.com/ismaelalvesgit/docker-jenkins-android/master/app.png" width="600" height="600">

## Development

### Setup

#### 1) Instalação docker
1º download [Docker](https://www.docker.com/)
Pare que seja feita a instalação do [Docker](https://www.docker.com/) em sua máquina pessoal
basta seguir esse [link](https://docs.docker.com/engine/install/) de instalação e instalar de 
acordo com seu SO (Sistema Operacional).

### 2) Gera Image
```sh

docker build -t nomeDaSuaImagem:tag .

```

### 3) Utilização da Image gerada via CMD
```sh

docker run -d --name jenkins --restart always -p 8080:8080 -p 50000:50000 \ 
-v ./jenkins_home:/var/jenkins_home -v ./jenkins_backup:/srv/backup \
nomeDaSuaImagem:tag # Windows Host 

# OU

docker run -d --name jenkins --restart always -p 8080:8080 -p 50000:50000 \ 
-v ./jenkins_home:/var/jenkins_home -v ./jenkins_backup:/srv/backup \
-v /var/run/docker.sock:/var/run/docker.sock -v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro nomeDaSuaImagem:tag # Linux Host

```

### 4) Utilização da Image gerada via docker-compose
```sh

docker-compose up -d

# Verifiricar aquivo `./docker-compose.yml` para configurações adicionais
```

## Extra
### 1) Como pegar password inicial do jenkins
```sh

docker exec -it ID_CONTAINER cat /var/jenkins_home/secrets/initialAdminPassword 

```

### 2) Deixei alguns plugins do Jenkins instalados para facilitação de uso da ferramenta.
´./plugins.txt´

### 3) Requisitos de HARDWARE
Bem como o [Jenkins](https://www.jenkins.io/) e um servidor de deploy exite um requisito de [HARDWARE](https://tecnoblog.net/311761/o-que-e-hardware/)
para sua utilização.

Requisitos Minimos
* HD - 70GB
* MEMORIA RAM - 4GB
* CPU - 3 CORE

Requisitos REcomendados
* HD - 70GB
* MEMORIA RAM - 6GB
* CPU - 4 CORE

Obs: NÃO TENTE RODA A IMAGE SE NÃO POSSUI OS REQUISITOS MINIMOS POIS A IMAGE FARA SEU DOCKER TRAVAR.


## Contato

Desenvolvido por: [Ismael Alves](https://github.com/ismaelalvesgit)

* Email: [cearaismael1997@gmail.com](mailto:cearaismael1997@gmail.com) 
* Github: [github.com/ismaelalvesgit](https://github.com/ismaelalvesgit)
* Linkedin: [linkedin.com/in/ismael-alves-6945531a0/](https://www.linkedin.com/in/ismael-alves-6945531a0/)

### Customização de Configurações do projeto
Verifique [Configurações e Referencias](https://www.jenkins.io/doc/book/).