# 自動化測試、錯誤通知及環境部屬

## 架構圖
![](https://i.imgur.com/WGMvmKt.png)

https://drive.google.com/file/d/1RWIvykLchEczREIB8VIlx_xHoJ6uz9EP/view?usp=sharing


## 使用技術
* Jenkins(pipline)
* AWS(ECS, EC2, VPC, Lambda, IAM)
* Docker
* Sonarqube
* Unit Test
* Slack(Slash Commands 發送API, Incoming WebHooks 接受通知)
* GitHub

AWS ECS 介紹: https://www.youtube.com/watch?app=desktop&v=22IsSW3YD0A&amp%3Bfeature=share

## 功能簡述
* create EC2(Ubuntu) at AWS（用途：架設服務用）
* create 3 containers(Jenkines, Sonarqube, nodejs(無使用)) at Ubuntu
* create GitHub Team and add member and push a project
* Jenkines Setting: 
    * install Jenkines外掛(nodejs, nonarqube, git)
    * create user auth for call Jankines api to run a task
    * create SSH key for Jenkines to Git pull a project
    * create Jenkines Credentials for sonarqube
    * pipline:
        * scan a project with sonarqube
        * use pipline to run unit test in a project
        * if success, create image to ECS
        * if fail, call slack api
* create Slack workspace
    * add apps "Slash Commands"
        *  call lambda
        *  call jenkines task
        *  call any middle ware
    * add apps "Incoming WebHooks"
        *  post messages from external sources into Slack


## 步驟說明
### create EC2(Ubuntu) at AWS

* EC2 容量選擇(Memory 4G)
* 開啟 VPC Port號
![](https://i.imgur.com/lcAyEVX.png)

* 修改資料夾權限
    *  若由資料夾由Container建立，預設使用者為 root，需修改資夾權限(Linux 系統才需要)
    *  資料捲容器綁定限制:綁定後將以主機的資料夾為主，無法是先放置資料於欲綁定的資料夾
> 查詢資料夾權限　`ls -al`
> 
> 欄位說明：權限／有多少檔案／擁有者／群組
![](https://i.imgur.com/hSEnoM4.png)
> 修改資料夾權限　`sudo chown -R <<帳號名稱 - ubuntu>> <<資料夾名稱>>`
> 

### create 3 containers(Jenkins, Sonarqube, nodejs(無使用)) at Ubuntu

* 一開始進入EC2後，安裝docker
    + docker
        + [Docker 學習筆記(二) — 安裝 Docker](https://medium.com/%E4%B8%80%E5%80%8B%E5%B0%8F%E5%B0%8F%E5%B7%A5%E7%A8%8B%E5%B8%AB%E7%9A%84%E9%9A%A8%E6%89%8B%E7%AD%86%E8%A8%98/docker-%E5%AD%B8%E7%BF%92%E7%AD%86%E8%A8%98-%E5%AE%89%E8%A3%9D-docker-8adb49a4c4ce)
        + `sudo apt-get install docker.io`
    + docker-compose
    > 備註:<br>
    > 安裝 Docker 後，Linux 會增加一個群組，名稱為 docker
    > 
    > `getent group`  // 查看群組

* docker相關指令
    * 利用 Dokerfile build Image
    > `sudo docker build --no-catch -t middle_ware`
    * 利用 Image 啟動 container，不會留下任何檔案
    > `sudo docker run -it --name middle_ware -p 8081:8081 <<container_name>>`
    * 當前目錄執行(-d 背景執行) docker-compose.yml
    > `docker-compose up -d`
    * 停止執行
    > `docker-compose stop`
    * 進入 Container
    > `docker exec -it <<containerID>> /bash`
    * 退出 Container, 尚未停止 Container
    > `Ctrl + P 及 Ctrl + Q`

    * 設定EC2每次啟動或重啟皆會創建 Container
    > `docker-compose.yml 中 restart:always`
    
* 安裝 git
    * pull a project





> 
### create GitHub Team and add member and push a project

### Jenkines Setting:
#### install Jenkines plugin(NodeJS Plugin, SonarQube for Jenkins, git, pipeline, aws, Publish over SSH)

#### create user auth for call Jankines api to run a task
* 設定 Jenkins 位置
![](https://i.imgur.com/EkEO3g0.png)

* 設定 Sonarqube 位置
![](https://i.imgur.com/RUREPTN.png)


* 設定 NodeJS plugin
![](https://i.imgur.com/LwIg3HS.png)

* 設定 Publish over SSH
![](https://i.imgur.com/krOrQ1e.png)
![](https://i.imgur.com/SsLyyGo.png)


* create user
![](https://i.imgur.com/15PWK3D.png)

* create user api token
![](https://i.imgur.com/IWOPSp9.png)


* create task token
![](https://i.imgur.com/mOQugYF.png)

> 
> `POST http://{{userID}}:{{EC2_IP}}:{{port}}/job/{{task-name}}/build?token={{TOKEN_NAME}}`
> 
> 
> Ex: http://ariel:119a1b1a101fe02fcd399e32eeb53b7b98@ec2-52-198-168-102.ap-northeast-1.compute.amazonaws.com:8080/job/app-new/build?token=TOKEN_NAME


#### create SSH key for Jenkines to Git pull a project


* 將公鑰存置 GitHub SSH and GPG keys
![](https://i.imgur.com/HxW6dnS.png)

* 將私鑰存置 Jenkins > 管理 Jenkins > Manage Credentials 建立新的 credentials
![](https://i.imgur.com/JRhXo3g.png)


> https://www.itread01.com/content/1537429111.html


#### create Jenkines Credentials for sonarqube
* sonarqube 建立 secret
![](https://i.imgur.com/VtLSp7U.png)


* Jenkins > 管理 Jenkins > Manage Credentials 建立新的 credentials，將 Secret 貼上
![](https://i.imgur.com/1N4KLF8.png)


#### 【pipline】scan a project with sonarqube
* 於Jenkines 的 container 中，安裝 sonarqube tool


> `docker exec -it <your-jinkins-container-id> bash`

> `cd /var/jenkins_home`

> `wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip`

> `unzip sonar-scanner-cli-4.2.0.1873-linux.zip`

* 在 jenkins 新增 sonarqube-scanner Tool

![](https://i.imgur.com/zYI8P7C.png)

![](https://i.imgur.com/tVujCXV.png)


* 設定 webhook，將 sonarqube 的結果回傳至 Jenkines
    * 登入Sonarqube(帳密預設: admin)

![](https://i.imgur.com/5qQDpfm.png)

![](https://i.imgur.com/pkT6eBL.png)
※ /sonarqube-webhook/ 是Jenkins安裝Sonarqube會自動產生的資料夾路徑

https://appfleet.com/blog/jenkins-pipeline-with-sonarqube-and-gitlab/

#### 【pipline】use pipline to run unit test in a project
* 啟動專案之 unit test 執行全部的 test
> `npm run test -- --watchAll=false`

#### 【pipline】if success, create image to ECS


#### 【pipline】if fail, call slack api



### create Slack workspace
#### add apps "Slash Commands"
用途: call lambda, call jenkines task, call any middle ware
 ![](https://i.imgur.com/vlsZfn0.png)
 ![](https://i.imgur.com/fkIeig5.png)
(1)呼叫 Jenkines task
![](https://i.imgur.com/XCM68lZ.png)
(2)呼叫 Lambda
![](https://i.imgur.com/ZqNwMdx.png)

 
 
#### add apps "Incoming WebHooks"
用途: post messages from external sources into Slack
![](https://i.imgur.com/DPHECFP.png)


### pipeline
```
pipeline {
  agent any
  tools {nodejs "nodejs"}
  stages {
    stage("Code Checkout from Github") {
      steps {
        git branch: 'master',
        credentialsId: 'e892a945-7be5-4442-a0bc-664a5b281ffe',
        url: 'git@github.com:happy-study-group/app.git'
      }
    }
    stage('Code Quality Check via SonarQube') {
      steps {
        script {
          def scannerHome = tool 'sonarqube-scanner';
          withSonarQubeEnv("app") {
            sh "${tool("sonarqube-scanner")}/bin/sonar-scanner \
           -Dsonar.projectKey=app \
           -Dsonar.sources=. \
           -Dsonar.css.node=. \
           -Dsonar.host.url=http://ec2-52-69-55-196.ap-northeast-1.compute.amazonaws.com:9000 \
           -Dsonar.login=47868682401ebd49857bc709760db043550b7c81"
          }
        }
        script {
            timeout(1) {

                //这里设置超时时间1分钟，不会出现一直卡在检查状态
                //利用sonar webhook功能通知pipeline代码检测结果，未通过质量阈，pipeline将会fail
                def qg = waitForQualityGate('app')
                println "1.${qg.status}"
                println "2.${qg}"
                //注意：这里waitForQualityGate()中的参数也要与之前SonarQube servers中Name的配置相同
                if (qg.status != 'OK') {
                    error "未通过Sonarqube的代码质量阈检查，请及时修改！failure: ${qg.status}"
                }

            }
        }
      }
    }
  }
  post {
    always {
      echo 'One way or another, I have finished'
      deleteDir()
      /* clean up our workspace */
    }
    success {
      echo 'I succeeded!'
    }
    unstable {
      echo 'I am unstable :/'
    }
    failure {
      echo 'I failed :('
    }
    changed {
      echo 'Things were different before...'
    }
  }
}
```



## 順利build image 的 pipeline
- Jenkins要ECR這個Plugin才能順利push image,
```

pipeline {
    agent any
    environment {
        registry = '254764208625.dkr.ecr.ap-northeast-1.amazonaws.com/study-ci'
        registryCredential = 'aws_ecr_credentials'
        dockerImage = ''
        userId = sh(script: "id", returnStdout: true)
        clusterName = 'Study-DEV'
        TAG = '1.1.2'
    }
    tools {nodejs "nodejs"}
    stages {
        // stage("Code Checkout from Github") {
        //     steps {
        //         git branch: 'master',
        //         credentialsId: 'e892a945-7be5-4442-a0bc-664a5b281ffe',
        //         url: 'git@github.com:happy-study-group/app.git'
        //     }
        // }
        stage('docker') {
            steps{
                script {
                    echo "123"
                    echo "${userId}"
                    echo "123"
                }
            }
        }
        // stage('Building image') {
        //     steps{
        //         script {
        //             dockerImage = docker.build registry + ":$TAG"
        //         }
        //     }
        // }
        
        stage('Push image') {
            steps{
                script{
                    docker.withRegistry("https://" + registry + ":$TAG","ecr:ap-northeast-1:" + registryCredential) {
                        def img = docker.image(registry + ":$TAG")
                        img.push()
                    }
                }
            }
        }
        
        
        stage('stop-task') {
            steps {
                sh  'taskDelete =`aws --profile wiedu ecs list-tasks --cluster "$ClusterName$typeLabel" --service-name "$typeLabel-Back-End" | jq --raw-output ".taskArns[0]"`'
                sh  'echo $taskDelete'
            // sh  'aws ecs stop-task --cluster "$ClusterName" --task "$taskDelete" --reason "change_image"'
            }
        }

        // stage('Deploy image') {
        //     sh  'ecs-deploy -p wiedu -c "$ClusterName" -n "Study-Cloud" -i ${registry}:$TAG -t 120'
        // }

    }
}

```